oo::class create DnD2_Character {
  variable name gender race available_races abilities 
  constructor {} {
	  set race human
  }

  #Выбор пола и имени
  method set_personality {Name Gender} {
	  set gender $Gender
	  set name $Name
  }

  #Бросает статы
  method roll_stats {} {
	  foreach {stat} {str dex con int wis cha} {
		  dict set abilities $stat [dice 3 6 0]
	  }
  }

  #Возвращает доступные расы
  method stat_race_check {} {
    set available_races human
	  foreach {stat} {str dex con int wis cha} {
		  set $stat [dict get $abilities $stat]
	  }
	  if {$str>=8 && $dex<=17 && $con>=11 && $cha<=17} {lappend available_races dwarf}
	  if {$str>=6 && $con>=8 && $int>=6} {lappend available_races gnome}
	  if {$dex>=6 && $con>=6 && $int>=4} {
  	  lappend available_races half_elf
	    if {$con>=7 && $int>=8 && $cha>=8} {lappend available_races elf}
    }
	  if {$str>=7 && $dex>=7 && $con>=10 && $int>=6 && $wis<=17} {lappend available_races halfling}
  }

  #Процедуры выбора расы
  method dwarf_selected {} {
	  set languages dwarven
	  dict incr abilities con 1
	  dict incr abilities -1
	  dict set special_skills infravision normal
	  foreach skill {define_inclination find_tonnel find_secret_caves find_cave_traps define_depth} {
		  dict set special_skills $skill yes
	  }
  }

  method elf_selected {} {
	  set languages elven
	  dict incr abilities dex 1
	  dict incr abilities con -1
	  dict set spec_skills infravision normal
	  dict set resists charm 90
	  foreach weapon {bow short_sword long_sword} {
		  dict incr hit_bonuses $weapon 1
	  }
	  dict set spec_skills find_secret_door yes
	  dict set spec_skills find_secret_pass yes
  }

  method gnome_selected {} {
	  set languages gnomish
	  dict incr abilities int 1
	  dict incr abilities wis -1
	  dict set spec_skills infravision normal
	  foreach skill {define_inclination find_dangerous_walls define_direction define_depth} {
		  dict set spec_skills $skill yes
	  }
  }

  method half_elf_selected {} {
	  set languages common
	  dict set spec_skills infravision normal
	  dict set resists charm 30
	  dict set spec_skills find_secret_door yes
	  dict set spec_skills find_secret_pass yes
  }


  method halfling_selected {} {	
 	  set languages halfling
  	dict incr abilities dex 1
  	dict incr abilities str -1
  	if {[dice 1 100 0]<=15} {dict set spec_skills infravision normal
 	  } {if {[::commands::dice 1 100 0]<=25} {dict set spec_skills infravision weak}}  
    foreach skill {define_inclination define_direction} {
  		dict set spec_skills $skill yes
 	  }
  }

  method human_selected {} {
    set languages common
	  dict set spec_skills infravision no
  }

  #Сам выбор расы
  method select_race {Race} {
	  set race $Race
	  ${race}_Selected
	  my calculate_bonuses
  }

  #Возвращает доступные языки
  method languages_race_check {} {
	  switch -- $race {
	    dwarf {list common gnomish goblin kobold orcish}
	    elf {list common gnomish halfling goblin hobgoblin orcish gnoll}
	    gnome {list common dwarven halfling goblin kobold earth_animals}
	    half_elf {list common elven gnomish halfling goblin hobgoblin orcish gnoll}
	    halfling {list common dwarven elven gnomish goblin orcish}
	    human {list gnomish dwarven orcish halfling gnoll elven}
	  }
  }

  #Возвращает макс. число языков
  method max_languages {} {
	  dict get primary_bonuses num_of_lang
  }

  #Выбирает язык
  method select_languages {language} {
	  lappend languages $language
  }	

#Возвращает доступные классы
proc class_available_check char_dict {
	set Race [dict get Race]
	foreach stat {Str Dex Con Int Wis Cha} {
		set $stat [dict get Abilities $stat]
	}
	list classes_available
	if {Str>=9} {lappend classes_available Fighter} {}
	if {(Str>=12) && (Con>=9) && (Wis>=13) && (Cha>=17) && (Race==Human)} {lappend classes_available Paladin} {}
	if {(Str>=13) && (Dex>=13) && (Con>=14) && (Wis>=14) && ((Race==Human)||(Race=Elf)||(Race==Half_Elf))} {lappend classes_available Ranger} {}
	if {(Int>=9) && ((Race==Human)||(Race=Elf)||(Race==Half_Elf))} {
		lappend classes_available Mage
		if {(Wis<=15) && (Race==Human)} {lappend classes_available Abjurer} {}
		if {(Con<=15) && ((Race==Human)||(Race==Half_Elf))} {lappend classes_available Conjurer} {}
		if {(Wis<=16) && ((Race==Human)||(Race=Elf)||(Race==Half_Elf))} {lappend classes_available Diviner} {}
		if {(Cha<=16) && ((Race==Human)||(Race=Elf)||(Race==Half_Elf))} {lappend classes_available Enchanter} {}
		if {(Dex<=16) && ((Race==Human)||(Race=Gnome))} {lappend classes_available Illusionist} {}
		if {(Con<=16) && (Race==Human)} {lappend classes_available Evoker} {}
		if {(Wis<=16) && (Race==Human)} {lappend classes_available Necromancer} {}
		if {(Dex<=15) && ((Race==Human)||(Race==Half_Elf))} {lappend classes_available Transmuter} {}
		} {}
	if {Wis>=9} {lappend classes_available Cleric} {}
	if {(Wis>=12) && (Cha>=15) && ((Race==Human)||(Race==Half_Elf))} {lappend classes_available Druid} {}
	if {Dex>=9} {lappend classes_available Thief} {}
	if  {(Dex>=12) && (Int>=13) && (Cha>=15) && ((Race==Human)||(Race==Half_Elf))} {lappend classes_available Bard} {}
	set classes_available
}

#Вспомогательная процедура для выбора мульти-классов
proc MC_check {classes classes_available} {
	list multi_classes_available
	foreach multi_class {$classes} {
		set availability 1
		foreach class {$multi_class} {
			if {[lsearch $classes_available $class]==-1} {set availability 0} {}
		}
		if {$availability==1} {lappend multi_classes_available $multi_class} {}
	}
}	

#Возвращает список доступных мульти-классов
proc multi_class_available_check {char_dict classes_available} {
	set Race [dict get Race]
	list multi_classes_available
	switch -- $Race {
		Dwarf {set multi_classes_available [concat $multi_classes_available 
			[MC_check {{Fighter Thief} {Fighter Priest}}] $classes_available]}
		Elf {set multi_classes_available [concat $multi_classes_available
			[MC_check {{Fighter Mage} {Fighter Thief} {Mage Thief}}] $classes_available]}
		Gnome {set multi_classes_available [concat $multi_classes_available 
			[MC_check {{Fighter Priest} {Fighter Illusionist} {Fighter Thief} {Priest Illusionist} {Priest Thief} {Illusionist Thief}}] $classes_available]}
		Halfling {set multi_classes_available [concat $multi_classes_available 
			[MC_check {{Fighter Thief}} $classes_available]}
		Half_Elf {set multi_classes_available [concat $multi_classes_available 
			[MC_check {{Fighter Thief} {Fighter Priest} {Fighter Mage} {Priest Ranger} {Priest Mage} {Druid Mage} {Thief Mage} {Fighter Mage Priest} {Fighter Mage Druid} {Fighter Mage Thief}}] $classes_available]}
	}
}

#Выбор класса
proc Fighter_Selected {char_dict} {
	#НЕ ЗАБЫТЬ ПРИКРУТИТЬ ВЕПОН СПЕКИ
	set tables [read [set fid [open core/systems/dnd2_experience_tables.res r]]
	close $fid
	dict set char_dict Class Hit_Dice 10
	if {[dict get $char_dict Abilities Str]>=16} {dict set char_dict Class Exp_Bonus 10} {}
	dict set char_dict Class Level 1
	dict set char_dict Class Experience 0
	dict set char_dict Class Experience_To_Next_Level {lindex [dict get $tables $class] 2}
	set char_dict
}

proc Paladin_Selected {char_dict} {
	#НЕ ЗАБЫТЬ ПРИКРУТИТЬ БОНУСЫ К СПАС БРОСКАМ
	set tables [read [set fid [open core/systems/dnd2_experience_tables.res r]]
	close $fid
	dict set char_dict Class Hit_Dice 10
	if {([dict get $char_dict Abilities Str]>=16)&&([dict get $char_dict Abilities Cha]>=16)} {dict set char_dict Class Exp_Bonus 10} {}
	dict set char_dict Spec_Skills Find_Evil Yes
	dict set char_dict Spec_Skills Lay_Hands Yes
	dict set char_dict Spec_Skills Cure_Diseases 1
	dict set char_dict Spec_Skills Holy_Aura Yes
	#Проверить, что это
	dict set char_dict Max_Magic_Items 10
	dict set char_dict Resists Diseases 100
	dict set char_dict Class Level 1
	dict set char_dict Class Experience 0
	dict set char_dict Class Experience_To_Next_Level {lindex [dict get $tables $class] 2}
	set char_dict
}

proc Ranger_Selected {char_dict} {
	set tables [read [set fid [open core/systems/dnd2_experience_tables.res r]]
	close $fid
	dict set char_dict Class Hit_Dice 10
	if {([dict get $char_dict Abilities Str]>=16)&&([dict get $char_dict Abilities Dex]>=16)&&([dict get $char_dict Abilities Wis]>=16)} {dict set char_dict Class Exp_Bonus 10} {}
	dict set char_dict Spec_Skills Hide_In_The_Shadows 10
	dict set char_dict Spec_Skills Stealth 15
	#ПРИКРУТИТЬ ОТСУТСВИЕ ПЕНАЛЕЙ ДЛЯ ДУАЛОВ
	dict set char_dict Spec_Skills Beast_Taming 1
	dict set char_dict Spec_Skills Tracking 1
	dict set char_dict Class Level 1
	dict set char_dict Class Experience 0
	dict set char_dict Class Experience_To_Next_Level {lindex [dict get $tables $class] 2}
	dict set char_dict Class Armor_Allowed {Leather Studded_Leather}
	set char_dict
}

proc Mage_Selected {char_dict} {
	set tables [read [set fid [open core/systems/dnd2_experience_tables.res r]]
	close $fid
	dict set char_dict Class Hit_Dice 4
	if {[dict get $char_dict Abilities Int]>=16} {dict set char_dict Class Exp_Bonus 10} {}
	dict set char_dict Wizard_Spells Max_Allowed [dict get $char_dict Primary_Bonuses Max_Spells_Lvl]
	dict set char_dict Class Level 1
	set char_dict [::systems::wizard_spell_tables {wizard $char_dict}]
	dict set char_dict Class Experience 0
	dict set char_dict Class Experience_To_Next_Level {lindex [dict get $tables $class] 2}
	set char_dict
}

foreach specialist {Abjurer Conjurer Diviner Enchanter Illusionist Evoker Necromancer Transmuter} {
proc "$specialist"_Selected {char_dict} {
	#Подумать на тему +/- к спас-броскам
	set tables [read [set fid [open core/systems/dnd2_experience_tables.res r]]
	close $fid
	dict set char_dict Class Hit_Dice 4
	if {([dict get $char_dict Abilities Int]>=16)} {dict set char_dict Class Exp_Bonus 10} {}
	dict set char_dict Wizard_Spells Max_Allowed [dict get $char_dict Primary_Bonuses Max_Spells_Lvl]
	dict set char_dict Class Level 1
	set char_dict [::systems::wizard_spell_tables {wizard $char_dict}]
	dict set char_dict Class Experience 0
	dict set char_dict Class Experience_To_Next_Level {lindex [dict get $tables $class] 2}
	set char_dict
}
}

proc Priest_Selected {char_dict} {
	set tables [read [set fid [open core/systems/dnd2_experience_tables.res r]]
	close $fid
	dict set char_dict Class Hit_Dice 8
	if {([dict get $char_dict Abilities Wis]>=16)} {dict set char_dict Class Exp_Bonus 10} {}
	dict set char_dict Priest_Spells Max_Allowed [dict get $char_dict Primary_Bonuses Max_Spells_Lvl]
	dict set char_dict Class Level 1
	set char_dict [::systems::priest_spell_tables {priest $char_dict}]
	dict set char_dict Spec_Skills Turn_Undead 1
	dict set char_dict Class Experience 0
	dict set char_dict Class Experience_To_Next_Level {lindex [dict get $tables $class] 2}
	set char_dict
}

proc Druid_Selected {char_dict} {
	set tables [read [set fid [open core/systems/dnd2_experience_tables.res r]]
	close $fid
	dict set char_dict Class Hit_Dice 8
	if {([dict get $char_dict Abilities Wis]>=16)&&([dict get $char_dict Abilities Cha]>=16)} {dict set char_dict Class Exp_Bonus 10} {}
	dict set char_dict Priest_Spells Max_Allowed [dict get $char_dict Primary_Bonuses Max_Spells_Lvl]
	dict set char_dict Class Level 1
	set char_dict [::systems::priest_spell_tables {priest $char_dict}]
	dict lappend char_dict Languages Druid
	dict set char_dict Save_Throws Fire 2
	dict set char_dict Save_Throws Electricity 2
	dict set char_dict Class Experience 0
	dict set char_dict Class Experience_To_Next_Level {lindex [dict get $tables $class] 2}
	set char_dict
}
	
	
proc select_class {char_dict class} {
	dict set char_dict Class Class $class
	set char_dict [${class}_Selected $char_dict]
}
}