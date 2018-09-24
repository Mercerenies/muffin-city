
namespace eval Underworld::Elevator {

    proc staircase {} {
        puts "== Grand Staircase =="
        puts "You approach a grand set of stairs leading up to a rather intimidating set of\
        double doors. At the base of the stairs, there is a smaller door that leads to a small lobby.\
        Off to the side, there is a strange hole in the wall leading to some kind of tunnel."
        prompt {} {
            {"Enter the double doors" yes balcony}
            {"Enter the small door" yes ::Underworld::Lobby::hub}
            {"Go through the hole" yes tunnel}
        }
    }

    proc balcony {} {
        puts "== Underworld Balcony =="
        puts -nonewline "The room you enter is very large. You find yourself on a small\
        glowing balcony overlooking a vast pool of flames."
        if {[state get talked-to-johnny]} then {
            puts " To the right, Johnny Death stands over his display of souls."
        } else {
            puts " To the right side of the room, an eccentric man with spiked hair that seems\
            to be quite literally flaming is staring down at a glass case full of strange,\
            floating entities."
        }
        prompt {} {
            {"Talk to the man" {![state get talked-to-johnny]} ::Underworld::Johnny::talk}
            {"Talk to Johnny" {[state get talked-to-johnny]} ::Underworld::Johnny::talk}
            {"Leap over the edge" yes ::Underworld::Pits::fireEntry}
            {"Exit toward the stairs" yes staircase}
        }
    }

    proc tunnel {} {
        puts "== Underworld Tunnel =="
        puts -nonewline "The strange tunnel stretches on for a long while, but it\
        quickly becomes too narrow for you to proceed. There is an elevator and a\
        door that appears to lead to a science lab. The other doors are on the other\
        side of the narrow tunnel and are inaccessible to you."
        if {[state get golden-arches]} then {
            puts " Next to the science lab, there is a shining golden arch."
        } else {
            puts {}
        }
        prompt {} {
            {"Enter the science lab" yes scienceLab}
            {"Enter the elevator" yes {lift ::Underworld::Elevator::tunnel}}
            {"Pass through the golden arch" {[state get golden-arches]} ::Console::Hall::future}
            {"Go back" yes staircase}
        }
    }

    proc scienceLab {} {
        switch [state get johnny-quest] {
            no - accepted {
                puts "Unfortunately, the door to the science lab appears to be bolted from the inside."
                puts {}
                return tunnel
            }
            default {
                puts "== Underworld Science Lab =="
                set necro [expr {
                           ([state get butler-game] ni {no cell cell1 pawn}) &&
                           ([state get talked-to-cipher] eq {yes}) &&
                           ([state get pawn-shop-pass] eq {yes}) &&
                           ([state get necro-cipher] in {no spoken found encouraged rising help})}]
                if {$necro} then {
                    set cipher "Dr. Cipher is pacing back and forth, looking\
                    fairly annoyed."
                } elseif {[state get talked-to-cipher]} then {
                    set cipher "Dr. Cipher is examining some strange contraption."
                } else {
                    set cipher "There is a strange horned man in a lab coat poking and prodding at\
                    a strange contraption."
                }
                set joe {}
                if {[state get necro-cipher] in {beaten yes}} then {
                    set joe " In the corner of the room, a cage hanging from the\
                    ceiling houses Joe the Time-Traveler."
                }
                puts "The science lab is surprisingly futuristic looking, given the\
                surrounded environment. $cipher$joe"
                prompt {} {
                    {"Talk to the man" {![state get talked-to-cipher]} cipherTalk}
                    {"Talk to Dr. Cipher" {[state get talked-to-cipher]} cipherTalk}
                    {"Talk to Joe" {[state get necro-cipher] in {beaten item yes}} joeTalk}
                    {"Go back out" yes tunnel}
                }
            }
        }
    }

    # //// The rest of Johnny Death, then space (space - moon, satellite, deep space, alien colony, plant monster)

    proc lift {back} {
        if {[inv has {Elevator Access Key}] || [inv has {Upgraded Elevator Access Key}]} then {
            puts "== Elevator =="
            puts -nonewline "The elevator is relatively small, only big enough for two or\
            three people."
            if {[inv has {Upgraded Elevator Access Key}]} then {
                puts "As you enter the elevator, all of the buttons on the panel light up."
            } else {
                puts "There are a handful of buttons on the panel, but only a few of them are lit up."
            }
            prompt {} {
                {"Go to the underworld" yes tunnel}
                {"Go to the overworld" yes ::City::District::shopping}
                {"Go to outer space" {[inv has {Upgraded Elevator Access Key}]} ::Space::Satellite::elevatorRoom}
            }
        } else {
            puts "The elevator seems to require a key to operate..."
            puts {}
            return $back
        }
    }

    proc cipherTalk {} {
        set necro [expr {
                   ([state get butler-game] ni {no cell cell1 pawn}) &&
                   ([state get talked-to-cipher] eq {yes}) &&
                   ([state get pawn-shop-pass] eq {yes}) }]
        if {[state get talked-to-cipher]} then {
            if {$necro} then {
                switch [state get necro-cipher] {
                    no {
                        puts "\"Hrm....\""
                        prompt {} {
                            {"\"Can I use the Document Transmogrifier?\"" yes cipherErase}
                            {"\"Is something wrong?\"" yes cipherWrong}
                            {"Tell him about the Ancient Minister." {([state get talked-to-acolyte] eq {yes}) && ([state get subspace-reason] ne {no})} cipherMinister}
                            {"\"Later.\"" yes scienceLab}
                        }
                    }
                    spoken {
                        puts "\"Hrm...\""
                        prompt {} {
                            {"\"Can I use the Document Transmogrifier?\"" yes cipherErase}
                            {"\"Tell me about this thief.\"" yes cipherDetails}
                            {"Tell him about the Ancient Minister." {([state get talked-to-acolyte] eq {yes}) && ([state get subspace-reason] ne {no})} cipherMinister}
                            {"\"Later.\"" yes scienceLab}
                        }
                    }
                    found {
                        puts "\"Hrm...\""
                        prompt {} {
                            {"\"Can I use the Document Transmogrifier?\"" yes cipherErase}
                            {"Tell him about Joe" yes cipherJoe}
                            {"Tell him about the Ancient Minister" {([state get talked-to-acolyte] eq {yes}) && ([state get subspace-reason] ne {no})} cipherMinister}
                            {"\"Later.\"" yes scienceLab}
                        }
                    }
                    rising - help {
                        puts "\"Hrm...\""
                        prompt {} {
                            {"\"Can I use the Document Transmogrifier?\"" yes cipherErase}
                            {"\"Joe is using the Certificate!\"" yes cipherDeadly}
                            {"Tell him about the Ancient Minister" {([state get talked-to-acolyte] eq {yes}) && ([state get subspace-reason] ne {no})} cipherMinister}
                            {"\"Later.\"" yes scienceLab}
                        }
                    }
                    beaten - item {
                        puts "\"Hrm...\""
                        prompt {} {
                            {"\"Can I use the Document Transmogrifier?\"" yes cipherErase}
                            {"\"I defeated Joe.\"" yes cipherCaught}
                            {"Give him the Certificate" {[inv has {Necromancy Certificate}]} cipherCertificate}
                            {"Tell him about the Ancient Minister" {([state get talked-to-acolyte] eq {yes}) && ([state get subspace-reason] ne {no})} cipherMinister}
                            {"\"Later.\"" yes scienceLab}
                        }
                    }
                    yes {
                        puts "\"Heyyyy it's good to see you again! Would you like me to erase\
                        your records?\""
                        prompt {} {
                            {"\"Yes, please.\"" yes cipherErase}
                            {"Tell him about the Ancient Minister" {([state get talked-to-acolyte] eq {yes}) && ([state get subspace-reason] ne {no})} cipherMinister}
                            {"\"Not right now.\"" yes scienceLab}
                        }
                    }
                    encouraged - default {
                        puts "\"Hrm...\""
                        prompt {} {
                            {"\"Can I use the Document Transmogrifier?\"" yes cipherErase}
                            {"Tell him about the Ancient Minister" {([state get talked-to-acolyte] eq {yes}) && ([state get subspace-reason] ne {no})} cipherMinister}
                            {"\"Later.\"" yes scienceLab}
                        }
                    }
                }
            } else {
                puts "\"Heyyyy it's good to see you again! Would you like me to erase your records?\""
                prompt {} {
                    {"\"Yes, please.\"" yes cipherErase}
                    {"Tell him about the Ancient Minister." {([state get talked-to-acolyte] eq {yes}) && ([state get subspace-reason] ne {no})} cipherMinister}
                    {"\"Not right now.\"" yes scienceLab}
                }
            }
        } else {
            state put talked-to-cipher yes
            puts "\"Heyyyy ol' Johnny's friend, aren't ya? I'm Dr. Cipher, and\
            Johnny has told me all about you. Would you like to\
            hear about my latest invention?\""
            prompt {} {
                {"\"Yes.\"" yes {cipherExplain yes}}
                {"\"Not really.\"" yes {cipherExplain no}}
            }
        }
    }

    proc cipherExplain {answer} {
        if {!$answer} then {
            puts "\"Well I want to tell you anyway, so listen up!\""
        }
        puts "\"I call it the Document Transmogrifier! With just the press of a button, I can\
        erase your name and information from every record in every database in the universe!\
        Criminal record? Gone! History of psychological problems? Erased! Every document with your\
        name on it gets shredded. And since you're a friend of Johnny's, you can use it anytime!\""
        prompt {} {
            {"\"Can I use it now?\"" yes cipherErase}
            {"\"Okay. Thanks.\"" yes scienceLab}
        }
    }

    proc cipherMinister {} {
        puts "\"What's that? An ancient minister is judging you for nearly ending the universe?\
        Happens all the time! Just one use of the Document Transmogrifier, and he'll forget\
        all about it!\""
        prompt {} {
            {"\"Okay. I'd like to use the machine.\"" yes cipherErase}
            {"\"Maybe later.\"" yes scienceLab}
        }
    }

    proc cipherErase {} {
        puts "Dr. Cipher presses a big red button, and a loud whirring sound pierces your ears."
        puts "\"It is done!\""
        state put trial-crime no
        state put subspace-reason no
        puts {}
        return scienceLab
    }

    proc cipherWrong {} {
        puts "\"Hrmm... I can trust you, right?\""
        prompt {} {
            {"\"Of course.\"" yes cipherWrong1}
            {"\"Not really.\"" yes cipherWrong2}
        }
    }

    proc cipherWrong1 {} {
        puts "\"Good. That's what I thought. You see, in addition to engineering, I\
        also dabble in necromancy. I'm a certified necromancer, at that. But a few months\
        ago, my Necromancy Certificate was stolen from me, and I've been unable to locate\
        the thief. The Certificate grants the holder unimaginable power over the dead, so\
        I fear for the overworld if they can decipher the scripts written on it. If you\
        happen to notice anyone carrying an ancient white scroll with cursed glyphs on it,\
        let me know.\""
        state put necro-cipher spoken
        prompt {} {
            {"\"I will.\"" yes scienceLab}
            {"\"Do you know anything about the thief?\"" yes cipherDetails}
        }
    }

    proc cipherWrong2 {} {
        puts "\"Very well.\""
        puts {}
        return scienceLab
    }

    proc cipherDetails {} {
        puts "\"Certainly human. Yes, certainly human. He was sort of normal-looking,\
        if you know what I mean. Not the sort to stand out in a crowd. That's all I know.\""
        puts {}
        return scienceLab
    }

    proc cipherJoe {} {
        puts "\"Hm? A time traveler hiding in subspace has a white scroll? Of course! That's\
        why I couldn't detect its energy; the clever thief hid the Certificate in subspace.\
        You need to reclaim that Certificate for me at all costs. The fate of the world depends\
        on it!\""
        prompt {} {
            {"\"You can count on me!\"" yes cipherCount}
            {"\"Why is the whole world at stake?\"" yes cipherWhy}
        }
    }

    proc cipherCount {} {
        puts "\"I knew I could count on you!\""
        state put necro-cipher encouraged
        puts {}
        return scienceLab
    }

    proc cipherWhy {} {
        puts "\"This was no amateur theft. The thief knew how to hide the Certificate's\
        energies. I can only imagine the diabolical schemes that our thief is dreaming\
        up right now.\""
        state put necro-cipher encouraged
        prompt {} {
            {"\"Okay.\"" yes scienceLab}
        }
    }

    proc cipherDeadly {} {
        puts "\"What?! No, you have to stop him! If he's using the Certificate, then\
        only a true Hero's weapon will be able to defeat him!\""
        prompt {} {
            {"\"Okay.\"" yes scienceLab}
        }
    }

    proc cipherCaught {} {
        # //// Option to give him the certificate here too
        puts "\"Yes, he may have mentioned that in his incoherent tirades as I imprisoned\
        him. But what of the Certificate?\""
        prompt {} {
            {"\"It fell into a hole.\"" yes cipherCaught1}
        }
    }

    proc cipherCaught1 {} {
        # //// If you have the Certificate, Dr. Cipher can detect it
        # and gives a different response
        puts "\"Ah, the hole created by the necromancy? That is unfortunate but not\
        catastrophic. You should be able to safely climb into the hole and retrieve\
        it.\""
        prompt {} {
            {"\"Okay.\"" yes scienceLab}
            {"\"What about Joe?\"" yes cipherCaught2}
        }
    }

    proc cipherCaught2 {} {
        puts "\"Our thief? Well, as you can see, he is quite secure here. I'll\
        make sure he can't do anything more to get in your way.\""
        puts {}
        return scienceLab
    }

    proc cipherCertificate {} {
        puts "You hand the Necromancy Certificate to Dr. Cipher."
        puts "\"My Certificate! Marvelous! Excellent work! How can I ever repay you?\""
        prompt {} {
            {"\"A million Silver Coins?\"" yes {cipherReward million}}
            {"\"Any cool gadgets I can have?\"" yes {cipherReward gadget}}
            {"\"All in a day's work.\"" yes {cipherReward none}}
        }
    }

    proc cipherReward {answer} {
        switch $answer {
            million {
                puts "\"Well I'm afraid I don't have that sort of money. But I can give\
                you something neat.\""
            }
            gadget {
                puts "\"Excellent idea!\""
            }
            none {
                puts "\"Well, I can't simply let you leave here empty-handed. I know!\""
            }
        }
        puts "\"You see, years ago, I worked with Dr. Louis in the overworld on a few\
        projects. I believe you've met her, actually. I believe I still have the key\
        to one of my inventions.\""
        puts "Dr. Cipher fumbles about with his pockets for a moment."
        puts "\"Aha! Here you go! You're welcome to try it out anytime.\""
        puts "Dr. Cipher hands you the Heart Key."
        state put necro-cipher yes
        inv add {Heart Key}
        puts {}
        return scienceLab
    }

    proc joeTalk {} {
        puts "\"These bars will not contain me! I will escape and claim my rightful\
        place as ruler of this world!\""
        prompt {} {
            {"\"Have fun with that.\"" yes scienceLab}
        }
    }

}
