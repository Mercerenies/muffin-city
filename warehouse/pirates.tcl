
namespace eval Warehouse::Pirates {

    proc attack {} {
        if {[inv has {Pirate Hat}]} then {
            return disguise
        }
        if {[state get pirate-attack] eq {ready}} then {
            state put pirate-attack attacked
        }
        puts "In the open sea, the captain notices a ship approaching at a rapid\
        speed, sailing under the Jolly Roger."
        puts "\"Pirates! I can't outrun 'em!\""
        return attack1
    }

    proc attack1 {} {
        puts "The ship closes in, and several pirates leap over to your ship. One of\
        them grabs you and places his scimitar against your neck."
        # //// A few weapon-based alternatives here. None of them will
        # pan out, but they should be options.
        prompt {} {
            {"Kick the pirate" yes fightBack}
            {"\"I surrender.\"" yes surrender}
        }
    }

    proc fightBack {} {
        puts "You lift your leg, but before you can make a move, you feel the blade\
        slice your neck."
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door murder
        }
        puts {}
        return ::Underworld::Lobby::murder
    }

    proc surrender {} {
        puts "\"Good.\""
        puts "The pirate cuts your throat."
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door murder
        }
        puts {}
        return ::Underworld::Lobby::murder
    }

    proc disguise {} {
        puts "In the open sea, the pirate ship approaches rapidly. You don your Pirate\
        Hat, and as the ship closes in, the pirates notice your costume."
        prompt {} {
            {"\"Ahoy! This ship be mine!\"" yes disguiseSuccess}
            {"\"Uh... this ship is mine!\"" yes disguiseFail}
        }
    }

    proc disguiseSuccess {} {
        puts "\"Ahoy! We didn't there be pirates on this ship! We greet ye!\""
        puts "The pirate ship moves closer to your ship, but the crew makes\
        no move to attack."
        puts "\"Yer welcome to board our ship if ye like, matey.\""
        state put pirate-attack yes
        prompt {} {
            {"Board the ship" yes ship}
            {"\"Maybe later.\"" yes leave}
        }
    }

    proc disguiseFail {} {
        puts "\"Arrrr! They're not real pirates! They don't even speak like us, matey!\
        Get 'em!\""
        return attack1
    }

    proc leave {} {
        puts "The pirates allow you to leave in peace."
        puts {}
        puts "You arrive as planned on a deserted island."
        puts {}
        state put captain-boat-place warehouse
        return ::Warehouse::Outside::dock
    }

    proc leavePlane {} {
        puts "The pirates allow you to leave in peace."
        puts {}
        puts "You arrive as planned on an ethereal plane."
        puts {}
        state put captain-boat-place warehouse
        return ::Warehouse::Outside::dock
    }

    proc ship {} {
        # ////
        return -gameover
    }

}
