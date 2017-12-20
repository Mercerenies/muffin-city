
namespace eval Space::Satellite {

    proc elevatorRoom {} {
        puts "== Elevator Room =="
        # ////
        prompt {} {
            {"Go through the hatch" yes transportBay}
            {"Enter the elevator" yes {::Underworld::Elevator::lift ::Space::Satellite::elevatorRoom}}
        }
    }

    proc transportBay {} {
        puts "== Transport Bay =="
        # ////
        prompt {} {
            {"Go through the hatch" yes elevatorRoom}
        }
    }

}
