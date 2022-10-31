set ns [new Simulator]
set nf [open out.nam w]
$ns namtrace-all $nf

# Define a 'finish' procedure
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out.nam &
	exit 0
}

#Creating nodes
set A [$ns node]
set B [$ns node]
set C [$ns node]
set D [$ns node]

#Creating links
$ns duplex-link $A $B 2Mb 10ms DropTail
$ns duplex-link $A $C 2Mb 10ms DropTail
$ns duplex-link $A $D 2Mb 10ms DropTail
$ns duplex-link $B $D 2Mb 10ms DropTail
$ns duplex-link $C $D 2Mb 10ms DropTail
$ns duplex-link $B $C 2Mb 10ms DropTail

#Setting color
$ns color 1 Green

#Creating UDP agent
set udp [new Agent/UDP]
$udp set fid_ 1
$ns attach-agent $A $udp 

#Creating null agent
set null [new Agent/Null]
$ns attach-agent $C $null

#Connecting udp and null
$ns connect $udp $null

#Creating CBR source
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp 

#Setting events
 $ns at 1.0 "$cbr start"
 $ns at 4.0 "$cbr stop"
 $ns at 5.0 "finish"

 $ns run
