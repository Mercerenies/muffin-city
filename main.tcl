#!/usr/bin/tclsh

source prompt.tcl
source state.tcl
source inv.tcl
source muffins.tcl

source unimpl.tcl

set mapping {
    City ./city/base.tcl
    Prison ./prison/base.tcl
    Underworld ./underworld/base.tcl
    Dream ./dream/base.tcl
    Warehouse ./warehouse/base.tcl
    Past ./past/base.tcl
    Subspace ./subspace/base.tcl
}

proc handleMapping {loc} {
    variable mapping
    if {[regexp {^::([^ :]*)::} $loc -> group]} then {
        if {![namespace exists $group]} then {
            source [dict get $mapping $group]
        }
    }
}

puts "You enter the city for the first time."
puts {}
puts "(Note: use 'help' for a list of the special commands you can use.)"
puts {}

#catch {
set loc ::City::District::entrance
while {$loc ne {-gameover}} {
    if {[prefix $loc] eq {}} then {
        set loc "[prefix $prev]$loc"
    }
    set prev $loc
    handleMapping $loc
    set loc [eval $loc]
}
#}
