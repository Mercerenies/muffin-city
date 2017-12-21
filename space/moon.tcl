
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
        puts "A large crater stands before you. You cannot see the bottom."
        # //// Option to head into the crater
        switch $oxygen {
            high {
                prompt {} {
                    {"Head toward the dark side" yes {rocks low}}
                    {"Head toward the light side" yes {lightSide low}}
                }
            }
            low {
                puts "... You are running low on oxygen."
                prompt {} {
                    {"Head toward the dark side" yes {rocks none}}
                    {"Head toward the light side" yes {lightSide none}}
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
        puts "The terrain becomes rockier in this direction. You have to be\
        careful where you step."
        switch $oxygen {
            high {
                prompt {} {
                    {"Head toward the dark side" yes {darkSide low}}
                    {"Head toward the light side" yes {crater low}}
                }
            }
            low {
                puts "... You are running low on oxygen."
                prompt {} {
                    {"Head toward the dark side" yes {darkSide none}}
                    {"Head toward the light side" yes {crater none}}
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

    # ///// The rest of the moon

}
