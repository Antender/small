#Подключение исходников по папкам
foreach group {libs commands systems gui} {
	namespace eval $::group {
		set file_contents [read [set fid [open "core/$::group.cfg" r]]]
		close $fid
		foreach string $file_contents {
			source "core/$::group/$string.tcl"
		}
		unset file_contents
		unset fid
	}
}
