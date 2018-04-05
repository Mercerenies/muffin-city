
namespace eval Subspace::Hub {

    proc hub {} {
        puts "== Subspace Hub =="
        puts -nonewline "The white void extends indefinitely in all directions. To the north,\
        there is an unnatural storm containing some sort of energy. To the east, there is\
        an enclosed room containing a projector and some other equipment. To the south, there is\
        a taco shop and a bank. Off to the northeast, there is a lone hill accompanied by a \
        large temple."
        if {[state get subspace-attic] eq {yes}} then {
            puts -nonewline " A set of stairs hangs down from above, leading to an\
            unusual floating room in the sky."
        }
        switch [state get taco-shop] {
            no - spoken - olive {
                set joe yes
                puts -nonewline " A strange man is sitting in the corner, with his arms wrapped\
                around his knees."
            }
        }
        puts {}
        prompt {} {
            {"Talk to the unusual man" {[state get taco-shop] in {no spoken olive}} hubJoe}
            {"Enter the taco shop" yes ::Subspace::Taco::shop}
            {"Enter the bank" yes bank}
            {"Go upstairs" {[state get subspace-attic] eq {yes}} attic}
            {"Head toward the hill" yes ::Subspace::Temple::hill}
            {"Head toward the storm" yes storm}
            {"Head to the projection room" yes ::Subspace::Portal::portalRoom}
        }
    }

    proc hubJoe {} {
        puts "\"So hungry...\""
        prompt {} {
            {"\"Why don't you go get a taco?\"" yes hubJoeTaco}
            {"\"I'm sorry.\"" yes hub}
        }
    }

    proc hubJoeTaco {} {
        if {[state get taco-shop] in {no spoken}} then {
            puts "\"The Taco Man won't serve tacos right now... something about\
            not having some ingredients.\""
            puts {}
            return hub
        } else {
            puts "\"Huh? The Taco Man has his olive now? Alright, that's a good idea.\""
            puts "The strange man heads toward the taco shop."
            puts {}
            state put taco-shop fed
            return hub
        }
    }

    proc bank {} {
        puts "== Subspace Bank =="
        puts -nonewline "The bank is very orderly, with neat rows of\
        seats for waiting customers. There are several offices off to\
        the side, each containing one or two bankers doing various work.\
        One of the offices is open."
        if {[state get golden-arches]} then {
            puts " To the left, there is a shining golden arch covering the wall."
        } else {
            puts {}
        }
        prompt {} {
            {"Enter the office" yes bankOffice}
            {"Pass through the golden arch" {[state get golden-arches]} ::Console::Hall::future}
            {"Head back outside" yes hub}
        }
    }

    proc bankOffice {} {
        puts "== Subspace Bank - Office =="
        puts "The banker's office is as orderly as the main room of the bank. A single man\
        sits behind the desk. He glances in your direction as you enter."
        prompt {} {
            {"\"Hi.\"" yes bankTalk}
            {"Leave the room" yes bank}
        }
    }

    proc bankTalk {} {
        puts "\"What can I help you with?\""
        prompt {} {
            {"\"Where is Atheena's diamond?\"" {[state get hero-crystal] eq {intro}} bankCrystal}
            {"\"Nothing right now.\"" yes bankOffice}
        }
    }

    proc bankCrystal {} {
        puts "\"All repossessed items are kept in the bank's vault, secured beyond the subspace\
        storm. If you want to reclaim it, you'll have to repay Atheena's debt of... 4000 Silver\
        Coins.\""
        prompt {} {
            {"Give him 4000 Silver Coins" {[inv count {Silver Coin}] >= 4000} bankNoWay}
            {"\"I can't afford that.\"" yes bankOffice}
        }
    }

    proc bankNoWay {} {
        puts "\"I don't believe you got all of that money without hacking the game.\""
        puts {}
        return bankOffice
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
