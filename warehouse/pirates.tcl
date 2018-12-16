
namespace eval Warehouse::Pirates {

    proc attack {} {
        if {[state get pirate-attack] eq {ready}} then {
            state put pirate-attack attacked
        }
        puts "In the open sea, the captain notices a ship approaching at a rapid\
        speed, sailing under the Jolly Roger."
        puts "\"Pirates! I can't outrun 'em!\""
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

}
