
namespace eval Inverse::Dodgeball {

    proc intro {} {
        puts "After some time waiting, Carl the bus driver enters the classroom, dragging\
        along a large basket of dodgeballs with him."
        # //// So this is going to go differently depending on how
        # many students you have on your side. You can stay in the
        # game well enough to pass with no one's help, but you can't
        # beat the teachers without everyone.
        # //// Dive early
        prompt {} {
            {"Keep waiting" yes wait}
            {"Dive in and grab a dodgeball" yes {::Empty::back ::Inverse::Dodgeball::intro}}
        }
    }

    proc wait {} {
        puts "Carl takes up the front of the room and speaks."
        puts "\"Alright, a lot of you are very close to being ready to leave this school.\
        But in order to be truly loyal to the Robot King, you need to be ready to defend\
        him at any cost. So we'll be practicing agility today.\""
        puts "Todd steps in and speaks."
        puts "\"The game is dodgeball. The rules are simple. If you get tagged out twice,\
        you fail the class.\""
        puts "Todd removes his glasses gently and places them in one of the desks against\
        the wall."
        # //// I'll write this scene in full later, once we know which
        # NPCs will be involved. For now, it's just a stub so you can
        # do the other stuff that involves the school.
        prompt {} {
            {"Play aggressively" yes stubWin}
            {"Play defensively" yes stubWin}
            {"Stand there doing nothing" yes stubLose}
        }
    }

    proc stubWin {} {
        puts "You play to win and, although you wind up getting tagged out once,\
        you still manage to pass the class. When Carl calls time, you are quite tired."
        puts "\"Alright. I have to go tend to the bus. Everyone, please line up so\
        that Todd can tell you your final grades.\""
        puts "Carl hastens toward the exit as Todd places his glasses back on\
        his face."
        state put third-period-pass partial
        prompt {} {
            {"Get in line" yes result}
        }
    }

    proc stubLose {} {
        puts "You bluntly refuse to play, immediately getting tagged out twice.\
        Eventually, Carl calls time."
        puts "\"Alright. I have to go tend to the bus. Everyone, please line up so\
        that Todd can tell you your final grades.\""
        puts "Carl hastens toward the exit as Todd places his glasses back on\
        his face."
        state put third-period-pass no
        prompt {} {
            {"Get in line" yes result}
        }
    }

    proc result {} {
        puts "You wait patiently in line."
        puts "..."
        puts "Before much time, you find yourself facing Todd."
        puts "\"Alright, let's see.\""
        puts "He takes a look at a portable computer in his hand."
        switch [state get third-period-pass] {
            no {
                puts "\"Well, you definitely failed this class.\""
            }
            partial {
                puts "\"Well, you definitely passed this class.\""
            }
            yes {
                puts "\"Well, there's no doubt in my mind. You passed this class perfectly.\""
            }
        }
        prompt {} {
            {"\"I see...\"" yes result1}
        }
    }

    proc result1 {} {
        puts "Todd scrolls down on his computer."
        switch [state get first-period-pass] {
            no {
                puts "\"It looks like you failed your governance class.\""
            }
            partial {
                puts "\"It looks like you passed your governance class.\""
            }
            yes {
                puts "\"It looks like you passed your governance class. And the\
                judge left a note here. He's very impressed.\""
            }
        }
        prompt {} {
            {"\"Alright.\"" yes result2}
        }
    }

    proc result2 {} {
        switch [state get second-period-pass] {
            no {
                puts "\"Aaaaaand... you didn't do so well in language arts.\""
            }
            partial {
                puts "\"Aaaaaand... you passed language arts.\""
            }
            yes {
                puts "\"Aaaaaand... ah, a very good score in language arts.\""
            }
        }
        prompt {} {
            {"\"So what's the verdict?\"" yes result3}
        }
    }

    proc result3 {} {
        set class1 [expr {[state get first-period-pass] ne {no}}]
        set class2 [expr {[state get second-period-pass] ne {no}}]
        set class3 [expr {[state get third-period-pass] ne {no}}]
        set passed [expr {$class1 + $class2 + $class3}]
        switch $passed {
            0 {
                # F
                puts "\"You failed all of your classes. That's an F. I'm afraid you\
                need the Robot King's deluxe reeducation. Please wait outside and\
                I'll be with you in a moment.\""
                state put school-period first
                state put authorized-to-bus no
                # //// What happens if you've already rescued Topaz?
                prompt {} {
                    {"Head outside" yes ::Inverse::School::northWaiting}
                }
            }
            1 {
                # C
                puts "\"So you only passed one class. That's a C overall. I'm afraid\
                you'll have to stay here and do it again. Classes will start anew soon.\""
                state put school-period third1
                state put authorized-to-bus no
                prompt {} {
                    {"Exit the classroom" yes ::Inverse::School::north}
                }
            }
            2 {
                # B
                puts "\"So you passed two classes. That's a solid B. You're ready\
                to be released back into the Robot King's domain. Head to the\
                bus whenever you're ready to go.\""
                state put school-period third1
                state put authorized-to-bus yes
                prompt {} {
                    {"Exit the classroom" yes ::Inverse::School::north}
                }
            }
            3 {
                if {([state get first-period-pass] eq {yes}) &&
                    ([state get second-period-pass] eq {yes}) &&
                    ([state get third-period-pass] eq {yes})} then {
                    # A
                    puts "\"You got perfect marks in all of your classes. That means\
                    you get an A! The Robot King will love to hear this. I'll send your\
                    grades over to him right now. You should visit him as soon as you can.\
                    In the meantime, you can take the bus out of here.\""
                    # ////
                    puts "(Debug note: The Robot King audience has not been programmed yet)"
                    state put school-flying-colors passed
                    state put school-period third1
                    state put authorized-to-bus yes
                    prompt {} {
                        {"Exit the classroom" yes ::Inverse::School::north}
                    }
                } else {
                    # B
                    puts "\"So you passed all three classes. I give you a B. That means\
                    you're ready to be released back into the Robot King's domain. Head to the\
                    bus whenever you're ready to go.\""
                    state put school-period third1
                    state put authorized-to-bus yes
                    prompt {} {
                        {"Exit the classroom" yes ::Inverse::School::north}
                    }
                }
            }
        }
    }

}
