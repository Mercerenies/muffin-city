
namespace eval Prison::Forest {

    proc gate {} {
        puts "== Prison Gate - Outside =="
        if {[state get awaiting-bus] eq {yes}} then {
            puts "You are on the outside of the prison gate. There is a bus parked on the curb. The bus driver\
            is waving you down."
            puts "\"Oi! You're that prisoner who was just released, right? I'm here to take you back into town!\""
        } else {
            puts "You are on the outside of the prison gate. There is a single road running outside the prison,\
            and opposite it sits a large forest."
        }
        prompt {} {
            {"Go into the forest" yes trees}
            {"Board the bus" {[state get awaiting-bus] eq {yes}} bus}
        }
    }

    proc trees {} {
        puts "== Forest =="
        if {[state get awaiting-bus] eq {trees}} then {
            state put awaiting-bus yes
        }
        puts "The forest treeline is very thick, but a rough path seems to run across it, leaading to a river\
        on one side and a cave on the other."
        prompt {} {
            {"Go back to the prison" yes gate}
            {"Enter the cave" yes cave}
            {"Head toward the river" yes river}
        }
    }

    proc river {} {
        puts "== Forest River =="
        puts "A peaceful, flowing river cuts the forest into two parts. The water seems cold enough that\
        you wouldn't want to have to ford it."
        prompt {} {
            {"Reach a hand into the river" yes riverReach}
            {"Head into the forest" yes trees}
        }
    }

    proc riverReach {} {
        switch [state get forest-river] {
            0 {
                puts "You reach your hand into the freezing water and find a Silver Coin that someone\
                carelessly tossed in."
                puts "You got a Silver Coin."
                inv add {Silver Coin}
                state put forest-river 1
            }
            1 {
                puts "You reach into the freezing water and feel nothing of interest, save for a few\
                small pebbles."
                state put forest-river 2
            }
            2 {
                puts "You reach back into the freezing water and pull out a small box. Inside the small\
                box, you find a muffin."
                puts "You got the Maple Muffin!"
                muffin add {Maple Muffin}
                state put forest-river 3
            }
            default {
                puts "You reach your hand into the water once again but find nothing of interest, aside from\
                a few pebbles and some dirt."
            }
        }
        prompt {} {
            {"Reach in again" yes riverReach}
            {"Head into the forest" yes trees}
        }
    }

    proc cave {} {
        puts "== Cave =="
        # //// If you have lighting equipment, there is another option available here
        puts "The cave is pitch black, leaving you completely blind. You vaguely hear growling in the\
        distance."
        prompt {} {
            {"Press onward" yes ::Empty::place}
            {"Exit the cave" yes trees}
        }
    }

    proc bus {} {
        puts "You step on board the bus, and the driver starts the engine."
        puts "..."
        puts "A short while later, the bus stops in a familiar city."
        puts "\"This is your stop. Congratulations on your freedom!\""
        state put awaiting-bus no
        puts {}
        return ::City::District::entrance
    }

}
