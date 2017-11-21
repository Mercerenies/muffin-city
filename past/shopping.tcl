
namespace eval Past::Shopping {

    proc pawnShopEntry {} {
        puts "The door to the pawn shop is locked."
        # //// Password to get in
        puts "\"Oi! We're closed right now!\""
        prompt {} {
            {"Kick down the door" yes pawnShopKick}
            {"\"Alright, I'll come back later.\"" yes ::Past::District::shopping}
        }
    }

    proc pawnShopKick {} {
        puts "You kick the door. It has little effect."
        prompt {} {
            {"Leave" yes ::Past::District::shopping}
        }
    }

}
