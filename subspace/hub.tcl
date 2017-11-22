
namespace eval Subspace::Hub {

    proc hub {} {
        puts "== Subspace Hub =="
        puts -nonewline "The white void extends indefinitely in all directions. To the north,\
        there is an unnatural storm containing some sort of energy. To the east, there is\
        an enclosed room containing a projector and some other equipment. To the south, there is\
        a taco shop and a bank."
        if {[state get subspace-attic] eq {yes}} then {
            puts " A set of stairs hangs down from above, leading to an unusual floating room\
            in the sky."
        } else {
            puts {}
        }
        prompt {} {
            {"Enter the taco shop" yes tacoShop}
            {"Enter the bank" yes bank}
            {"Go upstairs" {[state get subspace-attic] eq {yes}} attic}
            {"Head toward the storm" yes storm}
            {"Head to the projection room" yes portalRoom}
        }
    }

    proc tacoShop {} {
        puts "== Subspace Taco Shop =="
        puts "The pleasant aroma of tacos is a refreshing break from the emptiness of\
        the remainder of subspace."
        # ////
        prompt {} {
            {"Head back outside" yes hub}
        }
    }

    proc bank {} {
        puts "== Subspace Bank =="
        puts "The bank is very orderly, with neat rows of seats for waiting\
        customers."
        # ////
        prompt {} {
            {"Head back outside" yes hub}
        }
    }

    proc portalRoom {} {
        puts "== Subspace Projection Room =="
        puts "The projector sits in the middle of the room and appears to currently be\
        inactive."
        # ////
        prompt {} {
            {"Head back to the hub" yes hub}
        }
    }

    proc storm {} {
        puts "== Subspace Storm =="
        puts "The storm rages on in all directions. It would be very easy to get lost in an\
        area like this."
        prompt {} {
            {"Head north" yes hub}
            {"Head west" yes hub}
            {"Head south" yes hub}
            {"Head east" yes hub}
        }
    }

    proc attic {} {
        puts "== Subspace Attic =="
        if {[state get subspace-attic] eq {no}} then {
            puts "You find yourself in a featureless white room. There are stairs leading up through\
            the ceiling, and a set of retracted stairs in the base of the floor. The retracted\
            stairs appear to be expandable if you were to press on them."
        } else {
            puts "You find yourself in a featureless white room. There is a set of stairs leading\
            up through the ceiling and a second set leading down through the floor."
        }
        prompt {} {
            {"Go upstairs" yes ::Underworld::Pits::secretRoom}
            {"Expand the stairs" {[state get subspace-attic] eq {no}} atticExpand}
            {"Go downstairs" {[state get subspace-attic] eq {yes}} hub}
        }
    }

    proc atticExpand {} {
        puts "You push the retracted staircase downward and it expands."
        puts {}
        state put subspace-attic yes
        return attic
    }

}
