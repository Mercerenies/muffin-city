
namespace eval Prison::Forest {

    proc gate {} {
        puts "== Prison Gate - Outside =="
        if {[state get awaiting-bus] eq {yes}} then {
            puts "You are on the outside of the prison gate. There is a bus parked on the curb. The\
            bus driver is waving you down."
            puts "\"Oi! You're that prisoner who was just released, right? I'm here to take you\
            back into town!\""
        } else {
            puts "You are on the outside of the prison gate. There is a single road running outside\
            the prison, and opposite it sits a large forest."
        }
        prompt {} {
            {"Go into the forest" yes trees}
            {"Board the bus" {[state get awaiting-bus] eq {yes}} bus}
        }
    }

    proc trees {} {
        puts "== Forest =="
        if {[state get awaiting-bus] eq {trees}} then {
            state put awaiting-bus yes
        }
        if {[state get hunter-trail] eq {no}} then {
            state put hunter-trail visited
        }
        puts -nonewline "The forest treeline is very thick, but a rough path seems to run\
        across it, leaading to a river on one side and a cave on the other."
        if {[state get hunter-trail] eq {forest}} then {
            puts -nonewline " The hunter from Shabby Jack's is standing by a tree."
        }
        if {[state get merchant-war] ni {no}} then {
            puts -nonewline " Upon inspection, one of the trees is taller than the rest,\
            seeming to almost tower over them."
        }
        puts {}
        prompt {} {
            {"Talk to the hunter" {[state get hunter-trail] eq {forest}} hunter}
            {"Examine the large tree" {[state get merchant-war] ni {no}} largeTree}
            {"Run in circles around the large tree" yes dizzy}
            {"Go back to the prison" yes gate}
            {"Enter the cave" yes cave}
            {"Head toward the river" yes river}
        }
    }

    proc hunter {} {
        puts "\"Hey, you were right! This is great huntin' spot!\""
        prompt {} {
            {"\"You should check out that cave.\"" yes hunter1}
            {"\"I want your hat.\"" {[state get pirate-attack] eq {hat1}} hunterHat}
            {"\"Glad I could help.\"" yes trees}
        }
    }

    proc hunter1 {} {
        puts "\"Huh? That cave is pitch black. I dunno that that's such a good idea...\""
        prompt {} {
            {"\"Sure it is. You've got your gun!\"" yes hunter2}
            {"\"Maybe you're right...\"" yes trees}
        }
    }

    proc hunter2 {} {
        puts "\"Nah, I think I should stay out here...\""
        prompt {} {
            {"\"Fair enough...\"" yes trees}
            {"\"Chicken!\"" yes hunter3}
        }
    }

    proc hunter3 {} {
        puts "The hunter races into the cave without another word."
        state put hunter-trail under
        puts {}
        return trees
    }

    proc hunterHat {} {
        puts "\"I like my hat!\""
        puts {}
        return trees
    }

    proc largeTree {} {
        if {[state get merchant-war] eq {noted}} then {
            puts "There is nothing immediately obvious at the base of\
            the tree."
        } else {
            puts "The tree still stands tall amongst the many others\
            in the forest, a large hole at its base."
        }
        prompt {} {
            {"Dig around the tree" {[state get merchant-war] eq {noted}} largeTreeDig}
            {"Go back" yes trees}
        }
    }

    proc largeTreeDig {} {
        if {[inv has {Shovel}]} then {
            puts "You use your Shovel to dig around the tree."
            puts "Dug up a Rusty Warehouse Key!"
            inv add {Rusty Warehouse Key}
            state put merchant-war warehouse
        } else {
            puts "You attempt to shovel dirt with your bare hands,\
            with limited success. If you had a Shovel, it would\
            probably be easier."
        }
        puts {}
        return trees
    }

    proc dizzy {} {
        puts "You elect to run in circles around the large tree, making yourself\
        extremely dizzy."
        prompt {} {
            {"Stop and regain your composure" yes dizzyRegain}
            {"Run blindly toward the treeline" yes dizzyRun}
        }
    }

    proc dizzyRegain {} {
        puts "You stop and place a hand on the tree, regaining your sense of balance."
        puts {}
        return trees
    }

    proc dizzyRun {} {
        puts "You dash off in a random direction without a second thought. By the\
        time you regain your sense of balance, you have arrived at a small cottage\
        by a river."
        puts {}
        return ::Prison::Cottage::yard
    }

    proc river {} {
        puts "== Forest River =="
        puts -nonewline "A peaceful, flowing river cuts the forest\
        into two parts. The water seems cold enough that you\
        wouldn't want to have to ford it."
        switch [state get abduction-discovered] {
            forest {
                puts -nonewline " There is a small tent set up beside the river, underneath a\
                tree. You can see the shadows of two people inside the tent."
            }
            yes {
                # //// Are the two going to acknowledge the subspace portal? Looks kinda alien so it should be cause for concern for them
                # //// Also, just this in general
            }
        }
        if {[state get subspace-portal] eq {river}} then {
            puts -nonewline " There is a portal floating in the air next to the river. The portal\
            seems to lead to an empty white void."
        }
        puts {}
        prompt {} {
            {"Reach a hand into the river" yes riverReach}
            {"Pass through the portal" {[state get subspace-portal] eq {river}} ::Subspace::Portal::portalRoom}
            {"Approach the tent" {[state get abduction-discovered] eq {forest}} tent}
            {"Head into the forest" yes trees}
        }
    }

    proc riverReach {} {
        switch [state get forest-river] {
            0 {
                puts "You reach your hand into the freezing water and find a Silver Coin that someone\
                carelessly tossed in."
                puts "You got a Silver Coin."
                inv add {Silver Coin}
                state put forest-river 1
            }
            1 {
                puts "You reach into the freezing water and feel nothing of interest, save for a few\
                small pebbles."
                state put forest-river 2
            }
            2 {
                puts "You reach back into the freezing water and pull out a small box. Inside the small\
                box, you find a muffin."
                puts "You got the Maple Muffin!"
                muffin add {Maple Muffin}
                state put forest-river 3
            }
            default {
                puts "You reach your hand into the water once again but find nothing of interest, aside from\
                a few pebbles and some dirt."
            }
        }
        prompt {} {
            {"Reach in again" yes riverReach}
            {"Head into the forest" yes trees}
        }
    }

    proc cave {} {
        puts "== Cave =="
        puts "The cave is pitch black, leaving you completely blind. You vaguely hear growling in the\
        distance."
        prompt {} {
            {"Press onward" yes caveDeath}
            {"Turn the Lantern on and press onward" {[inv has {Lantern}]} caveLight}
            {"Exit the cave" yes trees}
        }
    }

    proc caveDeath {} {
        puts "You press onward. The growling gets louder, and you can see nothing."
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door wildlife
        }
        puts {}
        return ::Underworld::Lobby::wildlife
    }

    proc caveLight {} {
        puts "Activating your Lantern, you carefully navigate the cave, avoiding the\
        deeper and more dangerous tunnels. You reach another exit, which opens into a\
        large cityscape."
        puts {}
        return ::Inverse::District::entrance
    }

    proc reverseCave {} {
        puts "== Cave =="
        puts "The cave is pitch black, and you can vaguely hear a growling sound\
        off in the distance."
        prompt {} {
            {"Press onward" yes caveDeath}
            {"Turn the Lantern on and press onward" {[inv has {Lantern}]} reverseCaveLight}
            {"Exit the cave" yes ::Inverse::District::entrance}
        }
    }

    proc reverseCaveLight {} {
        if {[state get cave-hideout] eq {yes}} then {
            puts "Activating your Lantern, you carefully navigate about the cave and\
            find yourself at the secret hideout."
            puts {}
            return ::Inverse::Hideout::mainRoom
        } else {
            puts "Activating your Lantern, you carefully navigate about the cave, avoiding\
            the more dangerous tunnels. Before too much longer, you find yourself back at the\
            city where you started."
            puts {}
            return ::Inverse::District::entrance
        }
    }

    proc reverseCaveExit {} {
        puts "You wander out of the hideout and into a dark cave. After wandering for a bit,\
        you find youtself back in the city."
        puts {}
        return ::Inverse::District::entrance
    }

    proc bus {} {
        puts "You step on board the bus, and the driver starts the engine."
        puts "..."
        puts "A short while later, the bus stops in a familiar city."
        puts "\"This is your stop. Congratulations on your freedom!\""
        state put awaiting-bus no
        puts {}
        return ::City::District::entrance
    }

    proc tent {} {
        puts "As you approach the tent, a young woman's voice shouts from within."
        puts "\"Leave us alone!\""
        puts "It sounds like one of the two women from Shabby Jack's this morning."
        prompt {} {
            {"Step away" yes river}
            {"\"Listen. I need your help.\"" {[state get abduction-escape] eq {rumors}} tentHelp}
        }
    }

    proc tentHelp {} {
        puts "\"What do you want from us?\""
        prompt {} {
            {"\"I want to infiltrate the alien research lab.\"" yes tentHelp1}
        }
    }

    proc tentHelp1 {} {
        puts "\"How do you know about that?\""
        # /////
        return -gameover
    }

}
