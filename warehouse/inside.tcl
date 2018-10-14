
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
        puts "There is a small space behind the crates, but it\
        is seemingly empty."
        # //// This is where you'll get the self-destruct protocol
        # instructions
        prompt {} {
            {"Go back" yes warehouseFloor}
        }
    }

    proc exitWarehouse {} {
        # //// If the door is bolted the second time, going out this
        # way opens it
        return ::Warehouse::Outside::south
    }

}
