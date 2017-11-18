
namespace eval Prison::South {

    proc gate {} {
        puts "== Prison Gate - Inside =="
        switch [state get prison-guard] {
            fired - search {
                set guardDesc "A lone woman stands guarding the gate."
            }
            default {
                set guardDesc "A mustached man stands alone, guarding the prison gate."
            }
        }
        puts "You find yourself on the inside of the prison gate, just a thick chainlink fence shielding\
        you from the rest of the world. $guardDesc Wherever you are, you're nowhere near the city you\
        started out in, as the sun is high in the sky here."
        prompt {} {
            {"Go inside" yes hallway}
            {"Talk to the guard" yes ::Prison::Guard::talk}
        }
    }

    proc hallway {} {
        puts "== Prison Hall - South =="
        puts "The glum gray of the hallway stretches off into the distance. There are a few doors open\
        to either side of you."
        prompt {} {
            {"Walk down the hallway" yes ::Prison::North::hallway}
            {"Go to Cellblock F" yes cellblock}
            {"Try the janitor's closet door" yes janitorDoor}
            {"Go outside" yes gate}
        }
    }

    proc cellblock {} {
        puts "== Cellblock F =="
        puts "Cellblock F has a small collection of prison cells. Most of the inmates are out, presumably\
        exercising or working. Cell 14, in particular, appears to be open."
        prompt {} {
            {"Enter Cell 14" yes cell}
            {"Back to the hallway" yes hallway}
        }
    }

    proc janitorDoor {} {
        if {[state get janitor-door] eq {yes}} then {
            return janitorCloset
        }
        puts "== Janitor's Closet =="
        puts "The door to the janitor's closet seems to be jammed. The doorknob has a bit of give when you\
        try to turn it but not very much."
        prompt {} {
            {"Try to force the door" yes janitorDoor1}
            {"Walk away" yes hallway}
        }
    }

    proc janitorDoor1 {} {
        puts "That doesn't appear to be having any effect..."
        prompt {} {
            {"Keep trying" yes janitorDoor2}
            {"Give up" yes hallway}
        }
    }

    proc janitorDoor2 {} {
        puts "You force the door harder, but it doesn't open."
        prompt {} {
            {"Try harder" yes janitorDoor3}
            {"Leave" yes hallway}
        }
    }

    proc janitorDoor3 {} {
        puts "At last, the door jerks open! You stumble backward as it flies into your face."
        state put janitor-door yes
        puts {}
        return janitorCloset
    }

    proc janitorCloset {} {
        puts "== Janitor's Closet =="
        puts "The closet is fairly empty, aside from a mop and a few basic cleaning supplies."
        prompt {} {
            {"Go back out" yes hallway}
        }
    }

    proc cell {} {
        puts "== Cell F-14 =="
        puts -nonewline "You step into your cell. The amenities are basic, at best: a small toilet, a wooden\
        bedframe supporting a rough white mattress, and a rusty sink."
        if {[state get butler-game] eq {cell}} then {
            puts " A strange man in a butler's uniform is standing in the corner."
        } else {
            puts {}
        }
        prompt {} {
            {"Go to sleep" yes {::Dream::Transit::awaken ::Dream::Transit::thirdRoom}}
            {"Talk to the man" {[state get butler-game] eq {cell}} cellButler}
            {"Go back out" yes cellblock}
        }
    }

    proc cellButler {} {
        if {[state get heard-science] eq {no}} then {
            puts "\"I notice you've been running about quite a bit. I have some information which may\
            interest you. When you have the time, go to the Ritzy Inn & Suites, talk to Carl, and tell\
            him the Butler sent you. He will show you the way to something interesting.\""
            state put heard-science told
        } else {
            puts "\"I have nothing more to tell you now. When I have more information, I will find you.\""
        }
        puts {}
        return cell
    }

    proc entry {} {
        puts "The truck eventually pulls to a stop. A man opens the back door and speaks."
        if {[state get been-to-prison] eq {yes}} then {
            puts "\"Alright, you know the drill. Cell F-14. Get out!\""
            if {([inv count] > 0) && ([state get butler-game] eq {no})} then {
                state put butler-game cell
            }
        } else {
            puts "\"Alright, you're in Cellblock F, Cell 14. Don't cause any trouble. Now get out!\""
        }
        state put been-to-prison yes
        if {[state get awaiting-bus] eq {yes}} then {
            puts "You step out of the truck. There is a conspicuous bus parked on the curb."
        } else {
            puts "You step out of the truck."
        }
        prompt {} {
            {"Cooperate and enter the prison" yes cooperate}
            {"Run away" yes flee}
        }
    }

    proc cooperate {} {
        puts "You step inside and the prison gate closes behind you."
        puts {}
        return gate
    }

    proc flee {} {
        if {[state get prison-guard] eq {fired}} then {
            puts "You run off into the treeline, but the man is quicker. He and a woman standing guard\
            at the gate immediately pounce you, sending you toppling to the ground. They drag you into\
            the prison gates."
        } elseif {[state get prison-guard] eq {search}} then {
            puts "You run off into the treeline, but the man is quicker. He and the woman standing\
            guard at the gate immediately pounce you, sending you toppling to the ground. They drag\
            you into the prison gates."
        } else {
            puts "You run off into the treeline, but the man is quicker. He and a mustached guard\
            immediately pounce on you, sending you toppling to the ground. They quickly drag you over into\
            the prison gates."
        }
        puts "\"Don't even think about doing that again!\""
        puts {}
        return gate
    }

}
