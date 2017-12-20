
namespace eval Space::Moon {

    proc humanBase {} {
        puts "== Moon Base =="
        # ////
        prompt {} {
            {"Use the teleporter" yes teleporter}
        }
    }

    proc teleporter {} {
        if {[state get moon-teleport] eq {yes}} then {
            puts "You step inside the teleportation device. A white light engulfs you,\
            and when the light clears, you are in a different location."
            puts {}
            return ::Space::Satellite::transportBay
        } else {
            puts "The teleporter appears to be inactive at the moment."
            puts {}
            return humanBase
        }
    }

}
