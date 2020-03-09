
## THIS IS ALL DEBUG CODE ##

set debugMode true

## END DEBUG CODE ##

proc handleSpecial {answer} {
    variable debugMode
    switch $answer {
        quit {
            return -level 1 -code return -gameover
        }
        help {
            puts " * help - Displays this screen"
            puts " * inv - Displays your current inventory"
            puts " * muffins - Displays your current muffin count"
            puts " * quit - Quits the game immediately"
        }
        inv {
            if {[inv all] eq {}} then {
                set items {(None)}
            } else {
                set items [join [inv all] ", "]
            }
            puts " * You are currently carrying: $items"
        }
        muffins {
            if {[muffin all] eq {}} then {
                set items {(None)}
            } else {
                set items [join [muffin all] ", "]
            }
            puts " * You have collected the following muffins ([llength [muffin all]]): $items"
        }
        con {
            if {$debugMode} then {
                puts " * Go right ahead"
                puts -nonewline {> }
                flush stdout
                gets stdin answer
                if {[catch {eval $answer} val] != 0} then {
                    puts $val
                }
            }
        }
    }
    return
}

proc askUser {list} {
    variable answer
    puts -nonewline {> }
    flush stdout
    gets stdin answer
    while {[lsearch -exact $list $answer] eq {-1}} {
        handleSpecial $answer
        puts -nonewline {> }
        flush stdout
        gets stdin answer
    }
    puts {}
    return $answer
}

proc askAndGo {dict} {
    set result [askUser [dict keys $dict]]
    if {$result eq "-gameover"} then {
        return -gameover
    } else {
        dict get $dict $result
    }
}

proc prompt {nonstd std} {
    set lines [list]
    set options [list]
    set num 0
    foreach s $std {
        set cond [uplevel 1 "expr \[lindex {$s} 1\]"]
        if {$cond} then {
            set line [uplevel 1 "subst \[lindex {$s} 0\]"]
            lappend lines "[incr num]. $line"
            lappend options $num [lindex $s 2]
        }
    }
    foreach s $nonstd {
        set cond [uplevel 1 "expr \[lindex {$s} 1\]"]
        if {$cond} then {
            lappend options [lindex $s 0] [lindex $s 2]
        }
    }
    foreach line $lines {
        puts $line
    }
    askAndGo $options
}

# nonstd = {"Keyword" cond result}
# std    = {"Text" cond result}

proc _prefix {id} {
    if {[regexp {^::[^ ]*::} $id match]} then {
        return $match
    } else {
        return {}
    }
}

proc prefix {id args} {
    if {$args ne {}} then {
        upvar [lindex $args 0] var
        set var [_prefix $id]
        expr {$var ne {}}
    } else {
        _prefix $id
    }
}
