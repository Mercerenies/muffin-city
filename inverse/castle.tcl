
namespace eval Inverse::Castle {

    proc entrance {} {
        puts "The castle doors are unlocked and open freely."
        puts {}
        return parlor
    }

    proc parlor {} {
        puts "=~ Castle Parlor ~="
        puts "The parlor is as extravagant as it is large. A red carpet\
        covers the entire floor, and silver banners adorn the walls.\
        People in matching gray uniforms walk to a fro, emotionless and\
        silent. The throne room is straight ahead. An archway to the right\
        opens into a hallway, and there is a door to the left. The castle\
        exit sits behind you."
        prompt {} {
            {"Enter the throne room" yes throne}
            {"Enter the right hallway" yes hallway}
            {"Go through the door on the left" yes lockedDoor}
            {"Speak to one of the uniformed people" yes uniformed}
            {"Exit the castle" yes ::Inverse::District::castle}
        }
    }

    proc throne {} {
        puts "=~ Castle Throne Room ~="
        puts -nonewline "The throne room is as elaborate as the parlor, with a\
        single narrow red carpet leading up a small set of stairs to a gold-adorned\
        throne. Next to the door through which you entered, a large bald man with\
        excessive muscles and thick eyebrows is standing guard. He makes no move to stop\
        you from entering."
        if {[state get met-robot] eq {no}} then {
            puts " Atop the throne sits a large humanoid robot. There are several more\
            uniformed individuals standing by the throne, motionless."
        } else {
            puts " The Robot King sits atop his throne, surrounded by several motionless\
            individuals in a featureless gray uniform."
        }
        prompt {} {
            {"Approach the throne" yes king}
            {"Talk to the bald man" yes bouncer}
            {"Go back" yes parlor}
        }
    }

    proc hallway {} {
        puts "=~ Castle Hallway ~="
        puts "The hallway narrows slightly and continues for a ways. There are two doors\
        to the left and an archway on either side of the hallway, one leading to the parlor\
        and the other leading outside."
        prompt {} {
            {"Go to the parlor" yes parlor}
            {"Take the first door on the left" yes julieRoom}
            {"Take the second door on the left" yes mesmeristRoom}
        }
    }

    proc lockedDoor {} {
        puts "The door is locked and will not budge."
        # //// Option to force the door, which will of course get you into trouble
        puts {}
        return parlor
    }

    proc uniformed {} {
        puts "You stop a uniformed individual."
        puts "\"All hail the Robot King!\""
        puts "The individual moves on."
        puts {}
        return parlor
    }

    proc king {} {
        if {[state get met-robot] eq {no}} then {
            state put met-robot yes
            puts "The robot speaks in a very cheery, optimistic voice."
            puts "\"Greetings, human! Welcome to my lovely city! I'm the Robot\
            King! You don't look like you're from around here. Is that right?\""
            prompt {} {
                {"\"I'm from a far away place.\"" yes kingFar}
                {"\"Nope. Born and raised here.\"" yes kingLie}
            }
        } else {
            switch [state get robot-hypnotism] {
                no - killed {
                    puts "The Robot King's voice is as cheery as ever."
                    puts "\"Greetings, human! ... ... Didn't I vaporize you recently?\""
                    prompt {} {
                        {"\"You can't kill me that easily!\"" yes kingGloat}
                        {"\"Well, you tried.\"" yes kingGloat}
                        {"\"Uhh... no...\"" yes kingKillLie}
                    }
                }
                waiting {
                    puts "The Robot King's voice is as cheery as ever."
                    puts "\"Remember, hallway, second door on the left. Feel free to come\
                    talk to me again after your initiation.\""
                    prompt {} {
                        {"\"Thank you.\"" yes throne}
                    }
                }
                failed {
                    puts "\"Hello again! How was your initiation?\""
                    prompt {} {
                        {"\"It was good. Thanks.\"" yes kingFake}
                        {"\"All hail the Robot King!\"" yes kingFake}
                        {"\"I haven't done it yet.\"" yes throne}
                    }
                }
            }
        }
    }

    proc kingFar {} {
        puts "\"Ah, excellent! We always welcome visitors to our land! There is\
        just one thing to note: we do require all visitors to go through a teensy\
        initiation. Whenever you're ready, just head down the hallway and take the\
        second door on the left. Tell the nice man in there that you're here for the\
        initiation.\""
        state put robot-hypnotism waiting
        prompt {} {
            {"\"What's the initiation?\"" yes kingInit}
            {"\"I'll get right on that.\"" yes throne}
        }
    }

    proc kingInit {} {
        puts "\"Ah, if I tell you that, it'll spoil the surprise!\""
        prompt {} {
            {"\"...Okay.\"" yes throne}
        }
    }

    proc kingLie {} {
        puts "The Robot King's grin doesn't break."
        puts "\"Now, listen. I'm the benevolent dictator of this land, so lying\
        to me may not be your best option.\""
        prompt {} {
            {"\"Okay, fair. I'm a visitor.\"" yes kingFar}
            {"\"I told you, I grew up here.\"" yes kingLie1}
        }
    }

    proc kingLie1 {} {
        puts "\"Well, that's a shame. We can't have unsavory folks like you corrupting\
        my lovely townsfolk.\""
        puts "Lasers ignite from the Robot King's eyes and vaporize you."
        puts {}
        return ::Underworld::Pits::mysteryRoom
    }

    proc kingFake {} {
        puts "\"Now, you can't fool me! I can tell you haven't been initiated!\
        Unfortunately, lying to me is frowned upon in this community.\""
        puts "Lasers ignite from the Robot King's eyes and vaporize you."
        puts {}
        state put robot-hypnotism killed
        return ::Underworld::Pits::mysteryRoom
    }

    proc kingGloat {} {
        puts "\"Hah! Well, fortunately, I have remedies for people like you. Bouncer,\
        take this human to be reeducated!\""
        return kingToSchool
    }

    proc kingKillLie {} {
        puts "\"You should realize by now how much I despise being lied to.\""
        puts "Lasers ignite from the Robot King's eyes and vaporize you."
        puts {}
        state put robot-hypnotism killed
        return ::Underworld::Pits::mysteryRoom
    }

    proc kingToSchool {} {
        # //// If the bus is already there (from Carl doing things),
        # slightly different text here regarding the bus
        puts "The burly man at the entrance steps forward and drags you out onto the\
        street. He walks you two districts over into the education district, where a\
        bright yellow school bus pulls up. The man shoves you onto the bus as soon as\
        it stops. The bus driver, whose nametag identifies him as \"Carl\", greets you\
        with a friendly smile and invites you to take a seat."
        # //// Should we be able to cause a ruckus here? Should it do anything?
        prompt {} {
            {"Take a seat" yes ::Inverse::School::bus}
        }
    }

    proc bouncer {} {
        puts "\"All hail the Robot King!\""
        puts {}
        return throne
    }

    proc julieRoom {} {
        puts "=~ Castle - First Room ~="
        puts "The relatively small room has virtually no amenities, only a small chair in\
        the middle of the room. A young woman whose skin is bright green is standing in front\
        of the chair, staring at you through a pair of round glasses."
        prompt {} {
            {"Talk to the woman" yes julieTalk}
            {"Leave the room" yes hallway}
        }
    }

    proc julieTalk {} {
        puts "\"All hail the Robot King!\""
        puts {}
        return julieRoom
    }

    proc mesmeristRoom {} {
        puts "=~ Castle - Second Room ~="
        puts -nonewline "The second room is small but rather regal, with a\
        decorative bed, a small desk, and a revolving chair. Against the\
        wall, there are several small pendulums hanging from hooks."
        if {[state get met-mesmerist] eq {no}} then {
            puts "A stout gentleman in a cloak, a black mask, and\
            a top hat is seated in the revolving chair."
        } else {
            puts "The Mesmerist is sitting in his revolving chair."
        }
        prompt {} {
            {"Talk to the man" {[state get met-mesmerist] eq {no}} mesmeristTalk}
            {"Talk to the Mesmerist" {[state get met-mesmerist] ne {no}} mesmeristTalk}
            {"Leave the room" yes hallway}
        }
    }

    proc mesmeristTalk {} {
        if {[state get met-mesmerist] eq {no}} then {
            puts "\"Greetings! I am the Mesmerist, loyal servant to the Robot King.\""
            state put met-mesmerist yes
        } else {
            puts "\"Greetings!\""
        }
        prompt {} {
            {"\"I'm here for the initiation.\"" {[state get robot-hypnotism] eq {waiting}} mesmeristInit}
            {"\"Can we try the initiation again?\"" {[state get robot-hypnotism] in {failed killed}} mesmeristInit}
            {"\"Goodbye.\"" yes mesmeristRoom}
        }
    }

    proc mesmeristInit {} {
        if {[state get robot-hypnotism] eq {failed}} then {
            puts "\"Ah, you'd like to try again then. Hold still.\""
        } else {
            puts "\"Ah, excellent! Hold still and watch closely.\""
        }
        puts "The Mesmerist takes a pendulum off the wall and swings it in front of your\
        face."
        if {[state get robot-hypnotism] eq {waiting}} then {
            state put robot-hypnotism failed
        }
        prompt {} {
            {"\"This... isn't doing anything.\"" yes mesmeristNoEffect}
            {"\"Uh... all hail the Robot King... or something.\"" yes mesmeristFake}
        }
    }

    proc mesmeristNoEffect {} {
        puts "\"Odd... this usually works. The Robot King will be quite upset if he\
        finds you uninitiated. Perhaps we should try again later.\""
        prompt {} {
            {"\"Later.\"" yes mesmeristRoom}
        }
    }

    proc mesmeristFake {} {
        puts "\"Hm... the inflection isn't quite right. I don't believe it's worked.\
        The Robot King will be quite upset if he finds you uninitiated. Perhaps we\
        should try again later.\""
        prompt {} {
            {"\"Later.\"" yes mesmeristRoom}
        }
    }

}
