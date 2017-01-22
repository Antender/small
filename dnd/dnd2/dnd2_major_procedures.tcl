#Считает бонусы, зависящие от статов
proc calculate_bonuses char_dict {
	set race [dict get $char_dict Race]
	set tables [read [set fid [switch -- $race Dwarf {open core/systems/dnd2_stat_dwarf_bonuses.res r} Halfling {open core/systems/dnd2_stat_dwarf_bonuses.res r} Gnome {open core/systems/dnd2_stat_gnome_bonuses.res r} default {open core/systems/dnd2_stat_bonuses.res r}]]]
	close $fid
	lappend Con_Bonuses "HP_Adj Sys_Shock Resurrection_Survival Regeneration [if {($race=={Dwarf}) || ($race=={Gnome}) || ($race=={Halfling})} {subst {Magic_Save Poison_Save}} {subst Poison_Save}]"
	
	foreach {stat bonuses} "
		Str {Hit_Prob Dmg_Adj Weight_Allow Max_Press Open_Doors Open_Special_Doors Bend_Bars}
		Dex {Reac_Adj_Dex Missile_Atc_Adj Def_Adj}
		Con $Con_Bonuses
		Wis {Magical_Def_Adj Bonus_Spells_Lvl1 Bonus_Spells_Lvl2 Bonus_Spells_Lvl3 Bonus_Spells_Lvl4 Bonus_Spells_Lvl5 Bonus_Spells_Lvl6 Bonus_Spells_Lvl7 Ch_To_Fail_Spell}
		Int {Num_Of_Lang Spell_level Ch_To_Lrn_Spell Max_Spells_Lvl Illusion_Immunity}
		Cha {Max_Henchmen Loyality_Base Reac_Adj_Cha} " {
		set value [dict get $char_dict Abilities $stat] 
			foreach bonus $bonuses {
				dict set char_dict Primary_Bonuses $bonus [lindex [dict get $tables $bonus] $value]
			}
		} 
	set char_dict
}	

#Обращение к таблице прогрессии спеллов (волшебника)
proc wizard_spell_tables {table_type char_dict} {
	set spell_tables [read [set fid [open core/systems/dnd2_"$table_type"_spell_progression_tables.res r]]
	close $fid
	set level [dict get $char_dict Class Level]
	for {set i 1} {$i<=9} {incr i} {
		dict set char_dict Wizard_Spells Lvl$i Max_Remembered [lindex [dict get $spell_tables $level] $i]
		if {([regexp [dict get $char_dict Class Class] Abjurer|Conjurer|Diviner|Enchanter|Illusionist|Evoker|Necromancer|Transmuter]!=-1) && ([dict get $char_dict Wizard_Spells Lvl$i Max_Remembered]!=0)} {
		dict set char_dict Wizard_Spells Lvl$i Max_Remembered [expr [dict get $char_dict Wizard_Spells Lvl$i Max_Remembered]+1]} {}
	}
	set char_dict
}


#Обращение к таблице прогрессии спеллов (жреца)
proc priest_spell_tables {table_type char_dict} {
	set spell_tables [read [set fid [open core/systems/dnd2_"$table_type"_spell_progression_tables.res r]]
	close $fid
	set level [dict get $char_dict Class Level]
	switch -- [dict get $char_dict Abilities Wis] {
		17 {set n 6}
		18 {set n 7}
		default {set n 5}
	}
	for {set i 1} {$i<=$n} {incr i} {
		dict set char_dict Priest_Spells Lvl$i Max_Remembered [lindex [dict get $spell_tables $level] $i]
		if {([dict get $char_dict Class Class]==Priest]) && ([dict get $char_dict Priest_Spells Lvl$i Max_Remembered]!=0)} {
		dict set char_dict Priest_Spells Lvl$i Max_Remembered [expr [dict get $char_dict Priest_Spells Lvl$i Max_Remembered]+[dict get $char_dict Primary_Bonuses Bonus_Spells_Lvl$i]]} {}
	}
	set char_dict
}