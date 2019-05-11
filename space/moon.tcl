
namespace eval Space::Moon {

    proc noOxygen {} {
        puts "You are out of oxygen..."
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door other
        }
        puts {}
        return ::Underworld::Lobby::other
    }

    proc humanBase {} {
        puts "== Moon Base =="
        puts "You are in a small pod containing only a teleporter. There is a\
        single exit to the pod."
        prompt {} {
            {"Exit the pod" yes {lightSide high}}
            {"Use the teleporter" yes teleporter}
        }
    }

    proc crashedTrain {} {
        puts "== 3rd Class Car =="
        puts "The lights are dimmed and red. The door exiting the train is open."
        prompt {} {
            {"Go backward one car" yes {::Dream::Destination::locked ::Space::Moon::crashedTrain}}
            {"Go forward one car" yes {::Dream::Destination::locked ::Space::Moon::crashedTrain}}
            {"Enter the room" yes {::Dream::Destination::locked ::Space::Moon::crashedTrain}}
            {"Get off the train" yes offTrain}
        }
    }

    proc crashing {} {
        puts -nonewline "You pull the emergency brake, and a loud screeching\
        noise alerts you to the fact that the train is slowing down. Suddenly,\
        the car begins to jerk to and fro, before crashing into a surface. You\
        fall toward one of the walls as the doors exiting the train open,\
        revealing a lunar landscape. It would seem that you crashed into\
        the moon."
        if {[state get city-thug] eq {hiding}} then {
            # //// The robber should drop something interesting in this case
            puts " The robber immediately leaps out the open door and runs off\
            into the distance."
            state put city-thug no
        } else {
            puts {}
        }
        puts {}
        state put moon-train yes
        return crashedTrain
    }

    proc offTrain {} {
        puts "You step off the train and onto the moon."
        puts {}
        return {crater high}
    }

    proc rocket {} {
        puts "== Crashed Rocket =="
        if {[inv has {Oxygen Pocket Dimension}]} then {
            puts "The rocket is not very spacious, but it serves its purpose well. There is\
            a small chair just large enough for one person. Several controls are situated in\
            front of the chair, but they all appear to have been damaged in the crash."
        } else {
            puts "The rocket is not very spacious, but it serves its purpose well. As soon\
            as the airlock closes, the room is filled with oxygen, and your Oxygen Tank\
            immediately refills. There is a small chair, just large enough for one person.\
            Several controls are situated in front of the chair, but they all appear to have\
            been damaged in the crash."
        }
        prompt {} {
            {"Go back outside" yes {rocks high}}
        }
    }

    proc teleporter {} {
        if {[state get moon-teleport] eq {yes}} then {
            puts "You step inside the teleportation device. A white light engulfs you,\
            and when the light clears, you are in a different location."
            puts {}
            return ::Space::Satellite::transportBay
        } else {
            puts "The teleporter appears to be inactive at the moment."
            puts {}
            return humanBase
        }
    }

    proc lightSide {oxygen} {
        if {[inv has {Oxygen Pocket Dimension}]} then {
            set oxygen high
        }
        if {![inv has {Oxygen Tank}] && ![inv has {Oxygen Pocket Dimension}]} then {
            return noOxygen
        }
        if {$oxygen eq {none}} then {
            return noOxygen
        }
        puts "== Moon - Light Side =="
        puts "The dust creates a thin, misty layer across the rough ground as you\
        walk. The small pod containing the teleporter is just behind you. In one\
        direction, the surface of the moon gets darker."
        switch $oxygen {
            high {
                prompt {} {
                    {"Head toward the dark side" yes {crater low}}
                    {"Head into the pod" yes humanBase}
                }
            }
            low {
                puts "... You are running low on oxygen."
                prompt {} {
                    {"Head toward the dark side" yes {crater none}}
                    {"Head into the pod" yes humanBase}
                }
            }
        }
    }

    proc crater {oxygen} {
        if {[inv has {Oxygen Pocket Dimension}]} then {
            set oxygen high
        }
        if {![inv has {Oxygen Tank}] && ![inv has {Oxygen Pocket Dimension}]} then {
            return noOxygen
        }
        if {$oxygen eq {none}} then {
            return noOxygen
        }
        puts "== Moon Crater =="
        if {[state get moon-train] eq {yes}} then {
            puts "A large crater stands before you. You cannot see the bottom.\
            There is a large train crashed into the surface of the moon next to the\
            crater."
        } else {
            puts "A large crater stands before you. You cannot see the bottom."
        }
        # //// Option to head into the crater
        switch $oxygen {
            high {
                prompt {} {
                    {"Head toward the dark side" yes {rocks low}}
                    {"Head toward the light side" yes {lightSide low}}
                    {"Enter the train" {[state get moon-train] eq {yes}} crashedTrain}
                }
            }
            low {
                puts "... You are running low on oxygen."
                prompt {} {
                    {"Head toward the dark side" yes {rocks none}}
                    {"Head toward the light side" yes {lightSide none}}
                    {"Enter the train" {[state get moon-train] eq {yes}} crashedTrain}
                }
            }
        }
    }

    proc rocks {oxygen} {
        if {[inv has {Oxygen Pocket Dimension}]} then {
            set oxygen high
        }
        if {![inv has {Oxygen Tank}] && ![inv has {Oxygen Pocket Dimension}]} then {
            return noOxygen
        }
        if {$oxygen eq {none}} then {
            return noOxygen
        }
        puts "== Moon Rocks =="
        if {[state get rocket-launched] eq {yes}} then {
            puts "The terrain becomes rockier in this direction. Off to one\
            side, a large rocket has crashed."
        } else {
            puts "The terrain becomes rockier in this direction. You have to be\
            careful where you step."
        }
        switch $oxygen {
            high {
                prompt {} {
                    {"Head toward the dark side" yes {darkSide low}}
                    {"Head toward the light side" yes {crater low}}
                    {"Enter the rocket" {[state get rocket-launched] eq {yes}} rocket}
                }
            }
            low {
                puts "... You are running low on oxygen."
                prompt {} {
                    {"Head toward the dark side" yes {darkSide none}}
                    {"Head toward the light side" yes {crater none}}
                    {"Enter the rocket" {[state get rocket-launched] eq {yes}} rocket}
                }
            }
        }
    }

    proc darkSide {oxygen} {
        if {[inv has {Oxygen Pocket Dimension}]} then {
            set oxygen high
        }
        if {![inv has {Oxygen Tank}] && ![inv has {Oxygen Pocket Dimension}]} then {
            return noOxygen
        }
        if {$oxygen eq {none}} then {
            return noOxygen
        }
        puts "== Moon - Dark Side =="
        puts "You can see little on the dark side of the moon. There seems to be some\
        sort of fortress up ahead, and a rocky, lighter area behind you."
        switch $oxygen {
            high {
                prompt {} {
                    {"Head toward the light side" yes {rocks low}}
                }
            }
            low {
                puts "... You are running low on oxygen."
                prompt {} {
                    {"Head toward the light side" yes {rocks none}}
                }
            }
        }
    }

    # //// The rest of the moon

}
