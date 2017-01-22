proc Eval {input} {
  global output
  set output $input
  while {[regexp {([0-9]+)d([0-9]+)} $output -> n m]} {
    for {set i 1} {$i<=$n} {append dice int(rand()*$m)+;incr i} {}
    set output [regsub {([0-9]+)d([0-9]+)} $output [expr ${dice}$n]] 
  }
  set output "=[expr $output]" 
}
font create big -size 20
grid [button .evaluate -font big -text {Eval} -command {Eval $input}] [entry .input -font big -textvariable input] [label .output -font big -textvariable output]
bind all <Return> {Eval $input}
tkwait window .