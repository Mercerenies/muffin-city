
namespace eval Warehouse::Inside {

    proc warehouseFloor {} {
        puts "== Warehouse Floor =="
        prompt {} {
            {"Check behind the crates" yes crates}
            {"Go outside" yes exitWarehouse}
        }
    }

    proc crates {} {
        puts "== Warehouse Floor - Crates =="
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
