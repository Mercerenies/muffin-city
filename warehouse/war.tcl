
namespace eval Warehouse::War {

    proc start {} {
        puts {}
        puts "The large warehouse doors suddenly swing open, and Merchant-bot hovers out\
        of them, electricity pulsing all around him."
        if {[state get merchant-fought] eq {no}} then {
            puts "\"BZZT! You have been searching for my demise. But now\
            you will find your own demise. BZZT!\""
            state put merchant-fought fought
            prompt {} {
                {"\"So you're the sociopath I've been looking for?\"" yes sociopath}
                {"\"You want to fight?\"" yes sociopath}
            }
        } else {
            puts "\"BZZT! It does not matter how many times we fight. You\
            will not prevail. BZZT!\""
            prompt {} {
                {"\"Let's do this!\"" yes sociopath}
            }
        }
    }

    proc sociopath {} {
        puts "\"BZZT! I do not know how you discovered my secrets, but they will die\
        with you. BZZT!\""
        return battle
    }

    proc battle {} {
        # This is a big one. Lots of different things can happen based
        # on whom you've enlisted for help.
        if {![inv has {Self-Destruct Chip}]} then {
            return noChip
        } elseif {([state get merchant-atheena] eq {no}) &&
                  ([state get merchant-starlight] eq {no})} then {
            # /////
            return -gameover
        } elseif {([state get merchant-atheena] eq {yes}) &&
                  ([state get merchant-starlight] eq {no})} then {
            # ////
            return -gameover
        } elseif {([state get merchant-atheena] eq {no}) &&
                  ([state get merchant-starlight] eq {yes})} then {
            # ////
            return -gameover
        } elseif {([state get merchant-atheena] eq {yes}) &&
                  ([state get merchant-starlight] eq {yes})} then {
            # ////
            return -gameover
        } else {
            # Shouldn't happen, but meh.
            return noChip
        }
    }

    proc noChip {} {
        prompt {} {
            {"Rush him" yes noChipRush}
            {"Throw a rock at him" yes noChipRock}
            {"Wait for him to make the first move" yes noChipMove}
            {"Run away" yes noChipRun}
        }
    }

    proc noChipRush {} {
        puts "You rush Merchant-bot and slam your shoulder into his body. The robot\
        barely moves."
        puts "\"BZZT! Scan complete. You do not have the Self-Destruct Chip on your\
        person. Threat level: zero. BZZT!\""
        puts "A slot in Merchant-bot's chest opens, and a knife is thrust forward from it,\
        instantly killing you."
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door murder
        }
        puts {}
        return ::Underworld::Lobby::murder
    }

    proc noChipRock {} {
        puts "You reach down and grab a rock out of the ground, tossing it at Merchant-bot\
        with all your might. A precise laser blasts from Merchant-bot's eye, disintegrating\
        the rock."
        puts "\"BZZT! Scan complete. You do not have the Self-Destruct Chip on your\
        person. Threat level: zero. BZZT!\""
        puts "Merchant-bot looks directly at you and fires another laser, vaporizing you\
        instantly."
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door murder
        }
        puts {}
        return ::Underworld::Lobby::murder
    }

    proc noChipMove {} {
        puts "Merchant-bot remains still for a moment, before speaking again."
        puts "\"BZZT! Scan complete. You do not have the Self-Destruct Chip on your\
        person. Threat level: zero. BZZT!\""
        puts "Merchant-bot looks directly at you and fires a laser out of his eye,\
        vaporizing you instantly."
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door murder
        }
        puts {}
        return ::Underworld::Lobby::murder
    }

    proc noChipRun {} {
        puts "You run in the opposite direction. Merchant-bot makes no immediate move to follow."
        puts "\"BZZT! Scan complete. You do not have the Self-Destruct Chip on your\
        person. Threat level: zero. BZZT!\""
        puts "Merchant-bot looks directly at you and fires a laser out of his eye,\
        vaporizing you instantly."
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door murder
        }
        puts {}
        return ::Underworld::Lobby::murder
    }

}
