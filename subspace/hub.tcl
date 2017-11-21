
namespace eval Subspace::Hub {

    proc hub {} {
        puts "== Subspace Hub =="
        puts "The white void extends indefinitely in all directions. To the north, there is an\
        unnatural storm containing some sort of energy. To the east, there is an enclosed room\
        containing a projector and some other equipment. To the south, there is a taco shop\
        and a bank."
        prompt {} {
            {"Enter the taco shop" yes tacoShop}
            {"Enter the bank" yes bank}
            {"Head toward the storm" yes storm}
            {"Head to the projection room" yes portalRoom}
        }
    }

    proc tacoShop {} {
        puts "== Subspace Taco Shop =="
        puts "The pleasant aroma of tacos is a refreshing break from the emptiness of\
        the remainder of subspace."
        # ////
        prompt {} {
            {"Head back outside" yes hub}
        }
    }

    proc bank {} {
        puts "== Subspace Bank =="
        puts "The bank is very orderly, with neat rows of seats for waiting\
        customers."
        # ////
        prompt {} {
            {"Head back outside" yes hub}
        }
    }

    proc portalRoom {} {
        puts "== Subspace Projection Room =="
        puts "The projector sits in the middle of the room and appears to currently be\
        inactive."
        # ////
        prompt {} {
            {"Head back to the hub" yes hub}
        }
    }

    proc storm {} {
        puts "== Subspace Storm =="
        puts "The storm rages on in all directions. It would be very easy to get lost in an\
        area like this."
        prompt {} {
            {"Head north" yes hub}
            {"Head west" yes hub}
            {"Head south" yes hub}
            {"Head east" yes hub}
        }
    }

}
