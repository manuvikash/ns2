#Create new simulator ns
set ns [new Simulator]

#set output trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Finish procedure
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
set E [$ns node]

#Coloring the nodes
$A color red
$B color blue
$C color yellow
$D color black
$E color green

#Colors for flow
$ns color 0 green
$ns color 1 red

#Creating the links
$ns duplex-link $A $B 2Mb 10ms DropTail
$ns duplex-link $B $C 2Mb 10ms DropTail
$ns duplex-link $C $D 2Mb 10ms DropTail
$ns duplex-link $D $E 2Mb 10ms DropTail
$ns duplex-link $E $A 2Mb 10ms DropTail

#setting udp connection
set udp0 [new Agent/UDP]
$ns attach-agent $B $udp0

#setting cbr source
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1000
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

#assigning fid for color 
$udp0 set fid_ 1

#setting tcp connection
set tcp0 [new Agent/TCP]
$ns attach-agent $A $tcp0 

#setting ftp source
set ftp [new Application/FTP]
$ftp attach-agent $tcp0

#asigning fid for color
$tcp0 set fid_ 0

#creating null agent for udp
set null0 [new Agent/Null]
$ns attach-agent $D $null0
$ns connect $udp0 $null0

#creating sink for tcp
set sink [new Agent/TCPSink]
$ns attach-agent $E $sink
$ns connect $tcp0 $sink


#Setting events
$ns at 3.0 "$cbr0 start"
$ns at 1.0 "$ftp start"
$ns at 3.0 "$ftp stop"
$ns at 5.0 "$cbr0 stop"
$ns at 5.0 "finish"
$ns run
