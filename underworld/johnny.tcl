
namespace eval Underworld::Johnny {

    proc talk {} {
        state put talked-to-johnny yes
        switch [state get johnny-quest] {
            no {
                puts "\"G'day, stranger! My name's Johnny Death! I bet you're wondering what I'm\
                up to! This here is a valuable display. I've been collecting souls. But I need a\
                few more to complete my collection. Listen, if you'll help me collect souls, I can\
                tell you how to get out of here.\""
                prompt {} {
                    {"\"I'm game.\"" yes okay}
                    {"Back away slowly" yes ::Underworld::Elevator::balcony}
                }
            }
            accepted - 1 - 2 {
                puts "\"Oh, it's you! Do you have any souls for me today?\""
                prompt {} {
                    {"Give him Inmate's Soul" {[inv has {Inmate's Soul}]} {given {Inmate's Soul}}}
                    {"Give him Guard's Soul" {[inv has {Guard's Soul}]} {given {Guard's Soul}}}
                    {"Give him Hunter's Soul" {[inv has {Hunter's Soul}]} {given {Hunter's Soul}}}
                    {"Ask him about Steve" {[state get steve-disappeared] in {gone gone1 resurrected}} steve}
                    {"\"Not right now.\"" yes ::Underworld::Elevator::balcony}
                }
            }
            default {
                puts "\"Hey, thanks for the help with my display! It looks perfect now!\""
                prompt {} {
                    {"Ask him about Steve" {[state get steve-disappeared] in {gone gone1 resurrected}} steve}
                    {"\"You're welcome.\"" yes ::Underworld::Elevator::balcony}
                }
            }
        }
    }

    proc okay {} {
        state put johnny-quest accepted
        inv add {Soul Crystal}
        inv add {Elevator Access Key}
        puts "\"Wonderful! Here, take these!\""
        puts "Johnny Death gives you a Soul Crystal."
        puts "Johnny Death gives you an Elevator Access Key."
        puts "\"Now, I can't just have any soul, you know. It's got to be a really good one.\
        That's what that Soul Crystal is for. If you're in the presence of a really good quality\
        soul, it will start to vibrate. Just take out the crystal and it will take their soul,\
        and then you can bring it to me.\""
        puts "\"If you leave this balcony and take at right at the stairs, you'll find an elevator.\
        That access key will let you ride the elevator out of here. But don't go sharing it\
        with anybody; mortals aren't technically supposed to have those.\""
        prompt {} {
            {"\"Got it.\"" yes ::Underworld::Elevator::balcony}
        }
    }

    proc given {soul} {
        inv remove $soul
        switch $soul {
            {Inmate's Soul} {
                set desc "Ah, the soul of a prison inmate! A wonderful dominating force to keep\
                the other souls in check."
            }
            {Guard's Soul} {
                set desc "Ooh, a prison guard's soul! Every good collection needs one of these,\
                to keep things civil."
            }
            {Hunter's Soul} {
                set desc "Hm, a hunter's soul! This should certainly shake things up in my...\
                collection."
            }
            default {
                set desc "Marvelous! I've never seen this kind of soul before!"
            }
        }
        switch [state get johnny-quest] {
            accepted {
                puts "\"$desc Good job! I only need a few more souls.\""
                puts "\"Oh, by the way, my good friend Dr. Cipher is putting the finishing touches\
                on a brand new invention of his. I told him about you, and he said he would love\
                to show you what it does. If you have some time, stop by the science lab adjacent\
                to the elevator.\""
                state put johnny-quest 1
            }
            1 {
                puts "\"$desc Excellent! Just one more soul and my collection will be perfect!\""
                puts "\"Hey, let me see that Elevator Access Key for a sec.\""
                puts "Johnny takes your Elevator Access Key and breathes on it. His breath\
                materializes as thick smoke. When he is done, he hands you the Upgraded Elevator\
                Access Key."
                inv remove {Elevator Access Key}
                inv add {Upgraded Elevator Access Key}
                puts "\"Now you can use more of the buttons on the elevator.\""
                state put johnny-quest 2
            }
            2 {
                puts "\"$desc It's done! My collection is perfect!\""
                puts "\"Listen, I want to thank you. I'll open up all the rooms in the\
                lobby. You can visit them anytime you want.\""
                state put lobby-door yes
                state put johnny-quest done
            }
            default {
                puts "\"Thank you!\""
            }
        }
        puts {}
        return ::Underworld::Elevator::balcony
    }

    proc climbed {} {
        if {[state get talked-to-johnny]} then {
            set desc "Johnny"
        } else {
            set desc "The man"
        }
        puts "You climb back up the rope and over the edge. $desc looks at you firmly."
        if {[state get jumped-into-fire]} then {
            puts "\"Listen. I'm trying to be friendly here. But we can't have you jumping into\
            fire pits left and right. You have to stop doing that, okay?\""
        } else {
            puts "\"Now, look. I know you've had a rough day and whatnot, believe me. But we can't\
            let you jump down there. There's just too much paperwork if you die here, what with\
            corporate breathing down my neck these past few months. So just try not to do that again,\
            okay?\""
        }
        state put jumped-into-fire yes
        puts {}
        return ::Underworld::Elevator::balcony
    }

    proc steve {} {
        switch [state get steve-disappeared] {
            gone {
                puts "\"What's that? You need me to bring back your friend? Well, if she's\
                trying to help the Reaper, then I'm happy to help. I'll deal with all of\
                the paperwork. It'll take a little while, so come check back in later, okay?\""
                state put steve-disappeared gone1
                puts {}
                return ::Underworld::Elevator::balcony
            }
            gone1 {
                puts "\"It'll be a little while before the paperwork goes through. Check\
                in later, okay?\""
                puts {}
                return ::Underworld::Elevator::balcony
            }
            resurrected {
                puts "\"The paperwork went through. Steve is in the Other Room.\""
                puts {}
                return ::Underworld::Elevator::balcony
            }
        }
    }

}
