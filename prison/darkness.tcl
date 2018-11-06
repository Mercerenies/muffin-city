
namespace eval Prison::Darkness {

    proc theater {} {
        puts "== Theater =="
        puts "The entire theater is empty and dark. Even the lights which once illuminated\
        the stage have been deactivated."
        prompt {} {
            {"Go outside" yes center}
        }
    }

    proc theaterBack {} {
        puts "== Behind the Theater =="
        puts "The area behind the theater is desolate and gloomy, with an employee entrance\
        and not much else."
        prompt {} {
            {"Enter the theater" yes locked}
            {"Go back to the square" yes center}
        }
    }

    proc locked {} {
        puts "The back entrance to the theater is locked."
        puts {}
        return theaterBack
    }

    proc center {} {
        puts "== Pastel Town Square =="
        puts "In total contrast to earlier, the town square is completely dark. None of\
        the buildings are lit, and it is relatively difficult to see. All of the bright\
        pastels of earlier are gone, replaced with gloomy grays and blacks. The path\
        continues to the north and south, with a theater to the left."
        prompt {} {
            {"Enter the theater" yes enterTheater}
            {"Go behind the theater" yes theaterBack}
            {"Go north" yes north}
            {"Go south" yes south}
        }
    }

    proc north {} {
        puts "== Pastel Town - North Edge =="
        puts "The north edge of the town is equally dark and empty. Of particular interest\
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
        puts "The south edge of the town is dark and empty as well. There is a bakery\
        on the left side of the path. Further south, the air appears to become oddly\
        pixelated."
        prompt {} {
            {"Enter the bakery" yes bakery}
            {"Go north" yes center}
            {"Go further south" yes fadeOut}
        }
    }

    proc arcade {} {
        puts "== Pastel Town - Arcade =="
        puts "There is no one in the arcade, and all of the machines are disabled.\
        A staircase against the left wall leads downward."
        prompt {} {
            {"Go downstairs" yes arcadeDown}
            {"Go outside" yes north}
        }
    }

    proc arcadeDown {} {
        # //// The "final battle" here (consisting of all the engaged NPCs),
        # then resetting the conditions back to the beginning.
        return -gameover
    }

    proc bakery {} {
        puts "== Pastel Town - Bakery =="
        if {([state get spirit-muffin] eq {no}) && ([state get spirit-baker] eq {yes})} then {
            puts "The inside of the bakery is dark and empty. All of the tables are unoccupied.\
            A display case containing a muffin sits on the counter."
        } else {
            puts "The inside of the bakery is dark and empty. All of the tables are unoccupied."
        }
        prompt {} {
            {"Take the muffin" {([state get spirit-muffin] eq {no}) && ([state get spirit-baker] eq {yes})} bakeryMuffin}
            {"Go outside" yes south}
        }
    }

    proc bakeryMuffin {} {
        state put spirit-muffin yes
        muffin add {Apple Pecan Muffin}
        puts "You got the Apple Pecan Muffin!"
        puts {}
        return bakery
    }

    proc fadeOut {} {
        puts "A bright light engulfs you."
        puts {}
        return ::Prison::Cottage::shed
    }

}
