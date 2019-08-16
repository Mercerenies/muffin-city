
namespace eval Dream::Destination {

    proc third {} {
        puts "== 3rd Class Car =="
        puts "The car is completely abandoned and the lights appear to be off. The door exiting\
        the train is open."
        prompt {} {
            {"Go backward one car" yes {locked third}}
            {"Go forward one car" yes {locked third}}
            {"Enter the room" yes thirdRoom}
            {"Get off the train" yes offTrain}
        }
    }

    proc second {} {
        puts "== 2nd Class Car =="
        puts "The car is completely abandoned and the lights appear to be off. The door exiting\
        the train is open."
        prompt {} {
            {"Go backward one car" yes {locked second}}
            {"Go forward one car" yes {locked second}}
            {"Enter the room" yes secondRoom}
            {"Get off the train" yes offTrain}
        }
    }

    proc first {} {
        puts "== 1st Class Car =="
        puts "The car is completely abandoned and the lights appear to be off. The door\
        exiting the train is open."
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
        puts "== 2nd Class Room =="
        puts -nonewline "It seems that the train has stopped moving. You must have reached\
        your destination."
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
        puts "You step off the train and are greeted by a man who could easily be the caption\
        of the dictionary entry for \"train conductor\", complete with the hat and button-down suit."
        if {[state get train-revisit] eq {no}} then {
            puts "\"Good evening. We sincerely hope you enjoyed your ride. Since this is your\
            first ride, we'd like to offer you this gift. We have a partnership with the Ritzy\
            Inn & Suites, so please enjoy this meal voucher on our behalf."
            puts "You got a Ritzy Inn Meal Voucher!"
            inv add {Ritzy Inn Meal Voucher}
            state put train-revisit yes
        } else {
            puts "\"Good evening. We sincerely hope you enjoyed your ride.\""
        }
        puts "The conductor ushers you off the train, before stepping back in and signaling to\
        the engineer that it is time to go. The train sets off, leaving you alone."
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
