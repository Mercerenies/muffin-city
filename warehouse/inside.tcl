
namespace eval Warehouse::Inside {

    proc warehouseFloor {} {
        puts "== Warehouse Floor =="
        if {[state get merchant-war] eq {warehouse}} then {
            state put merchant-war unlocked
        }
        puts "The inside of the warehouse is fairly expansive. There\
        are shelves scattered throughout filled with various objects.\
        In the back corner, there is a pile of crates conspicuously\
        stacked upon one another."
        prompt {} {
            {"Check behind the crates" yes crates}
            {"Go outside" yes exitWarehouse}
        }
    }

    proc crates {} {
        puts "== Warehouse Floor - Crates =="
        if {[state get merchant-war] eq {unlocked}} then {
            puts "There is a small space behind the crates. A\
            scribbled note is hastily taped to the wall, hidden\
            carefully behind the crates."
        } else {
            puts "There is a small space behind the crates, but it\
            is seemingly empty."
        }
        prompt {} {
            {"Read the note" {[state get merchant-war] eq {unlocked}} cratesNote}
            {"Go back" yes warehouseFloor}
        }
    }

    proc exitWarehouse {} {
        # //// If the door is bolted the second time, going out this
        # way opens it
        return ::Warehouse::Outside::south
    }

    proc cratesNote {} {
        puts "Upon closer inspection, the note seems to be a gibberish string of\
        letters and numbers, likely an encrypted message."
        prompt {} {
            {"Take the note" yes cratesNote1}
            {"Never mind" yes crates}
        }
    }

    proc cratesNote1 {} {
        puts "You got the Cryptic Note!"
        inv add {Cryptic Note}
        state put merchant-war crypto
        puts {}
        return crates
    }

}
