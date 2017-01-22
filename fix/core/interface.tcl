oo::class create Interface {
  variable main_connection connections input do_checksum
  constructor {} {
    set main_connection {}
    set connections {}
    set input {}
    set do_checksum 0
  }
  
  method Send {} { 
    if {$main_connection!={}} {
      fileevent $main_connection writable [$main_connection write $input]
    }
  }
  method Open {} {
    set input [read [set fid [open $StringToSend r]]]
    close $fid
  }
}

oo::class create GUI {
  superclass Interface
  method constructor {
    next
    package require Tk
    button .open    -text open    -command [callback Open]
    button .send    -text send    -command [callback Send]
    button .replace -text replace -command  Replace]
    button .replace_send -text {Replace&Send} -command [callback Send] {Replace;Send}]
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
  proc DisconnectionToList {number} {
  }
  proc ConnectionToList {addr port} {
  }
}

oo::class create Console {
  superclass Interface
  constructor {} {
    next
  }
}