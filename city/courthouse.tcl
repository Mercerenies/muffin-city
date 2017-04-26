
namespace eval City::Courthouse {

    proc entrance {} {
        puts "== Courthouse Entrance =="
        puts "Unfortunately, the front door to the courthouse appears to be locked. There are no unlocked\
        entrances, from what you can tell."
        prompt {} {
            {"Knock on the door" yes knocking}
            {"Go back" yes ::City::District::police}
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
        puts "Despite the late hour, the lights of the courtroom are bright and direct. You step up to the\
        bench and sit down."
        puts "An older judge walks in, complete with the traditional wig of judges of old."
        switch [state get trial-reason] {
            murder {
                puts "\"Alright, order. Order! Now, you are being tried for murder, after a rather unusual\
                confession. Are you prepared to cooperate and go to prison for this?\""
            }
            escape {
                puts "\"Alright! Didn't I just convict you? Hm? Oh, you escaped... alright then, this\
                should be quick. Do you plead guilty to the charge of escaping from prison?\""
            }
        }
        prompt {} {
            {"\"Yes. I'm guilty.\"" yes guilty}
            {"\"No! I was framed!\"" yes innocent}
        }
    }

    proc guilty {} {
        switch [state get trial-reason] {
            murder {
                puts "\"Excellent. Then that makes this easy. I declare the suspect guilty. You will be\
                sentenced to twenty years in prison.\""
            }
            escape {
                puts "\"Right. Then that'll be an additional year added to the end of your sentence.\""
            }
        }
        puts "You are taken out of the courtroom and placed in the back of a large truck. The truck sets off\
        to your destination."
        state put trial-crime prison
        puts {}
        return ::Prison::South::entry
    }

    proc innocent {} {
        # //// What if we have a lawyer?
        switch [state get trial-reason] {
            murder {
                puts "\"Well that is a bother. However, we have a video recording of you confessing to\
                the crime in question to a room full of police officers. So I do believe you are guilty.\
                You will be sentenced to twenty years in prison.\""
            }
            escape {
                puts "\"I... You... It's in the record that you are supposed to be in prison. There is\
                literally no way to challenge this. Guilty!\""
            }
        }
        puts "You are taken out of the courtroom and placed in the back of a large truck. The truck sets off\
        to your destination."
        state put trial-crime prison
        puts {}
        return ::Prison::South::entry
    }

}
