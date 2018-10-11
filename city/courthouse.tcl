
namespace eval City::Courthouse {

    proc entrance {} {
        puts "== Courthouse Entrance =="
        if {[state get courthouse-door] eq {yes}} then {
            puts "The front door to the courthouse is unlocked, but there seems to be no one\
            inside."
            prompt {} {
                {"Go inside" yes inside}
                {"Go back" yes ::City::District::police}
            }
        } else {
            puts "Unfortunately, the front door to the courthouse appears to be locked. There are no\
            unlocked entrances, from what you can tell."
            prompt {} {
                {"Knock on the door" yes knocking}
                {"Use the Courthouse Key" {[inv has {Courthouse Key}]} unlock}
                {"Go back" yes ::City::District::police}
            }
        }
    }

    proc knocking {} {
        puts "You knock on the front door, but no one comes."
        prompt {} {
            {"Go back" yes ::City::District::police}
        }
    }

    proc trial {} {
        puts "== Courtroom =="
        state put courthouse-door no
        puts "Despite the late hour, the lights of the courtroom are bright and direct. You step up\
        to the bench and sit down."
        puts "An older judge walks in, complete with the traditional wig of judges of old."
        switch [state get trial-reason] {
            murder {
                puts "\"Alright, order. Order! Now, you are being tried for murder, after a\
                rather unusual confession. Are you prepared to cooperate and go to prison for this?\""
            }
            escape {
                puts "\"Alright! Didn't I just convict you? Hm? Oh, you escaped... alright then, this\
                should be quick. Do you plead guilty to the charge of escaping from prison?\""
            }
        }
        prompt {} {
            {"\"Yes. I'm guilty.\"" yes guilty}
            {"\"No! I was framed!\"" yes innocent}
            {"\"Not a word until my lawyer gets here!\"" {[state get attorney-self] ne {no}} lawyer}
        }
    }

    proc guilty {} {
        switch [state get trial-reason] {
            murder {
                puts "\"Excellent. Then that makes this easy. I declare the suspect guilty. You\
                will be sentenced to twenty years in prison.\""
            }
            escape {
                puts "\"Right. Then that'll be an additional year added to the end of your sentence.\""
            }
        }
        puts "You are taken out of the courtroom and placed in the back of a large truck. The\
        truck sets off to your destination."
        state put trial-crime prison
        puts {}
        return ::Prison::South::entry
    }

    proc innocent {} {
        switch [state get trial-reason] {
            murder {
                puts "\"Well that is a bother. However, we have a video recording of you confessing to\
                the crime in question to a room full of police officers. So I do believe you\
                are guilty. You will be sentenced to twenty years in prison.\""
            }
            escape {
                puts "\"I... You... It's in the record that you are supposed to be in prison. There is\
                literally no way to challenge this. Guilty!\""
            }
        }
        puts "You are taken out of the courtroom and placed in the back of a large truck. The\
        truck sets off to your destination."
        state put trial-crime prison
        puts {}
        return ::Prison::South::entry
    }

    proc lawyer {} {
        puts "\"Did somebody say lawyer?!\""
        puts "Attorney-Man kicks open the courtroom door. The judge flinches."
        puts "\"No! Not you! Get out of my courtroom!\""
        puts "\"You cannot stop the forces of justice! Now bow before my justice!\""
        puts "Attorney-Man runs into the fray and begins throwing punches at everyone\
        else in the courtroom. The judge and everyone else flee the courtroom."
        puts "\"Ah, another victory for justice! Attorney-Man away!\""
        puts "Attorney-Man runs out the back door, leaving you alone."
        if {[state get attorney-self] eq {okay}} then {
            state put attorney-self yes
            state put attorney-man [switch [state get attorney-man] {
                fed 1
                1 2
                2 done
            }]
        }
        puts {}
        return courtroom
    }

    proc courtroom {} {
        puts "== Courtroom =="
        puts "The courtroom looks like any other, with a jury box on the right, several seats\
        in the back, and a bench for the judge at the front. You are alone in the courtroom."
        prompt {} {
            {"Exit the courtroom" yes inside}
        }
    }

    proc inside {} {
        puts "== Courthouse Foyer =="
        puts -nonewline "At this hour, the courthouse is deserted. The foyer consists of\
        two floors. Upstairs, the courtroom doors are still open. Downstairs, there is a\
        row of offices down a hallway."
        if {[state get courtroom-key] eq {no}} then {
            puts {}
        } else {
            puts " A window off to the left is broken and has been hastily repaired with\
            some wooden beams."
        }
        prompt {} {
            {"Go upstairs" yes courtroom}
            {"Go down the hall" yes halls}
            {"Leave the courthouse" yes exitBuilding}
        }
    }

    proc exitBuilding {} {
        state put courthouse-door yes
        return entrance
    }

    proc halls {} {
        puts "== Courthouse Halls =="
        puts "The hallway is equally deserted. Unfortunately, all of the doors seem to be\
        locked."
        prompt {} {
            {"Use the Courthouse Key" {[inv has {Courthouse Key}]} unlock1}
            {"Go back to the foyer" yes inside}
        }
    }

    proc unlock {} {
        puts "The Courthouse Key does not fit this lock."
        puts {}
        return entrance
    }

    proc unlock1 {} {
        puts "The Courthouse Key unlocks one of the offices."
        puts {}
        return judgeOffice
    }

    proc judgeOffice {} {
        puts "== Judge's Office =="
        puts -nonewline "The judge's office is very neat and tidy. There are stacks of papers\
        on the desk and on the floor behind the desk. No one is in the room at this time, aside\
        from you."
        if {[state get judge-paperclip] eq {no}} then {
            puts -nonewline " An oversized paperclip on the desk catches your eye."
        }
        if {[state get judge-muffin] eq {no}} then {
            puts -nonewline " There is a muffin sitting on the judge's desk."
        }
        puts {}
        prompt {} {
            {"Take the muffin" {[state get judge-muffin] eq {no}} judgeMuffin}
            {"Take the paperclip" {[state get judge-paperclip] eq {no}} judgePaperclip}
            {"Leave the office" yes halls}
        }
    }

    proc judgeMuffin {} {
        puts "You claim the muffin on the judge's desk."
        puts "You got the Banana Nut Muffin!"
        state put judge-muffin yes
        muffin add {Banana Nut Muffin}
        puts {}
        return judgeOffice
    }

    proc judgePaperclip {} {
        puts "You take the oversized paperclip."
        puts "You got the Brass Paperclip!"
        state put judge-paperclip yes
        inv add {Brass Paperclip}
        puts {}
        return judgeOffice
    }

}
