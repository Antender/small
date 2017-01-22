proc BodyLength {} {
  variable StringToSend
  regsub -- {(BodyLength,)(.*)} $StringToSend {\2} TempString
  regsub -- {BodyLength}        $StringToSend "9=[string length $TempString]" StringToSend
}

proc Checksum {} {
  variable StringToSend
  set count 0
  foreach character "[split $StringToSend {}]" {
    incr count [scan $character %c]
  }
  set count [expr $count-(entier($count/256)*256)]
  if {[string length $count]=={1}} {
    append StringToSend "10=00$count\001"
  } else {
    if {[string length $count]=={2}} {
      append StringToSend "10=0$count\001"
    } else {
      append StringToSend "10=$count\001"
    }
  }
}

proc Replace {} {
  variable StringToSend
  variable DoChecksum
  set StringToSend [string map " \
  CurrentDateTime [clock format [clock seconds] -format {%Y%m%d-%H:%M:%S.666}] \ 
  , \001 \
  " $StringToSend]
  BodyLength
  if {$DoChecksum=={1}} { 
    Checksum
  }
}
