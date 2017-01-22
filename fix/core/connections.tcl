oo::class create Connection {
  variable message status connection adress port closed 
  constructor {} {
    set message {}
    set status {}
    set connection {}
  }
  method Connected {new_connection new_address new_port} {
    set connection $new_connection
    set adress $new_address
    set port $new_port
    set closed false
    fconfigure $connection -buffering full -blocking 0 -translation {binary binary}
    fileevent  $connection readable [callback Reading]
    set status "Connection opened: $adress $port"
  }
  method Reading {} {
    if {[eof $connection] || [catch {read $connection}]} {
      fileevent $connection readable {}
      close $connection
      set closed true
      set status "Connection closed: $adress $port"
    } else {
      flush $connection
      append message [read $channel]
    }
  }
  method write {string_to_send} {
    if {$connection!={}} {
      puts -nonewline $connection $string_to_send
      flush $connection
      set status "Sended: $string_to_send"
    }
  }
  method status_changed? {callback} {
    trace variable status write [callback $callback] 
  }
  method message_changed? {callback} {
    trace variable message write [callback $callback]
  }
  method connection_created? {callback} {
    trace variable connection write [callback $callback]
  }
  method connection_closed? {callback} {
    trace variable closed write [callback $callback]
  }
}

oo::class create Server {
  superclass Connection
  constructor {new_port} {
    next
    socket -server [callback Connected] $new_port
  }
}

oo::class create Client {
  superclass Connection
  constructor {new_adress new_port} {
    next
    my connected [socket $new_adress $new_port] $new_address $new_port
  }
}