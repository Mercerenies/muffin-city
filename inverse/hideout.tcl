
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
        in the same dull gray of the Robot King's servants. Interestingly, they both\
        seem to be wearing some kind of shower cap. They are also both pointing\
        large guns at you. The man slowly removes his shower cap and speaks."
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
        them on a shelf. The man replaces his shower cap onto his head."
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
        switch [state get topaz-rescue] {
            rescued {
                return reunion
            }
            rescuedmet {
                return reunionMet
            }
            rescuedunmet {
                return reunionUnmet
            }
        }
        if {[state get topaz-rescue] eq {yes}} then {
            puts -nonewline "The main room of the hideout is large but\
            dimly lit, the only light being provided by some bare lightbulbs\
            hung sporadically throughout. On the various tables are\
            situated many varieties of firearms and explosives. The back wall\
            is lined with four small cots. Zircon is staring at some of the\
            munitions, while Garnet is sitting in the corner of the room on a laptop."
            if {[state get escape-debriefed] eq {yes}} then {
                puts " Topaz is lying on one of the cots, unmoving."
            } else {
                puts " Topaz is leaning against a table, deep in thought."
            }
        } else {
            puts "The main room of the hideout is large but dimly lit, the only\
            light being provided by some bare lightbulbs hung sporadically throughout.\
            On the various tables are situated many varieties of firearms and explosives.\
            The back wall is lined with four small cots. Zircon is staring at some of the\
            munitions, seemingly frustrated. Garnet is sitting in the corner of the\
            room on a laptop."
        }
        # ////
        prompt {} {
            {"Talk to Zircon" {([state get topaz-rescue] ni {no noticed}) && ([state get escape-debriefed] eq {no})} zircon}
            {"Talk to Garnet" {[state get topaz-rescue] ni {no noticed met}} garnet}
            {"Talk to Topaz" {([state get topaz-rescue] eq {yes}) && ([state get escape-debriefed] eq {no})} topaz}
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
            rescued - rescuedmet - rescuedunmet - yes {
                puts "\"What's wrong?\""
                prompt {} {
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
                    {"\"What are the shower caps for?\"" yes garnetCap}
                    {"\"Alright.\"" yes mainRoom}
                }
            }
            rescued - rescuedmet - rescuedunmet - yes {
                switch [state get king-war] {
                    no {
                        puts "\"Hey, what's up?\""
                        prompt {} {
                            {"\"I'm looking for recon work.\"" {[state get escape-debriefed] eq {yes}} reconIntro}
                            {"\"Nothing right now.\"" yes mainRoom}
                        }
                    }
                    understood {
                        puts "\"Want to talk about intel?\""
                        prompt {} {
                            {"\"The Robot King?\"" yes reconRobot}
                            {"\"What about the Mesmerist?\"" yes reconMesmerist}
                            {"\"Can I research Hex?\"" yes reconHex}
                            {"\"I'll look into the Bouncer.\"" yes reconBouncer}
                            {"\"I lost my Shower Cap.\"" {![inv has {Shower Cap}]} garnetExtraCap}
                            {"\"Not right now.\"" yes mainRoom}
                        }
                    }
                }
            }
        }
    }

    proc topaz {} {
        puts "\"What's up?\""
        prompt {} {
            {"\"I'm ready for the meeting.\"" {[state get escape-debriefed] eq {no}} reunionMeeting}
            {"\"Later.\"" yes mainRoom}
        }
    }

    proc garnetCap {} {
        puts "\"They're specially engineered. Normally, a servant of the Robot King\
        won't speak to you if you're not one of them. But the fabric in these caps\
        confuses their hypnotic programming and makes them think you're also\
        hypnotized. If you can rescue Topaz, he'll probably give you one too.\""
        puts {}
        return mainRoom
    }

    proc garnetExtraCap {} {
        puts "\"No problem. Here's another.\""
        puts "You got the Shower Cap!"
        inv add {Shower Cap}
        puts {}
        return mainRoom
    }

    proc zirconReexplain {} {
        puts "\"You need to go back to the reeducation facility and fail all of\
        your classes. When you get to the basement, Cinnabar will be waiting for\
        you. Create a diversion and get Topaz to safety with Cinnabar's help.\""
        prompt {} {
            {"\"Will do.\"" yes mainRoom}
        }
    }

    proc reconIntro {} {
        puts "\"Sounds good! If you're going to be doing recon work, you'll need one\
        of these shower caps. Normally, servants of the Robot King won't talk to you\
        unless you're hypnotized or at the reeducation facility. But the fabric in\
        this cap is specifically designed to confuse them. They'll think you're\
        one of them and talk to you normally.\""
        puts "You got the Shower Cap!"
        inv add {Shower Cap}
        # //// Shower Cap does nothing right now.
        # //// Robot King, Mesmerist, and school don't respond to it right now either.
        puts "\"Just one word of warning. The Robot King and the Mesmerist won't be\
        fooled by the cap, and if you go to the reeducation facility they'll confiscate\
        it. If that happens, just come talk to me. We have plenty of extras.\""
        prompt {} {
            {"\"Okay.\"" yes reconIntro1}
        }
    }

    proc reconIntro1 {} {
        puts "\"Alright. We have five major known adversaries: The Robot King, the\
        Mesmerist, Hex, the Bouncer, and Midnight. I'm researching Midnight right now,\
        but you can take any of the other four you want.\""
        state put king-war understood
        prompt {} {
            {"\"How about the Robot King?\"" yes reconRobot}
            {"\"I can look into the Mesmerist.\"" yes reconMesmerist}
            {"\"Who is Hex?\"" yes reconHex}
            {"\"What about the Bouncer?\"" yes reconBouncer}
        }
    }

    proc reconRobot {} {
        # ////
        return {::Empty::back ::Inverse::Hideout::mainRoom}
    }

    proc reconMesmerist {} {
        # ////
        return {::Empty::back ::Inverse::Hideout::mainRoom}
    }

    proc reconHex {} {
        # ////
        return {::Empty::back ::Inverse::Hideout::mainRoom}
    }

    proc reconBouncer {} {
        # ////
        return {::Empty::back ::Inverse::Hideout::mainRoom}
    }

    proc reunion {} {
        puts "Topaz has already returned to the base, and you finally get a\
        good look at him. He's dressed just like his two companions, in the\
        dull gray of the Robot King's uniform. He has also donned a shower cap\
        since you last saw him, matching those of his allies. He sees you enter."
        puts "\"Welcome back! I just finished telling Garnet about the strange\
        man with the walking cane. We weren't actually aware of him until now.\""
        prompt {} {
            {"\"Where's Cinnabar?\"" yes reunion1}
        }
    }

    proc reunion1 {} {
        puts "\"Still haven't heard from her. We need to have a brief meeting so\
        we can all get on the same page, but then we'll send someone out to\
        go look for her.\""
        state put topaz-rescue yes
        prompt {} {
            {"\"Okay. Let's talk.\"" yes reunionMeeting}
            {"\"I have something I need to do first.\"" yes mainRoom}
        }
    }

    proc reunionMet {} {
        puts "Topaz has already returned to the base, and you finally get a\
        good look at him. He's dressed just like his two companions, in the\
        dull gray of the Robot King's uniform. He has also donned a shower cap\
        since you last saw him, matching those of his allies. Zircon grins as\
        he sees you enter."
        puts "\"You didn't want to help us, but you accidentally rescued our\
        leader, eh?\""
        puts "Topaz approaches you and speaks up."
        puts "\"Welcome back. As Zircon's already pointed out, I'm the leader\
        of the rebellion. The red-skinned girl from before, Cinnabar, is also\
        with us. I was just telling Garnet about the strange man with the\
        walking cane. We actually weren't aware of anyone by his description\
        working for the Robot King until now.\""
        prompt {} {
            {"\"Where's Cinnabar?\"" yes reunion1}
        }
    }

    proc reunionUnmet {} {
        puts "You find yourself inside a dimly lit stone room. Topaz is here\
        with two other people you haven't seen before, a man and a woman. All\
        three of them are wearing dull gray clothes matching those of\
        the Robot King's servants, and interestingly all three are\
        wearing some sort of shower cap on their heads. Topaz approaches you."
        puts "\"Hey, you made it. Welcome to our hideout.\""
        prompt {} {
            {"\"Hideout?\"" yes reunionUnmet1}
        }
    }

    proc reunionUnmet1 {} {
        puts "\"We're a resistance movement against the Robot King. In short,\
        we plan to overthrow him one day and liberate the city. These are my\
        allies, Zircon and Garnet.\""
        puts "He gestures first to the man behind him then to the woman."
        puts "\"And you already met Cinnabar, the red-skinned girl at the base.\
        Since you were able to get in and out of the Robot King's deluxe reeducation\
        unscathed, I'd say you're more than capable of joining us.\""
        prompt {} {
            {"\"Where is Cinnabar now?\"" yes reunion1}
        }
    }

    proc reunionMeeting {} {
        puts "\"Alright.\""
        puts "The two other members step a bit closer."
        puts "\"So, to begin with, the Robot King has another subordinate we\
        didn't know about, the strange man with the walking cane. Garnet, did\
        you manage to find anything about him?\""
        puts "\"I found some old police case files that fit the man's description.\
        He calls himself Midnight, a ruthless assassin known for his ability to\
        slip into a person's shadow. And apparently that's not a metaphor. According\
        to rumors, he literally disappears into their shadow and reappears later,\
        meaning he can follow someone home leaving them none the wiser. Nothing about\
        the walking cane that emits darkness, though.\""
        puts "\"Wait...\""
        prompt {} {
            {"\"What's wrong?\"" yes reunionMeeting1}
        }
    }

    proc reunionMeeting1 {} {
        puts "\"If he can hide in someone's shadow... Cinnabar! What if he hid in\
        her shadow so that she would lead him back here. Garnet, did you find any\
        way to extract him from someone's shadow?\""
        puts "\"Not yet. But I'll keep looking.\""
        puts "\"In the meantime, we have to assume Cinnabar is compromised. If this\
        Midnight finds out where our base is, then it's all over. We can't afford to\
        lose this place. Zircon! You need to go now. Find Cinnabar and tell her to stay\
        put. We'll relay instructions to her through you for now.\""
        puts "\"On it!\""
        puts "Zircon dashes out of the cave without a moment's hesitation."
        prompt {} {
            {"\"What about the rest of us?\"" yes reunionMeeting2}
        }
    }

    proc reunionMeeting2 {} {
        puts "\"Well, I think I was right about that basement draining the life out of\
        you. I've been feeling a bit light-headed since I got back. Are you feeling alright?\""
        prompt {} {
            {"\"I feel fine.\"" yes reunionMeeting3}
        }
    }

    proc reunionMeeting3 {} {
        puts "\"Good. You weren't in the basement as long as I was, so it makes sense.\
        Anyway, I need to go lie down for a bit. If you want to do some recon work,\
        Garnet can fill you in on what intel we need.\""
        puts "Topaz moves back to one of the cots and lies down."
        state put escape-debriefed yes
        prompt {} {
            {"\"Okay.\"" yes mainRoom}
        }
    }

}
