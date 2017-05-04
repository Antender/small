set chatFileOut [open chat a]
set chatFileIn [open chat r]

proc saveToChatFile {} {
    global chatFileOut
    puts -nonewline $chatFileOut [read stdin]
    flush $chatFileOut
}

fconfigure stdin -blocking 0
fileevent stdin readable {saveToChatFile}

proc readFromChatFile {} {
    global chatFileIn
    puts -nonewline [read $chatFileIn]
    flush stdout
}

fconfigure $chatFileIn -blocking 0
fileevent $chatFileIn readable {readFromChatFile}
vwait forever