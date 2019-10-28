
namespace eval Inverse::Class {

    proc seat {} {
        # //// So in each period (except "no", obviously), there will
        # be a (probably different) student sitting nearby that you
        # can talk to.
        switch [state get school-period] {
            no {
                puts "You take a seat, but there's no one else in the room.\
                Nobody seems to be coming or going."
                prompt {} {
                    {"Get back up" yes ::Inverse::School::classroom}
                }
            }
            first {
                # //// First period neighbor
                prompt {} {
                    {"Wait for class to start" yes firstPeriod}
                    {"Get back up" yes ::Inverse::School::classroom}
                }
            }
            second {
                # //// Second period neighbor
                prompt {} {
                    {"Wait for class to start" yes secondPeriod}
                    {"Get back up" yes ::Inverse::School::classroom}
                }
            }
            third {
                # //// Third period neighbor
                # ////
                prompt {} {
                    {"Wait for class to start" yes {::Empty::back ::Inverse::Class::seat}}
                    {"Get back up" yes ::Inverse::School::classroom}
                }
            }
            first1 - second1 {
                # This shouldn't happen as you shouldn't even be allowed this far
                return ::Inverse::School::north
            }
            third1 {
                # ////
                return ::Inverse::School::north
            }
        }
    }

    proc firstPeriod {} {
        puts "After some time, a man in a traditional judge's wig walks in."
        puts "\"Good morning, class, and welcome to your governance class.\
        Today, we'll be having a brief quiz to ensure that you all remember how\
        the government works.\""
        puts "The judge hands out a sheet of paper to each student. The quiz would\
        seem to be multiple choice."
        prompt {} {
            {"Take the quiz" yes {firstPeriod1 0}}
        }
    }

    # //// We'll shuffle these around soon. Right now, all of the
    # right answers are always D.

    proc firstPeriod1 {correct} {
        puts "** Question 1 **"
        puts "When do you have the right to speak ill of the Robot King?"
        set a "{Always} yes {firstPeriod2 $correct}"
        set b "{Only in a court of law} yes {firstPeriod2 $correct}"
        set c "{If directly asked a question} yes {firstPeriod2 $correct}"
        set d "{Never} yes {firstPeriod2 [expr {$correct + 1}]}"
        prompt {} [list $a $b $c $d]
    }

    proc firstPeriod2 {correct} {
        puts "** Question 2 **"
        puts "If you feel you have been wronged by the Robot King, what should you do?"
        set a "{File for lawsuit at your local courthouse} yes {firstPeriod3 $correct}"
        set b "{Seek revenge under cover of darkness} yes {firstPeriod3 $correct}"
        set c "{Confront the Robot King clearly and directly} yes {firstPeriod3 $correct}"
        set d "{Accept that the Robot King is correct and you are flawed} yes {firstPeriod3 [expr {$correct + 1}]}"
        prompt {} [list $a $b $c $d]
    }

    proc firstPeriod3 {correct} {
        puts "** Question 3 **"
        puts "If you feel as though your loyalty to the Robot King is slipping, what should you do?"
        set a "{Speak to the Mesmerist} yes {firstPeriod4 $correct}"
        set b "{Admit yourself for reeducation} yes {firstPeriod4 $correct}"
        set c "{Remind yourself of the Robot King's greatness} yes {firstPeriod4 $correct}"
        set d "{All of the above} yes {firstPeriod4 [expr {$correct + 1}]}"
        prompt {} [list $a $b $c $d]
    }

    proc firstPeriod4 {correct} {
        puts "** Question 4 **"
        puts "What is the judge's primary purpose in the Robot King's empire?"
        set a "{To maximize happiness and prosperity} yes {firstPeriod5 $correct}"
        set b "{To represent the people's interests} yes {firstPeriod5 $correct}"
        set c "{To teach a class on governance} yes {firstPeriod5 $correct}"
        set d "{To see the Robot King's will fulfilled} yes {firstPeriod5 [expr {$correct + 1}]}"
        prompt {} [list $a $b $c $d]
    }

    proc firstPeriod5 {correct} {
        puts "** Question 5 **"
        puts "If the Robot King summons you, what is your responsibility?"
        set a "{To flee the city} yes {firstPeriodResult $correct}"
        set b "{To guess what the Robot King wants} yes {firstPeriodResult $correct}"
        set c "{To hide away} yes {firstPeriodResult $correct}"
        set d "{To do exactly what he asks and nothing more} yes {firstPeriodResult [expr {$correct + 1}]}"
        prompt {} [list $a $b $c $d]
    }

    proc firstPeriodResult {correct} {
        puts "That would seem to be the last of the questions."
        prompt {} "{{Turn in the quiz} yes {firstPeriodResult1 $correct}}"
    }

    proc firstPeriodResult1 {correct} {
        puts "You place your quiz on the judge's desk. He glances at it for a moment."
        switch $correct {
            0 {
                puts "\"You got every question wrong! I'm afraid you fail this class!\""
                state put first-period-pass no
            }
            1 {
                puts "\"You got one question right. I'm afraid you need to study more. You've\
                failed this class.\""
                state put first-period-pass no
            }
            2 {
                puts "\"You got two questions right. I'm afraid you'll need to study more. You've\
                failed this class.\""
                state put first-period-pass no
            }
            3 {
                puts "\"You got three questions right. I'll pass you, but make sure to study\
                harder.\""
                state put first-period-pass partial
            }
            4 {
                puts "\"You got one question wrong. That's a pass in my book!\""
                state put first-period-pass partial
            }
            5 {
                puts "\"You got a perfect score! Congratulations!\""
                state put first-period-pass yes
            }
        }
        state put school-period first1
        prompt {} {
            {"Leave the classroom" yes ::Inverse::School::north}
        }
    }

    proc secondPeriod {} {
        puts "After a bit, a conservatively-dressed woman with short\
        black hair and glasses walks in."
        puts "\"Hello, class. My name is Mavis, and I'll be teaching your language\
        arts class today. Now, I'd like everybody to form a line. I'm going to have\
        you practice your diction.\""
        puts "All of the other students get out of their seats and begin to form\
        a line behind Mavis' podium."
        prompt {} {
            {"Get in line" yes secondPeriodBegin}
        }
    }

    proc secondPeriodBegin {} {
        puts "You get in line relatively close to the front and wait your turn."
        puts "..."
        puts "Before much time has passed, you reach the front of the line. Mavis\
        glances at you for a moment before speaking."
        puts "\"Alright, I need you to repeat after me. 'All hail the Robot King.'\""
        return {secondPeriod1 0}
    }

    proc secondPeriod1 {correct} {
        set a "{\"I'll\"} yes {secondPeriod2 $correct}"
        set b "{\"All\"} yes {secondPeriod2 [expr {$correct + 1}]}"
        set c "{\"Ill\"} yes {secondPeriod2 $correct}"
        set d "{\"Y'all\"} yes {secondPeriod2 $correct}"
        prompt {} [list $a $b $c $d]
    }

    proc secondPeriod2 {correct} {
        set a "{\"Yell\"} yes {secondPeriod3 $correct}"
        set b "{\"Ail\"} yes {secondPeriod3 $correct}"
        set c "{\"Hail\"} yes {secondPeriod3 [expr {$correct + 1}]}"
        set d "{\"Bail\"} yes {secondPeriod3 $correct}"
        prompt {} [list $a $b $c $d]
    }

    proc secondPeriod3 {correct} {
        set a "{\"The\"} yes {secondPeriod4 [expr {$correct + 1}]}"
        set b "{\"Ye\"} yes {secondPeriod4 $correct}"
        set c "{\"Me\"} yes {secondPeriod4 $correct}"
        set d "{\"Spree\"} yes {secondPeriod4 $correct}"
        prompt {} [list $a $b $c $d]
    }

    proc secondPeriod4 {correct} {
        set a "{\"Onion ring\"} yes {secondPeriod5 $correct}"
        set b "{\"Robot King\"} yes {secondPeriod5 [expr {$correct + 1}]}"
        set c "{\"Laser beam\"} yes {secondPeriod5 $correct}"
        set d "{\"Strawberry ice cream\"} yes {secondPeriod5 $correct}"
        prompt {} [list $a $b $c $d]
    }

    proc secondPeriod5 {correct} {
        switch $correct {
            0 - 1 - 2 {
                puts "\"Hm... I'm sorry. That doesn't sound quite right. You need to try\
                harder next time.\""
                state put second-period-pass no
            }
            3 {
                puts "\"That's... pretty close. I believe you passed the class.\""
                state put second-period-pass partial
            }
            4 {
                puts "\"Very good! That sounded perfect!\""
                state put second-period-pass yes
            }
        }
        state put school-period second1
        prompt {} {
            {"Leave the classroom" yes ::Inverse::School::north}
        }
    }

}
