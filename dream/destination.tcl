
namespace eval Dream::Destination {

    proc third {} {
        puts "== 3rd Class Car =="
        puts "The car is completely abandoned and the lights appear to be off. The door exiting the train is\
        open."
        prompt {} {
            {"Go backward one car" yes {locked third}}
            {"Go forward one car" yes {locked third}}
            {"Enter the room" yes thirdRoom}
            {"Get off the train" yes offTrain}
        }
    }

    proc second {} {
        puts "== 2nd Class Car =="
        puts "The car is completely abandoned and the lights appear to be off. The door exiting the train is\
        open."
        prompt {} {
            {"Go backward one car" yes {locked second}}
            {"Go forward one car" yes {locked second}}
            {"Enter the room" yes secondRoom}
            {"Get off the train" yes offTrain}
        }
    }

    proc first {} {
        puts "== 1st Class Car =="
        puts "The car is completely abandoned and the lights appear to be off. The door exiting the train is\
        open."
        prompt {} {
            {"Go backward one car" yes {locked first}}
            {"Go forward one car" yes {locked first}}
            {"Enter the room" yes firstRoom}
            {"Get off the train" yes offTrain}
        }
    }

    proc thirdRoom {} {
        puts "== 3rd Class Room =="
        puts "It seems that the train has stopped moving. You must have reached your destination."
        prompt {} {
            {"Exit the room" yes third}
        }
    }

    proc secondRoom {} {
        # //// Reward that is only accessible now?
        puts "== 2nd Class Room =="
        puts -nonewline "It seems that the train has stopped moving. You must have reached your destination."
        if {![state get muffin-second]} then {
            puts " There is a muffin sitting on the nightstand next to your bed."
        } else {
            puts {}
        }
        prompt {} {
            {"Take the muffin" {![state get muffin-second]} takeMuffin}
            {"Exit the room" yes second}
        }
    }

    proc firstRoom {} {
        # //// Hit the call button?
        puts "== 1st Class Room =="
        puts "It seems that the train has stopped moving. You must have reached your destination."
        prompt {} {
            {"Exit the room" yes first}
        }
    }

    proc locked {back} {
        puts "The door to the car appears to be locked right now."
        puts {}
        return $back
    }

    proc offTrain {} {
        puts "You step off the train and are greeted by a man who could easily be the caption of the dictionary\
        entry for \"train conductor\", complete with the hat and button-down suit."
        puts "\"Good evening. We sincerely hope you enjoyed your ride.\""
        puts "The conductor ushers you off the train, before stepping back in and signalling to the engineer\
        that it is time to go. The train sets off, leaving you alone."
        puts {}
        return ::City::District::entrance
    }

    proc takeMuffin {} {
        puts "You claim the muffin sitting on the nightstand."
        puts "You got the Blueberry Muffin!"
        state put muffin-second yes
        muffin add {Blueberry Muffin}
        puts {}
        return secondRoom
    }

}
