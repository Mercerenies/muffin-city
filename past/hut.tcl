
namespace eval ::Past::Hut {

    proc locked {} {
        if {[state get hut-password] eq {yes}} then {
            return foyer
        }
        puts "== Mysterious Hut - Past =="
        puts "The door to the hut is locked by an electronic lock with\
        a keypad."
        prompt {} {
            {"Guess a random password" {[state get hut-password] eq {no}} lockedFail}
            {"Enter 6872" {[state get hut-password] eq {found}} foyer}
            {"Go back" yes ::Past::District::police}
        }
    }

    proc lockedFail {} {
        puts "You guess a random password. The keypad flashes a red color briefly,\
        and the door does not unlock."
        prompt {} {
            {"Guess another" yes lockedFail1}
            {"Go back" yes ::Past::District::police}
        }
    }

    proc lockedFail1 {} {
        puts "You guess another random password. The keypad flashes red again,\
        but the door does not unlock."
        prompt {} {
            {"Go back" yes ::Past::District::police}
        }
    }

    proc foyer {} {
        state put hut-password yes
        # ////
        return -gameover
    }

}
