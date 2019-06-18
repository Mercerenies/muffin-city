
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
        set atheena [expr {[state get merchant-atheena] ne {no}}]
        set starlight [expr {([state get merchant-starlight] ne {no}) &&
                             ([state get false-stage] eq {no})}]
        if {![inv has {Self-Destruct Chip}]} then {
            return noChip
        } elseif {!$atheena && !$starlight} then {
            return chip
        } elseif {$atheena && !$starlight} then {
            return atheena
        } elseif {!$atheena && $starlight} then {
            return starlight
        } elseif {$atheena && $starlight} then {
            return teamwork
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

    proc chip {} {
        puts "Merchant-bot pauses for a moment."
        puts "\"BZZT! Scan complete. You have acquired the Self-Destruct Chip. BZZT!\""
        prompt {} {
            {"\"That's right!\"" yes chipBanter}
            {"\"And I'll defeat you with it!\"" yes chipBanter}
            {"Rush him" yes chipRush}
        }
    }

    proc chipBanter {} {
        puts "\"BZZT! Unlikely. Even if you recruit help, you will still never defeat\
        me. BZZT!\""
        puts "Merchant-bot looks directly at you and fires a laser from his eye,\
        vaporizing you instantly."
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door murder
        }
        puts {}
        return ::Underworld::Lobby::murder

    }

    proc chipRush {} {
        puts "You rush in with the Self-Destruct Chip in hand. Merchant-bot fires a\
        laser out of his eye and vaporizes a patch of ground in front of you, causing\
        you to trip and fall."
        puts "\"BZZT! Unlikely. Even if you recruit help, you will still never defeat\
        me. BZZT!\""
        puts "Merchant-bot looks directly at you and fires another laser from his eye,\
        vaporizing you instantly."
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door murder
        }
        puts {}
        return ::Underworld::Lobby::murder
    }

    proc atheena {} {
        puts "To your left, a blinding white light flashes. In the midst of the\
        light, Atheena appears, blade in hand."
        puts "\"BZZT! You brought a companion. It matters not. BZZT!\""
        puts "\"Your foul deeds go unchecked no longer, automaton!\""
        puts "Atheena tries to rush Merchant-bot, successfully blocking the\
        lasers emitted from his eye with her blade. In response, several slots\
        on Merchant-bot's body open, revealing numerous additional lasers.\
        Atheena leaps back and grabs you by the shoulder. The two of you\
        are quickly enveloped in a white light, and when the light clears, you\
        find yourselves in subspace again."
        puts "\"Alas, I cannot shield us from all of his attacks at once. We\
        need more help. If you can enlist a spellcaster or sorcerer who could\
        immobilize the robot, we may have a better chance.\""
        puts {}
        return ::Subspace::Portal::portalRoom
    }

    proc starlight {} {
        puts "To your right, a cluster of silver sparkles emerges, and Silver Starlight\
        steps out of the cluster."
        puts "\"BZZT! You brought a companion. It matters not. BZZT!\""
        puts "\"Alright! Evil robot, let's do this!\""
        puts "Merchant-bot's body opens up, revealing an array of lasers, which he fires\
        in your direction. Starlight points her scepter at Merchant-bot and utters\
        an incantation. Merchant-bot slows down considerably but does not stop firing\
        lasers."
        puts "\"Drat! Let's get out of here.\""
        puts "Another blast of silver sparkles launches from Starlight's scepter, and the two\
        of you disappear into it. When the silver clears, you find yourselves at the\
        shed in the forest."
        puts "\"I can't stop him. We need some more help. Do you know someone who\
        can hit hard and fast? Maybe a swordsman or something. That's what we need.\""
        puts {}
        return ::Prison::Cottage::shed
    }

    proc teamwork {} {
        puts "To your left, a blinding white light appears, out of which Atheena steps.\
        To your right, a burst of silver sparkles scatters, and Silver Starlight emerges."
        puts "\"BZZT! It matters not how many allies you accumulate. The end will be\
        the same. BZZT!\""
        puts "\"Your days are numbered, automaton!\""
        puts "\"Yeah! What she said! Let's get him!\""
        puts "Merchant-bot's body opens up, revealing numerous lasers. He begins wildly\
        firing at all three of you. Starlight utters an incantation, which slows Merchant-bot's\
        movement considerably. With the robot slowed, Atheena leaps into action, blocking\
        the remaining lasers with her sword and leaving an opening for you."
        prompt {} {
            {"Rush him and insert the Self-Destruct Chip" yes teamwork1}
        }
    }

    proc teamwork1 {} {
        puts "You rush the now defenseless robot and force the Self-Destruct Chip into a\
        slot on his front. As soon as the chip is inserted, Merchant-bot's attacks cease,\
        and he collapses onto the floor."
        puts "\"BZZT! The end... will be... BZZT! You are not... a threat...\
        BZZT! You... cannot... afford... a Green Olive...\""
        puts "Merchant-bot stops moving, and his single large eye drops off his body\
        and onto the floor."
        puts "\"Alright! We did it! Great teamwork!\""
        puts "\"Well done. Both of you. It was a pleasure working with you.\""
        puts "Atheena disappears in a flash of white light."
        puts "\"Oh, right! I should be getting back too. See you in the forest! Oh,\
        and you might wanna grab that eyeball thingy. It could come in handy.\""
        puts "Starlight disappears in a flash of silver sparkles, leaving you alone."
        puts "You got Merchant-bot's Eye!"
        inv remove {Self-Destruct Chip}
        inv add {Merchant-bot's Eye}
        state put merchant-war yes
        state put merchant-fought defeated
        # //// So the eye can be used to open a room in the warehouse.
        # There's another room in the warehouse that can only be
        # accessed by the full portal diamond.
        puts {}
        return ::Warehouse::Outside::south
    }

}
