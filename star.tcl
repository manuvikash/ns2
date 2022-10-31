#creating simulator object
set ns [new Simulator]

#opening trace file to write
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

#Setting nodes
set 0 [$ns node]
set 1 [$ns node]
set 2 [$ns node]
set 3 [$ns node]
set A [$ns node]

#Setting colors
$0 color red
$1 color red
$2 color red
$3 color red
$A color green

#Setting flow colors
$ns color 0 blue
$ns color 1 pink

#Setting links
$ns duplex-link $0 $A 2Mb 10ms DropTail
$ns duplex-link $1 $A 2Mb 10ms DropTail
$ns duplex-link $2 $A 2Mb 10ms DropTail
$ns duplex-link $3 $A 2Mb 10ms DropTail

#Setting TCP agent
set tcp [new Agent/TCP]
$ns attach-agent $0 $tcp
$tcp set fid_ 0

#Setting FTP source
set ftp [new Application/FTP]
$ftp attach-agent $tcp

#Setting sink for TCP
set sink [new Agent/TCPSink]
$ns attach-agent $2 $sink

#Connecting TCP and sink
$ns connect $tcp $sink

#Setting UDP
set udp [new Agent/UDP]
$ns attach-agent $1 $udp
$udp set fid_ 1

#Creating CBR source
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type CBR
$cbr set packetsize 1000
$cbr set rate 1mb
$cbr set random false

#Setting NULL agent
set null [new Agent/Null]
$ns attach-agent $3 $null

#Connecting UDP and null
$ns connect $udp $null

#Setting events
$ns at 1.0 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 3.0 "$ftp stop"
$ns at 4.5 "$cbr stop"
$ns at 5.0 "finish"

$ns run