
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
                puts -nonewline " June and Julie are sitting just outside their tent, talking\
                amongst themselves."
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
            {"Talk to June and Julie" {[state get abduction-discovered] eq {yes}} juneJulie}
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
            {"\"I need your help. Masnin Alja sent me.\"" {[state get abduction-escape] eq {rumors}} tentHelp}
        }
    }

    proc tentHelp {} {
        puts "The voice is silent for a moment, and you can hear both of them whispering\
        for a few seconds. Then the two emerge from the tent slowly. You can now get a better\
        look at them, without their cloaks on. The two girls definitely look unusual. The first,\
        presumably the one who was speaking, has bright red skin and a look of fear mixed\
        with determination in her eyes. The second has bright green skin, is slightly shorter\
        than the first, and wears classes. The first woman steps in front of the other and\
        speaks again after a moment."
        puts "\"Did you also escape the lab?\""
        prompt {} {
            {"Explain" yes tentHelp1}
        }
    }

    proc tentHelp1 {} {
        puts "You explain your situation to the two, who listen intently the whole time and\
        seem to understand. As you finish the story, they both start to look a little more\
        relaxed."
        puts "\"I understand. It's good to meet you. My name is June.\""
        puts "June gestures to the green-skilled woman."
        puts "\"And this is my sister, Julie. We were both abducted several months ago.\
        The aliens took us to some sort of science lab, where they started experimenting\
        on us. That's when we started looking like... this.\""
        puts "June pauses for a moment."
        prompt {} {
            {"\"I understand they were trying to create soldiers...\"" yes tentHelp2}
        }
    }

    proc tentHelp2 {} {
        puts "\"I think so. Julie and I reacted differently to their tests. I\
        can fire beams of light from my body. And Julie, she can manipulate the\
        hand of Lady Luck herself. Once we learned how to use these abilities,\
        we planned our escape. I took care of all the guards, and with Julie's\
        good luck all of the electronic locks on the doors failed. We stole some\
        credentials and an oxygen tank off one of the scientists and headed to\
        the place where they keep the ships.\""
        prompt {} {
            {"\"And then you met Masnin?\"" yes tentHelp3}
        }
    }

    proc tentHelp3 {} {
        puts "\"Right. He was there investigating their technology. At first\
        we thought he was one of them. But he led us to a craft and showed us\
        how to get away. I don't know if Julie's power brought him to us, but\
        we wouldn't be here without his help.\""
        puts "June takes a breath, and Julie takes over telling the story."
        puts "\"Once we crashed back on earth, we knew we couldn't go home. We\
        stay in this tent most of the time, occasionally moving to a motel if\
        we get enough money somehow. We swore off using our powers the day we\
        go back; it's just a painful reminder of all we went through.\""
        prompt {} {
            {"\"I'm sorry.\"" yes tentHelp4}
        }
    }

    proc tentHelp4 {} {
        puts "\"Thank you.\""
        puts "June steps in once again."
        puts "\"We can't offer you much. But if you're looking to go back up there somehow,\
        we can give you the things we stole from the lab. Surely, they'll do more good for\
        you than they're doing for us right now.\""
        puts "June returns to the tent to collect some items and then steps back out to\
        hand them to you."
        puts "\"Here. It's a badge that should let you move around the military base\
        freely. And here's the oxygen tank we took. It must be some sort of advanced\
        tech, because it never seems to run out of oxygen.\""
        puts "You got the Intern's Badge and the Oxygen Pocket Dimension!"
        inv add {Intern's Badge}
        inv add {Oxygen Pocket Dimension}
        state put abduction-escape acquired
        state put abduction-discovered yes
        prompt {} {
            {"\"Thank you.\"" yes river}
        }
    }

    proc juneJulie {} {
        puts "\"I hope you find what you're looking for on the moon.\""
        prompt {} {
            {"Leave them" yes river}
        }
    }

}
