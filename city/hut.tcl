
namespace eval ::City::Hut {

    # //// By the way, need to do all of this in the past soon.

    proc locked {} {
        puts "== Mysterious Hut =="
        puts "The only door to the hut is locked by an electronic lock with\
        a keypad."
        prompt {} {
            {"Guess a random password" yes lockedFail}
            {"Go back" yes ::City::District::police}
        }
    }

    proc lockedFail {} {
        puts "You guess a random password. The keypad flashes a red color briefly,\
        and the door does not unlock."
        prompt {} {
            {"Guess another" yes lockedFail1}
            {"Go back" yes ::City::District::police}
        }
    }

    proc lockedFail1 {} {
        puts "You guess another random password. The keypad flashes red again,\
        but the door does not unlock."
        prompt {} {
            {"Go back" yes ::City::District::police}
        }
    }

    proc rubble {} {
        puts "== Mysterious Hut Wreckage =="
        puts "The entire hut has been destroyed, leaving only ash and blackened remnants\
        of what used to be the outer walls. In the center of the wreckage, there is a\
        trapdoor in the floor that seems to have survived the destruction."
        prompt {} {
            {"Enter the basement area" yes basement}
            {"Go back outside" yes ::City::District::police}
        }
    }

    proc basement {} {
        puts "== Mysterious Hut Basement =="
        puts "The basement is in shambles. Someone clearly left the area in a\
        hurry. All of the tables are turned over, and half of the lightbulbs\
        hanging from the ceiling have been shattered. Of particular interest is\
        an old refrigerator sitting in the corner of the room."
        prompt {} {
            {"Open the refrigerator" yes fridge}
            {"Go back up" yes rubble}
        }
    }

    proc fridge {} {
        if {[state get baby-doll] eq {no}} then {
            puts "Inside the fridge is some moldy bread. But of more interest is a\
            baby doll that seems to have been stuffed into the fridge."
            prompt {} {
                {"Take the baby doll" yes doll}
                {"Close the fridge" yes basement}
            }
        } else {
            puts "You open the refrigerator and find nothing of interest, aside from\
            moldy bread."
            puts {}
            return basement
        }
    }

    proc doll {} {
        puts "You got the Baby Doll!"
        puts "\"Heeheehee! You caught me! Bet you can't catch me again!\""
        puts "The baby doll leaps out of your hands and runs out of the basement."
        state put baby-doll running
        puts {}
        return basement
    }

}
