namespace eval ::fixtest {
variable MainChannel {} 
variable InputLog {} 
variable Status {}
variable StringToSend {}
variable DoChecksum on

proc Connected {channel clientaddr clientport} {
  variable MainChannel 
  variable InputLog 
  variable Status
  set MainChannel $channel
  set InputLog [open "test[clock format [clock seconds] -format {%Y_%m_%d_%H_%M_%S}].log" w]
  fconfigure $MainChannel -buffering full -blocking 0 -translation {binary binary}
  fconfigure $InputLog    -buffering none -blocking 0 -translation binary
  fileevent $MainChannel readable [namespace code Reading]
  set Status "Connection from $clientaddr registered"
}

proc Reading {} {
  variable MainChannel
  variable InputLog
  variable Status
  if {[eof $MainChannel]} {
    fileevent $MainChannel readable {}
    set MainChannel {}
    set Status Disconnected
  } else {
    set ReadingBuffer [read $MainChannel 1]
    puts -nonewline $InputLog $ReadingBuffer
    .messages insert end $ReadingBuffer
  }
}

proc Writing {} {
  variable MainChannel
  variable StringToSend
  variable Status
  puts -nonewline $MainChannel $StringToSend
  fileevent $MainChannel writable {}
  set StringToSend {}
  flush $MainChannel
  set Status "Sended: $StringToSend"
}

proc BodyLength {} {
  variable StringToSend 
  regsub -- {BodyLength} $StringToSend "9=[string length [string range $StringToSend [expr [string first BodyLength $StringToSend]+11] end]]" StringToSend
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

proc Send {} { 
  variable MainChannel 
  if {$MainChannel!={}} {
    fileevent $MainChannel writable [namespace code Writing]
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

proc Open {} {
  variable StringToSend
  set StringToSend [read [set fid [open $StringToSend r]]]
  close $fid
}

proc StartServer {port} {
    socket -server [namespace code Connected] $port
}

proc GUI {} {
  variable DoChecksum 0
  package require Tk
  
  button .open    -text open    -command [namespace code Open]
  button .send    -text send    -command [namespace code Send]
  button .replace -text replace -command [namespace code Replace]
  button .replace_send -text {Replace&Send} -command [namespace code {Replace;Send}]
  text   .messages 
  entry .stringToSend -textvariable [namespace current]::StringToSend
  checkbutton .checksum -text Checksum -variable [namespace current]::DoChecksum
  .checksum select
  label .status -textvariable [namespace current]::Status
  
  grid .messages     -         - 
  grid .stringToSend -         -     -sticky nesw
  grid .open         .replace  .send -sticky nesw
  grid .checksum     .replace_send - -sticky nesw
  grid columnconfigure . 0 -weight 7
  grid columnconfigure . 1 -weight 1
  bind all <F8> {console show}
  tkwait window .
}
}