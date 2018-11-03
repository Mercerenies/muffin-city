
namespace eval Prison::Cottage {

    proc yard {} {
        puts "== Cottage Yard =="
        puts -nonewline "A large yard gives way to a small, quaint one-story cottage.\
        Beside the cottage, there sits an old wooden shed."
        if {[state get cottage-spirit] in {no evil}} then {
            puts " A friendly-looking farmer is cleaning up the yard."
        } else {
            puts {}
        }
        prompt {} {
            {"Talk to the farmer" {[state get cottage-spirit] in {no evil}} farmer}
            {"Enter the cottage" yes cottage}
            {"Enter the shed" yes shed}
            {"Head back into the forest" yes wander}
        }
    }

    proc cottage {} {
        puts "== Cottage =="
        puts -nonewline "The inside of the cottage is equally quaint, with a\
        relatively large central living space. There is a sofa up against the wall,\
        a table over in the opposite corner, and some stairs leading to an underground\
        area."
        switch [state get cottage-spirit] {
            no - evil {
                puts " A young woman is preparing a meal, while her son waits patiently\
                at the table."
            }
            starlight - starlight1 {
                puts " The farmer, his wife, and his son are standing against the wall,\
                somewhat nervous"
            }
            default {
                puts {}
            }
        }
        prompt {} {
            {"Take a nap on the sofa" yes {::Dream::Transit::awaken ::Dream::Transit::thirdRoom}}
            {"Talk to the woman" {[state get cottage-spirit] in {no evil}} wife}
            {"Talk to the child" {[state get cottage-spirit] in {no evil}} son}
            {"Talk to the family" {[state get cottage-spirit] in {starlight}} familyScared}
            {"Go downstairs" yes downstairs}
            {"Go back outside" yes yard}
        }
    }

    proc shed {} {
        puts "== Cottage Shed =="
        puts -nonewline "The shed is relatively small but open. There are tools on\
        shelves against all of the walls but the entire middle of the shed is open\
        space."
        switch [state get cottage-spirit] {
            starlight {
                puts " A young woman in a black dress is frantically searching\
                the shed for something."
            }
            starlight1 {
                puts " Silver Starlight is sitting on a crate in the corner,\
                looking slightly annoyed at herself."
            }
            default {
                puts {}
            }
        }
        # //// The sorcerer character whom I haven't decided on a name for yet
        prompt {} {
            {"Talk to the woman" {[state get cottage-spirit] eq {starlight}} starlightIntro}
            {"Talk to Starlight" {[state get cottage-spirit] eq {starlight1}} starlightTalk}
            {"Go back outside" yes yard}
        }
    }

    proc downstairs {} {
        puts "== Cottage Cellar =="
        # //// The Hatman is going to be here.
        puts "The cellar is dimly lit and relatively small. There are some bottled\
        beverages on a rack against the back wall."
        prompt {} {
            {"Go upstairs" yes cottage}
        }
    }

    proc farmer {} {
        if {[state get cottage-spirit] eq {evil}} then {
            return farmerIdle
        }
        puts "\"Well, hello there, stranger. It's such a nice day out, isn't it?\""
        prompt {} {
            {"\"Yes, it is.\"" yes farmer1}
        }
    }

    proc farmer1 {} {
        puts "\"My family is inside. Feel free to say hi to them. I should be getting\
        back to work.\""
        state put cottage-spirit evil
        prompt {} {
            {"\"Have a good day.\"" yes yard}
        }
    }

    proc farmerIdle {} {
        puts "\"Hello there, stranger.\""
        puts {}
        return yard
    }

    proc wife {} {
        puts "\"Hello, stranger!\""
        puts {}
        return cottage
    }

    proc son {} {
        puts "\"Dinner will be ready soon.\""
        puts {}
        return cottage
    }

    proc familyScared {} {
        puts "The farmer speaks up first."
        puts "\"That strange woman told us there were evil spirits around.\""
        puts {}
        return cottage
    }

    proc starlightIntro {} {
        puts "\"Can't talk right now. Hunting for evil spirits.\""
        prompt {} {
            {"\"Uhhh... who are you?\"" yes starlightIntro1}
            {"\"Later then.\"" yes shed}
        }
    }

    proc starlightIntro1 {} {
        puts "The woman stops searching and turns around."
        puts "\"Why, I'm Silver Starlight! Haven't you heard of me?\""
        prompt {} {
            {"\"Of course I have!\"" yes {starlightIntro2 yes}}
            {"\"No.\"" yes {starlightIntro2 no}}
        }
    }

    proc starlightIntro2 {response} {
        if $response then {
            puts "\"I hate to say it, but you're not a great liar. Anyway, I'm\
            a local sorceress. I'm just starting out.\""
        } else {
            puts "\"That's okay. I'm just starting out, but I want to be a master\
            sorceress!\""
        }
        prompt {} {
            {"\"And the spirits?\"" yes starlightIntro3}
        }
    }

    proc starlightIntro3 {} {
        puts "\"Oh, right, the spirits! I've been hearing rumors about people disappearing\
        into these woods, so I came to investigate. The source of the evil is this shed,\
        but... well, this is kind of embarrassing ... ...\""
        prompt {} {
            {"\"Yes?\"" yes starlightIntro4}
        }
    }

    proc starlightIntro4 {} {
        puts "\"Well... I lost my magic scepter on the way in. If I had my scepter, I\
        could force the spirits to show themselves. But without it, I'm having to search\
        this place by hand.\""
        prompt {} {
            {"\"Where did you lose your scepter?\"" yes starlightIntro5}
        }
    }

    proc starlightIntro5 {} {
        puts "\"Oh, you'll never find that one. The evil spirits control these woods. I'm\
        sure they've gotten rid of it by now. I have all the tools I need to make a new one,\
        but I'd need a crystal ball. If you could find me a crystal ball, I could finish\
        my new scepter\""
        prompt {} {
            {"\"I'll do it.\"" yes starlightIntro6}
        }
    }

    proc starlightIntro6 {} {
        puts "\"Alright! That'll make this a lot easier!\""
        state put cottage-spirit starlight1
        puts {}
        return shed
    }

    proc starlightTalk {} {
        puts "\"Did you find a crystal ball?\""
        prompt {} {
            {"\"Not yet.\"" yes shed}
        }
    }

    proc wander {} {
        # //// Once you've cleared the evil spirits, perhaps this actually does take you back
        puts "You head back into the forest and travel in a straight line. Rather quickly,\
        you end up back at the cottage."
        puts {}
        return yard
    }

}
