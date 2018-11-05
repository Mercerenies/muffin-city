
namespace eval Prison::Pocket {

    proc theater {} {
        puts "== Theater =="
        puts "As you wander about, you see just how large the theater really is.\
        There is a balcony section above your head that you aren't sure how to get\
        to. The exits are in the back and appear to be unlocked."
        prompt {} {
            {"Sit down" yes theaterSeat}
            {"Go outside" yes center}
        }
    }

    proc theaterSeat {} {
        puts "== Theater House =="
        puts "The theater is very large, and it is clearly very packed. There is some\
        sort of dance show going on on the stage, and Silver Starlight seems to be a\
        participant, playing along for the moment. You are in an edge seat, so it would\
        be relatively easy to leave if you so chose. The man sitting next to you is bald\
        and rather intimidating."
        # //// Talking to the guy, and just going through with the show
        prompt {} {
            {"Enjoy the show" yes ::Empty::place}
            {"Talk to the bald man" yes ::Empty::place}
            {"Get up" yes theater}
        }
    }

    proc theaterBack {} {
        puts "== Behind the Theater =="
        # ////
        # //// Also, being able to enter from the back (sometimes)
        prompt {} {
            {"Go back to the square" yes center}
        }
    }

    proc center {} {
        puts "== Pastel Town Square =="
        puts "The town square is unnaturally bright, with the sun directly overhead and the\
        buildings consisting of unusual pastel colors. The path continues to the north and\
        the south, and the theater is right in the center of town."
        prompt {} {
            {"Enter the theater" yes enterTheater}
            {"Go behind the theater" yes theaterBack}
            {"Go north" yes north}
            {"Go south" yes south}
        }
    }

    proc north {} {
        puts "== Pastel Town - North Edge =="
        puts "The north edge of the town is equally pastel-shaded. Of particular interest\
        in the immediate area is an arcade. Further to the north, the air starts to look\
        more pixelated."
        prompt {} {
            {"Enter the arcade" yes arcade}
            {"Go further north" yes fadeOut}
            {"Go south" yes center}
        }
    }

    proc south {} {
        puts "== Pastel Town - South Edge =="
        puts "The south edge of the town is incredibly colorful, like the rest of the area.\
        There is a bakery on the left side of the path. Further south, the air appears to\
        become oddly pixelated."
        prompt {} {
            {"Enter the bakery" yes bakery}
            {"Go north" yes center}
            {"Go further south" yes fadeOut}
        }
    }

    proc arcade {} {
        puts "== Pastel Town - Arcade =="
        # ////
        prompt {} {
            {"Go outside" yes north}
        }
    }

    proc bakery {} {
        puts "== Pastel Town - Bakery =="
        # ////
        prompt {} {
            {"Go outside" yes south}
        }
    }

    proc fadeOut {} {
        puts "A bright light engulfs you."
        puts {}
        return ::Prison::Cottage::shed
    }

    proc enterTheater {} {
        # //// This will discriminate based on false-stage eventually
        return theater
    }

}
