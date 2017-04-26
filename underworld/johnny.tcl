
namespace eval Underworld::Johnny {

    proc talk {} {
        state put talked-to-johnny yes
        switch [state get johnny-quest] {
            no {
                puts "\"G'day, stranger! My name's Johnny Death! I bet you're wondering what I'm up to!\
                This here is a valuable display. I've been collecting souls. But I need a few more to\
                complete my collection. Listen, if you'll help me collect souls, I can tell you how to\
                get out of here.\""
                prompt {} {
                    {"\"I'm game.\"" yes okay}
                    {"Back away slowly" yes ::Underworld::Elevator::balcony}
                }
            }
            accepted - 1 - 2 {
                puts "\"Oh, it's you! Do you have any souls for me today?\""
                prompt {} {
                    {"Give him Inmate's Soul" {[inv has {Inmate's Soul}]} {given {Inmate's Soul}}}
                    {"\"Not right now.\"" yes ::Underworld::Elevator::balcony}
                }
            }
            default {
                puts "\"Hey, thanks for the help with my display! It looks perfect now!\""
                puts {}
                return ::Underworld::Elevator::balcony
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
        puts "\"Now, I can't just have any soul, you know. It's got to be a really good one. That's what\
        that Soul Crystal is for. If you're in the presence of a really good quality soul, it will start\
        to vibrate. Just take out the crystal and it will take their soul, and then you can bring it to me.\""
        puts "\"If you leave this balcony and take at right at the stairs, you'll find an elevator. That\
        access key will let you ride the elevator out of here. But don't go sharing it with anybody; mortals\
        aren't technically supposed to have those.\""
        prompt {} {
            {"\"Got it.\"" yes ::Underworld::Elevator::balcony}
        }
    }

    proc given {soul} {
        inv remove $soul
        switch $soul {
            {Inmate's Soul} {
                set desc "Ah, the soul of a prison inmate! A wonderful dominating force to keep the other souls\
                in check."
            }
            default {
                set desc "Marvelous! I've never seen this kind of soul before!"
            }
        }
        switch [state get johnny-quest] {
            accepted {
                puts "\"$desc Good job! I only need a few more souls.\""
                puts "\"Oh, by the way, my good friend Dr. Cipher is putting the finishing touches on a\
                brand new invention of his. I told him about you, and he said he would love to show you\
                what it does. If you have some time, stop by the science lab adjacent to the elevator.\""
                state put johnny-quest 1
            }
            1 {
                # ////
            }
            2 - default {
                # ////
            }
        }
        puts {}
        return ::Underworld::Elevator::balcony
    }

}
