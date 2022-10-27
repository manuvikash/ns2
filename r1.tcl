# create a simulator object
set ns [new Simulator]

# define different colors for nam data flows
$ns color 1 green
$ns color 2 red

# open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out.nam &
	exit 0
}


# create 4 nodes
set A [$ns node]
set B [$ns node]
set C [$ns node]
set D [$ns node]
set E [$ns node]

# create links between the nodes
$ns duplex-link $A $B 2Mb 10ms DropTail
$ns duplex-link $B $C 2Mb 10ms DropTail
$ns duplex-link $C $D 2Mb 10ms DropTail
$ns duplex-link $D $E 2Mb 10ms DropTail
$ns duplex-link $E $A 2Mb 10ms DropTail


# UDP traffic source
# create a UDP agent and attach it to node node 1
set udp [new Agent/UDP]
$ns attach-agent $B $udp
$udp set fid_ 2		# green color
$udp set class_ 2

# create a TCP agent and attach it to node node 0
set tcp [new Agent/TCP]
$ns attach-agent $A $tcp
$tcp set fid_ 1		# green color
$tcp set class_ 1


# create a CBR traffic source and attach it to udp
set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 500
$cbr set interval_ 0.005
$cbr attach-agent $udp

# create a FTP traffic source and attach it to tcp
set ftp [new Application/FTP]
set maxpkts_ 1000
$ftp attach-agent $tcp

# creat a Null agent (a traffic sink) and at
set null [new Agent/Null]
$ns attach-agent $D $null
$ns connect $udp $null


# creat a Sink agent (a traffic sink) and at
set sink [new Agent/TCPSink]
$ns attach-agent $E $sink
$ns connect $tcp $sink


# schedule events for all the flows
$ns at 3.0 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 3.0 "$ftp stop"
$ns at 5.0 "$cbr stop"


# call the finish procedure after 6 seconds of simulation time
$ns at 5.0 "finish"

# Print CBR packet size and interval
puts "CBR packet size = [$cbr set packet_size_]"

# run the simulation
$ns run



