
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
        puts "In the arcade, there are a handful of unfamiliar games. A teenager is standing\
        against the wall."
        prompt {} {
            {"Play a game" yes arcadeGame}
            {"Talk to the teenager" yes arcadeTalk}
            {"Go outside" yes north}
        }
    }

    proc arcadeGame {} {
        # //// You'll win this if it's time
        puts "You approach one of the games and begin to play. The display doesn't seem\
        to make a lot of sense, and you ultimately end up losing without really knowing\
        how to play."
        puts {}
        return arcade
    }

    proc arcadeTalk {} {
        puts "You attempt to strike up conversation with the teenager, who simply stands there\
        staring forward, not even acknowledging your presence."
        state put spirit-gamer yes
        puts {}
        return arcade
    }

    proc bakery {} {
        puts "== Pastel Town - Bakery =="
        switch [state get false-stage] {
            no - dance {
                if {[state get spirit-muffin] eq {no}} then {
                    puts "The inside of the bakery is incredibly colorful. There are several\
                    people sitting at the tables, seemingly enjoying a pleasant snack. The baker\
                    is standing behind the counter, and a muffin sits on a display case in front\
                    of him."
                } else {
                    puts "The inside of the bakery is incredibly colorful. There are several\
                    people sitting at the tables, seemingly enjoying a pleasant snack. The baker\
                    is standing behind an empty display case on the counter."
                }
            }
        }
        prompt {} {
            {"Talk to the baker" {[state get false-stage] in {no dance}} bakeryTalk}
            {"Take the muffin" {[state get spirit-muffin] eq {no}} bakeryMuffin}
            {"Go outside" yes south}
        }
    }

    proc bakeryMuffin {} {
        switch [state get false-stage] {
            no - dance {
                state put spirit-baker yes
                puts "The baker grabs your arm and lifts a butcher's knife with his other hand.\
                As he lowers the large knife toward you, a bright light engulfs you."
                puts {}
                return ::Prison::Cottage::shed
            }
        }
    }

    proc bakeryTalk {} {
        puts "The baker pays you no mind, no matter what you say to him. He merely\
        goes about his business."
        state put spirit-baker yes
        puts {}
        return bakery
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
