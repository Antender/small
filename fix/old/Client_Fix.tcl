set channel [socket 109.252.67.47 6040]
set text "8=FIXT.1.1\0019=93\00135=A\00149=FGW\00156=FIXCNTR1\0011128=9\00198=0\001108=10\001141=Y\0011137=9\0011409=0\00110=198\001"
puts -nonewline $channel "$text"
flush $channel
vwait forever