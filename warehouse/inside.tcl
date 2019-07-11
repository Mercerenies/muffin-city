
namespace eval Warehouse::Inside {

    proc warehouseFloor {} {
        puts "== Warehouse Floor =="
        if {[state get merchant-war] eq {warehouse}} then {
            state put merchant-war unlocked
        }
        puts "The inside of the warehouse is fairly expansive. There\
        are shelves scattered throughout filled with various objects.\
        In the back corner, there is a pile of crates conspicuously\
        stacked upon one another. To your right, there is a door labeled\
        \"Owner\", and to your left, there is a door labeled \"Manager\"."
        prompt {} {
            {"Check behind the crates" yes crates}
            {"Enter the owner's office" yes ownerDoor}
            {"Enter the manager's office" yes managerDoor}
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

    proc ownerDoor {} {
        if {[state get warehouse-owner] eq {yes}} then {
            return ownerOffice
        }
        puts "The door is locked. A retinal scanner is mounted to the wall next to\
        the door."
        prompt {} {
            {"Scan your eye" yes ownerWrongEye}
            {"Scan Merchant-bot's Eye" {[inv has {Merchant-bot's Eye}]} ownerRightEye}
            {"Go back" yes warehouseFloor}
        }
    }

    proc managerDoor {} {
        # //// Unlocks from the inside
        puts "The door seems to be bolted shut from the inside."
        puts {}
        return warehouseFloor
    }

    proc ownerWrongEye {} {
        puts "You scan your own eye. The display flashes red, and the door does not unlock."
        puts {}
        return warehouseFloor
    }

    proc ownerRightEye {} {
        puts "You place Merchant-bot's Eye in front of the scanner. The display\
        briefly flashes green, and the door clicks open."
        state put warehouse-owner yes
        prompt {} {
            {"Enter the office" yes ownerOffice}
        }
    }

    proc ownerOffice {} {
        puts "== Warehouse - Owner's Office =="
        puts "Compared to the rest of the warehouse, the office\
        looks surprisingly futuristic. There are several displays on the wall,\
        all of them powered down. Below the displays, there are several drawers,\
        which seem to have been unlocked when the door provided you access."
        prompt {} {
            {"Rummage through the drawers" yes ownerDrawers}
            {"Go back out" yes warehouseFloor}
        }
    }

    proc ownerDrawers {} {
        if {[state get owner-key] eq {no}} then {
            puts "You find little of interest in most of the drawers, mostly scribbled notes\
            and unreadable documents. However, you do find a key in one drawer."
            puts "You got the Spade Key!"
            state put owner-key yes
            inv add {Spade Key}
            puts {}
            return ownerOffice
        } else {
            puts "You find little of interest in the drawers, mostly scribbled notes\
            and unreadable documents."
            puts {}
            return ownerOffice
        }
    }

}
