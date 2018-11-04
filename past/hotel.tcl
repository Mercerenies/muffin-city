
namespace eval Past::Hotel {

    proc ritzyHall {} {
        puts "== Past Ritzy Inn - Hallway =="
        puts "The hallway stretches on for quite a ways, and there appear to be\
        several floors above this one."
        prompt {} {
            {"Go to Room 211" {[inv has {Ritzy Inn Room Key}]} ritzyRoom}
            {"Go to the basement" {[state get heard-science] eq {yes}} ::Past::Science::mainRoom}
            {"Go to the lobby" yes ritzyInn}
        }
    }

    proc ritzyRoom {} {
        puts "== Past Ritzy Inn - Bedroom =="
        if {[state get has-suitcase] eq {yes}} then {
            puts "Room 211 looks rather pristine, but it is still obvious that another party\
            is staying here right now."
        } else {
            puts "There is another party's luggage laying on\
            the floor of the room. Clearly, someone else has the room right now."
        }
        prompt {} {
            {"Take the luggage" {[state get has-suitcase] eq {no}} ritzyLuggage}
            {"Go to sleep" yes {::Dream::Transit::awaken ::Dream::Transit::firstRoom}}
            {"Exit the room" yes ritzyHall}
        }
    }

    proc ritzyLuggage {} {
        puts "You take the luggage for yourself."
        puts "You got a Stolen Suitcase!"
        inv add {Stolen Suitcase}
        state put has-suitcase yes
        # //// The real owners of the suitcase should do something in the present, like tell the cops
        puts {}
        return ritzyRoom
    }

    proc ritzyInn {} {
        puts "== Past Ritzy Inn =="
        puts "This is obviously a high-class building. There are several people moving to and fro,\
        all of them dressed in the finest garb. Behind a large \"Guest Services\" counter sits a\
        young man with glasses. The bronze nameplate in front of him informs you that his name\
        is Todd."
        prompt {} {
            {"Talk to Todd" yes ritzyTalk}
            {"Go toward the hallway" yes ritzyHall}
            {"Leave" yes ::Past::District::hotel}
        }
    }

    proc ritzyTalk {} {
        puts "\"I'm terribly sorry, but we don't have any vacancies at the moment. Please\
        come back at one o'clock after today's guests have departed.\""
        # //// Something else for Todd to do (show him his note to go to subspace?)
        prompt {} {
            {"\"Never mind.\"" yes ritzyInn}
        }
    }

    proc shabbyJack {} {
        puts "== Shabby Jack's - Past =="
        puts -nonewline "The facility is clearly a low-class establishment, but it has a\
        certain rustic charm to it. There is a hallway leading back with a sign that\
        says \"Guests Only\", and behind a wooden counter there is a man with a nametag\
        reading \"Shabby Jack\"."
        if {[state get butler-game] eq {pawn1}} then {
            if {[inv has {Soul Crystal}] && ([state get merchant-war] ne {no}) &&
                ([state get attorney-man] ni {no met talked})} then {
                state put butler-game shabby
            }
        }
        switch [state get attorney-man] {
            no {
                puts -nonewline " A man in an elaborate superhero costume and a red cape\
                and mask is sitting on a chair in the corner."
            }
            default {
                puts -nonewline " Attorney-Man is sitting on a chair in the corner, his\
                hands folded in his lap."
            }
        }
        if {[state get butler-game] in {shabby shabby1}} then {
            puts -nonewline " A man in a butler's uniform is leaning against the counter."
        }
        puts {}
        prompt {} {
            {"Talk to Shabby Jack" yes shabbyTalk}
            {"Talk to the superhero" {[state get attorney-man] eq {no}} shabbyAttorney}
            {"Talk to Attorney-Man" {[state get attorney-man] ne {no}} shabbyAttorney}
            {"Talk to the butler" {[state get butler-game] in {shabby shabby1}} shabbyButler}
            {"Enter your room" {[inv has {Motel Room Key}]} shabbyRoom}
            {"Leave" yes ::Past::District::hotel}
        }
    }

    proc shabbyAttorney {} {
        switch [state get attorney-man] {
            no {
                puts "\"Leave me alone.\""
                prompt {} {
                    {"\"Who are you?\"" yes shabbyAttorney1}
                    {"\"Okay, sorry.\"" yes shabbyJack}
                }
            }
            met {
                puts "\"Leave me alone.\""
                prompt {} {
                    {"\"You can do it!\"" yes shabbyAttorneyYes}
                    {"\"Okay, sorry.\"" yes shabbyJack}
                }
            }
            default {
                puts "\"Today, I'm going to go change the world!\""
                puts {}
                return shabbyJack
            }
        }
    }

    proc shabbyAttorney1 {} {
        state put attorney-man met
        puts "\"Well, if you must know...\""
        puts "The strange man rises from his chair and strikes a heroic pose with his hands\
        on his hips."
        puts "\"I'm Attorney-Man! Evildoers beware! I defend mankind's rights under the law!\
        I'll take on any client, no matter how hopeless! And I've never lost a case!\""
        puts "Attorney-Man sits back down."
        puts "\"But... the judge threw me out of the courtroom. I think he's tired of dealing\
        with me...\""
        prompt {} {
            {"\"You can do it!\"" yes shabbyAttorneyYes}
            {"\"I'm sorry...\"" yes shabbyAttorneyNo}
        }
    }

    proc shabbyAttorneyYes {} {
        state put attorney-man talked
        puts "\"You know what? You're right! That judge can throw me out of every case\
        but I won't quit! Because I fight for justice and I won't let any judges get in\
        my way! Today, I'm going to go find a new client and bring justice for all!\""
        puts {}
        return shabbyJack
    }

    proc shabbyAttorneyNo {} {
        puts "\"I'll be fine. Just leave me alone...\""
        puts {}
        return shabbyJack
    }

    proc shabbyButler {} {
        if {[state get butler-game] eq {shabby}} then {
            puts "\"Good to see you again. I have something for you.\""
            puts "The Butler hands you a Crystal Ball."
            inv add {Crystal Ball}
            state put butler-game shabby1
        } elseif {[inv has {Crystal Ball}]} {
            puts "\"I believe there is someone who needs that Crystal Ball about now.\""
        } else {
            puts "\"I am happy to see you have made good use of the Crystal Ball I gave you.\""
        }
        puts {}
        return shabbyJack
    }

    proc shabbyTalk {} {
        puts "\"Welcome to Shabby Jack's Streetside Motel! We haven't finished cleaning\
        the rooms yet, so you'll have to come back in a few hours.\""
        prompt {} {
            {"\"Oh, okay.\"" yes shabbyJack}
        }
    }

    proc shabbyRoom {} {
        puts "\"Whoa, hold on there! We still need to clean up the rooms before we can\
        have any guests back there. You'll have to come back in a bit.\""
        puts {}
        return shabbyJack
    }

}
