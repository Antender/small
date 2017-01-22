proc dice {n m t} {
	for {set i 1} {$i<=$n} {append dice int(rand()*$m)+;incr i} {}
	expr ($dice $n+$t)
}