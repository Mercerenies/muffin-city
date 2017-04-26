
namespace eval Muffins {

    variable impl {}

    proc _find {item} {
        variable impl
        lsearch -exact $impl $item
    }

    proc add {item} {
        variable impl
        lappend impl $item
    }

    proc remove {item} {
        variable impl
        set loc [_find $item]
        if {$loc != -1} then {
            set impl [lreplace $impl $loc [expr {$loc + 1}]]
            return $item
        }
        return {}
    }

    proc has {item} {
        expr {[_find $item] != -1}
    }

    proc all {} {
        variable impl
        return $impl
    }

    namespace export add remove has all

    namespace ensemble create -command ::muffin

}
