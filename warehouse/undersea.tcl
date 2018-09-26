
namespace eval Warehouse::Undersea {

    proc undersea {} {
        puts "== Undersea =="
        puts "Underneath the sea, there is nothing but blue sea as far as the\
        eye can see. Several small fish and other creatures swim around, not\
        paying you very much mind."
        prompt {} {
            {"Swim up" yes surface}
            {"Swim down" yes kingdomGates}
        }
    }

    proc kingdomGates {} {
        puts "== Kingdom Gates =="
        puts "You find yourself outside a magnificent undersea kingdom. The gate to\
        the kingdom is wide open, and a young mermaid floats beside the gate."
        # //// So sometimes (not sure what the criterion will be) a shark will follow the player here and the gatekeeper will close the gate for security reasons.
        # /////
        prompt {} {
            {"Enter the kingdom" yes ::Empty::place}
            {"Swim toward the surface" yes undersea}
            {"Talk to the mermaid" yes ::Empty::place}
        }
    }

    proc surface {} {
        puts "You climb up out of the water and onto the dock."
        puts {}
        return ::Warehouse::Outside::dock
    }

}
