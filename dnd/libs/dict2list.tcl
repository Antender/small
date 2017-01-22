proc dict2list dictionary {
	set list_result {}
	dict for {Key Value} $dictionary {
		if {[catch {dict get $Value}]} {
			lappend list_result [mc $Key]:${Value}
		} {
			lappend list_result {} "   [mc $Key]" 
			set list_result [concat ${list_result} [dict2list $Value]]
			lappend list_result {}
		}
	}
	set list_result
}