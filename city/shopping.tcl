
namespace eval City::Shopping {

    proc pawnShop {} {
        puts "== Pawn Shop =="
        puts "The pawn shop has several knick-knacks that don't seem very useful to anybody. There is a\
        shady man standing over in the corner. Presumably, he runs the shop."
        prompt {} {
            {"Talk to him" yes pawnTalk}
            {"Go outside" yes ::City::District::shopping}
        }
    }

    proc pawnTalk {} {
        puts "\"Hey. You're not a cop, are ya? ... ... Nah, of course not. Listen, I do business with... special\
        goods here. I'll let you know if I end up with any goods you'd be interested in.\""
        prompt {} {
            {"\"Okay.\"" yes pawnShop}
        }
    }

}
