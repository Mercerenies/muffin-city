
namespace eval Warehouse::Undersea {

    proc undersea {} {
        puts "== Undersea =="
        puts "Underneath the sea, there is nothing but blue sea as far as the\
        eye can see. Several small fish and other creatures swim around, not\
        paying you very much mind."
        # //// Shark attack
        prompt {} {
            {"Swim up" yes surface}
            {"Swim down" yes kingdomGates}
        }
    }

    proc kingdomGates {} {
        puts "== Undersea Kingdom Gates =="
        puts "You find yourself outside a magnificent undersea kingdom. The gate to\
        the kingdom is wide open, and a young mermaid floats beside the gate."
        # ////
        prompt {} {
            {"Enter the kingdom" yes kingdom}
            {"Swim toward the surface" yes undersea}
            {"Talk to the mermaid" yes gatekeeper}
        }
    }

    proc gatekeeper {} {
        puts "\"I watch the gate to make sure nothing dangerous gets in. But\
        you seem relatively harmless, so enjoy your stay!\""
        prompt {} {
            {"\"What sort of things do you guard against?\"" yes gatekeeperGuard}
            {"\"Thank you.\"" yes kingdomGates}
        }
    }

    proc gatekeeperGuard {} {
        puts "\"Mostly wildlife. Sharks and other things that would find our kind\
        delicious. We don't get a lot of humans down here, so you can enter.\""
        puts {}
        return kingdomGates
    }

    proc kingdom {} {
        puts "== Undersea Kingdom =="
        puts "The kingdom itself is a shimmering collection of huts and a single castle\
        in the background. Nobody is out and about right now, aside from the one mermaid\
        outside the gate."
        prompt {} {
            {"Exit the kingdom" yes kingdomGates}
            {"Enter the red hut" yes red}
            {"Enter the yellow hut" yes yellow}
            {"Enter the blue hut" yes blue}
            {"Enter the castle" yes castleLocked}
        }
    }

    proc red {} {
        puts "== Undersea Kingdom - Red Hut =="
        # ////
        prompt {} {
            {"Go back outside" yes kingdom}
        }
    }

    proc yellow {} {
        puts "== Undersea Kingdom - Yellow Hut =="
        # ////
        prompt {} {
            {"Go back outside" yes kingdom}
        }
    }

    proc blue {} {
        puts "== Undersea Kingdom - Blue Hut =="
        # ////
        prompt {} {
            {"Go back outside" yes kingdom}
        }
    }

    proc castleLocked {} {
        puts "The front gates to the castle and all of the windows are locked."
        puts {}
        return kingdom
    }

    proc surface {} {
        puts "You climb up out of the water and onto the dock."
        puts {}
        return ::Warehouse::Outside::dock
    }

}
