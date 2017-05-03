
namespace eval Underworld::Pits {

    proc fire {} {
        # ///// There will be a way to get a fireproof suit which will allow you to go down here, where the
        #       freight elevator to the warehouse will be
        return -gameover
    }

    proc fireEntry {} {
        puts "You leap down into the pits of fire."
        return fire
    }

}
