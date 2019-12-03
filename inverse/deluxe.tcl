
namespace eval Inverse::Deluxe {

    proc entry {} {
        puts "You enter the dark passage, and the wall seals itself shut\
        behind you."
        puts {}
        return topOfStairs
    }

    proc topOfStairs {} {
        puts "=~ Secret Basement - Stairwell ~="
        puts "The stairwell is very dimly lit. You can see only a handful\
        of steps in front of you. The passage behind is already sealed, and\
        there appears to be no other wait out except down."
        prompt {} {
            {"Head downstairs" yes downstairs}
            {"Turn on the Lantern" {[inv has {Lantern}]} lanternFailed}
        }
    }

    proc lanternFailed {} {
        puts "You turn on your Lantern, but it provides almost no light. It\
        seems something is artificially darkening the area."
        puts {}
        return topOfStairs
    }

    proc downstairs {} {
        puts "As you proceed downstairs, the minimal light available around you\
        diminishes further, rendering you completely blind by the time you reach\
        the bottom. A male voice, slightly nervous, speaks from somewhere in\
        front of you."
        puts "\"W-who's there?\""
        prompt {} {
            {"\"Are you Topaz?\"" {[state get topaz-rescue] eq {accepted}} realized}
            {"\"Who are you?\"" {[state get topaz-rescue] ne {accepted}} unrealized}
        }
    }

    proc realized {} {
        puts "\"I am. Do you know me?\""
        prompt {} {
            {"\"I'm here to rescue you.\"" yes realized1}
        }
    }

    proc realized1 {} {
        puts "\"I hope you have a plan. I haven't found any way out, and this darkness\
        seems to sap the life force from you over time. I think there's someone else in\
        this room, but I can't really tell. They're quiet. Eerily quiet.\""
        prompt {} {
            {"\"Cinnabar! We're ready!\"" yes realized2}
        }
    }

    proc realized2 {} {
        puts "\"Cinnabar is here?\""
        puts "Topaz can scarcely finish his sentence when a massive burst of red light\
        smashes the back wall of the room. The dark fog blinding your vision fades as\
        sunlight bursts into the room, and a young woman with bright red skin marches\
        in."
        puts "\"Let's go!\""
        prompt {} {
            {"Flee the scene" yes realized3}
        }
    }

    proc realized3 {} {
        puts "As you and Topaz make a motion to escape, a tall dark-haired gentleman\
        with cold eyes emerges from the darkness, carrying a bronze walking cane.\
        Without a word, he raises his cane, and the room begins to darken again.\
        Cinnabar reacts immediately and begins projecting beams of red light at\
        the gentleman. Topaz looks at you."
        puts "\"She'll be fine. She can hold her own. We need to go.\""
        prompt {} {
            {"Follow Topaz" yes realized4}
        }
    }

    proc realized4 {} {
        puts "The two of you sneak around the back of the school and notice Carl's bus\
        just leaving."
        puts "\"We need to catch that bus! Come on!\""
        puts "You and Topaz break into a run and manage to latch onto the back of the\
        bus at the last moment, seemingly unnoticed. The bus ride is seemingly longer\
        on the back than inside, but eventually the bus arrives back in the city."
        puts "\"We can't let the bus driver see us. I'll meet you back at the hideout.\""
        puts "Topaz runs off as the bus slows to a stop."
        state put topaz-rescue rescued
        prompt {} {
            {"Dismount the bus" yes realized5}
        }
    }

    proc realized5 {} {
        puts "As the regular passengers are stepping off the bus, you dismount the back.\
        Once the bus is empty, Carl steps back inside and drives off, leaving you alone."
        puts {}
        return ::Inverse::District::education
    }

    proc unrealized {} {
        puts "\"I'm Topaz. Is it your first time here?\""
        prompt {} {
            {"\"Yeah.\"" yes unrealized1}
        }
    }

    proc unrealized1 {} {
        puts "\"In that case, good luck. This dark fog seems to sap the life out of\
        you over time. It definitely isn't natural. I think there's someone else in\
        this room, but I can't really tell. If there is, then they're quiet. Eerily\
        quiet.\""
        prompt {} {
            {"\"Can we get out of here?\"" yes unrealized2}
        }
    }

    proc unrealized2 {} {
        puts "\"I don't know-\""
        puts "Topaz can scarcely finish his sentence when a massive burst of red light\
        smashes the back wall of the room. The dark fog blinding your vision fades as\
        sunlight bursts into the room, and a young woman with bright red skin marches\
        in."
        puts "\"Let's go!\""
        prompt {} {
            {"Flee the scene" yes unrealized3}
        }
    }

    proc unrealized3 {} {
        puts "As you and Topaz make a motion to escape, a tall dark-haired gentleman\
        with cold eyes emerges from the darkness, carrying a bronze walking cane.\
        Without a word, he raises his cane, and the room begins to darken again.\
        The red-skinned woman reacts immediately and begins projecting beams of\
        red light at the gentleman. Topaz looks at you."
        puts "\"She'll be fine. She can hold her own. We need to go.\""
        prompt {} {
            {"Follow Topaz" yes unrealized4}
        }
    }

    proc unrealized4 {} {
        puts "The two of you sneak around the back of the school and notice Carl's bus\
        just leaving."
        puts "\"We need to catch that bus! Come on!\""
        puts "You and Topaz break into a run and manage to latch onto the back of the\
        bus at the last moment, seemingly unnoticed. The bus ride is seemingly longer\
        on the back than inside, but eventually the bus arrives back in the city."
        puts "\"Listen. I know a place we can hide out. There's a cave just on\
        the edge of town. Meet me there, and I'll explain.\""
        puts "Topaz runs off as the bus slows to a stop."
        if {[state get topaz-rescue] eq {met}} then {
            state put topaz-rescue rescuedmet
        } else {
            state put topaz-rescue rescuedunmet
        }
        state put cave-hideout yes
        prompt {} {
            {"Dismount the bus" yes unrealized5}
        }
    }

    proc unrealized5 {} {
        puts "As the regular passengers are stepping off the bus, you dismount the back.\
        Once the bus is empty, Carl steps back inside and drives off, leaving you alone."
        puts {}
        return ::Inverse::District::education
    }

}
