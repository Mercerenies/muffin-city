
namespace eval Inverse::Hideout {

    proc firstEntryCoop {} {
        puts "The young man guides you for a bit. After some time, he removes the sack from\
        your head."
        puts {}
        return gunpoint
    }

    proc firstEntryRemoval {} {
        puts "You reach up to remove the sack from your head but your arms are forced back\
        to your side rather swiftly."
        prompt {} {
            {"Cooperate" yes firstEntryCoop}
            {"Run away" yes firstEntryFlee}
        }
    }

    proc firstEntryFlee {} {
        puts "You blindly run away from the voice and manage to smash your face into\
        a nearby building. As you lay on the ground dazed, the unknown man helps you\
        up."
        prompt {} {
            {"Follow him" yes firstEntryCoop}
        }
    }

    proc gunpoint {} {
        puts "=~ Secret Hideout ~="
        puts "You find yourself inside a dimly lit stone room. There are two other\
        people in the room, one young man and one young woman who are both dressed\
        in the same dull gray of the Robot King's servants. They are both pointing\
        large guns at you. The man speaks."
        puts "\"Say something!\""
        state put topaz-rescue met
        state put cave-hideout yes
        prompt {} {
            {"\"What do you want?\"" yes gunpoint1}
            {"\"Please don't hurt me.\"" yes gunpoint1}
            {"\"Something.\"" yes gunpoint1}
            {"\"All hail the Robot King.\"" yes gunpointPanic}
        }
    }

    proc gunpoint1 {} {
        puts "\"Whew. That's a relief. Had to be sure you weren't a servant\
        of the Robot King. If you were, you wouldn't have been allowed to\
        talk to us.\""
        puts "The two of them simultaneously withdraw their firearms and place\
        them on a shelf."
        prompt {} {
            {"\"Where are we?\"" yes gunpoint2}
        }
    }

    proc gunpointPanic {} {
        puts "\"Oh no!\""
        puts "\"We let a servant of the Robot King in!\""
        puts "\"Do something!\""
        prompt {} {
            {"\"No wait! The Robot King didn't get me!\"" yes gunpoint1}
        }
    }

    proc gunpoint2 {} {
        puts "The man speaks up."
        puts "\"This is the resistance hideout. I'm Zircon, and this is Garnet.\
        In a word, we're gonna overthrow the Robot King. We've been\
        watching you since you first got into town. The Mesmerist\
        seems to have no effect on you, and you passed the\
        reeducation with flying colors. We need your help.\""
        prompt {} {
            {"\"What can I do?\"" yes gunpoint3}
            {"\"Sorry, I don't do rebellions.\"" yes gunpointRefusal}
        }
    }

    proc gunpoint3 {} {
        puts "\"Obviously, this isn't the whole rebellion. Our leader Topaz has\
        been captured by the Robot King. He's at the reeducation facility. The\
        two of us can't risk showing our faces there, but the reeducation seems\
        to have no effect on you. We need you to rescue our leader.\""
        prompt {} {
            {"\"How will I do that?\"" yes gunpoint4}
        }
    }

    proc gunpoint4 {} {
        puts "Garnet steps in to answer your question."
        puts "\"I've hacked into the facility's security cameras. Topaz was taken\
        to the basement for what they call 'deluxe reeducation'. We've stationed\
        another one of our members, Cinnabar, by the facility, but we need someone\
        on the inside creating a diversion so that Cinnabar can make her move.\""
        puts "Zircon steps back in."
        puts "\"To get the deluxe reeducation, you'll need to go through the\
        reeducation program again and get an F. That means failing all three\
        of the classes.\""
        prompt {} {
            {"\"Sounds easy enough.\"" yes gunpointFinished}
        }
    }

    proc gunpointFinished {} {
        puts "\"When you get to the basement, just call out Cinnabar's name and she'll\
        make her move. The exit is behind you.\""
        state put topaz-rescue accepted
        prompt {} {
            {"\"Alright. I'll do it.\"" yes mainRoom}
        }
    }

    proc gunpointRefusal {} {
        puts "\"I see. Let me know if you change your mind. The exit\
        is behind you.\""
        puts {}
        return mainRoom
    }

    proc mainRoom {} {
        puts "=~ Secret Hideout ~="
        puts "The main room of the hideout is large but dimly lit, the only\
        light being provided by some bare lightbulbs hung sporadically throughout.\
        On the various tables are situated many varieties of firearms and explosives.\
        Zircon is staring at some of the munitions, seemingly frustrated. Garnet is\
        sitting in the corner of the room on a laptop."
        prompt {} {
            {"Talk to Zircon" {[state get topaz-rescue] ni {no noticed}} zircon}
            {"Talk to Garnet" {[state get topaz-rescue] ni {no noticed met}} garnet}
            {"Exit the hideout" yes ::Prison::Forest::reverseCaveExit}
        }
    }

    proc zircon {} {
        switch [state get topaz-rescue] {
            met {
                puts "\"Did you change your mind?\""
                prompt {} {
                    {"\"How can I help?\"" yes gunpoint3}
                    {"\"Goodbye.\"" yes mainRoom}
                }
            }
            accepted {
                puts "\"Is something wrong?\""
                prompt {} {
                    {"\"What am I supposed to do?\"" yes zirconReexplain}
                    {"\"Nothing.\"" yes mainRoom}
                }
            }
        }
    }

    proc garnet {} {
        switch [state get topaz-rescue] {
            accepted {
                puts "\"Once Topaz gets back, we'll be more coordinated. We're just\
                not used to planning operations without him. In the meantime, I'll\
                be here making sure our secret base stays a secret.\""
                prompt {} {
                    {"\"Alright.\"" yes mainRoom}
                }
            }
        }
    }

    proc zirconReexplain {} {
        puts "\"You need to go back to the reeducation facility and fail all of\
        your classes. When you get to the basement, Cinnabar will be waiting for\
        you. Create a diversion and get Topaz to safety with Cinnabar's help.\""
        prompt {} {
            {"\"Will do.\"" yes mainRoom}
        }
    }

}
