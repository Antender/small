package require TclOO
foreach file {callback connections actions interface} {
  source core/$file.tcl
}