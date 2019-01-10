
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
        puts "== Arcade Basement =="
        puts -nonewline "Silver Starlight is already at the shrine, standing opposite\
        a shadow which has taken the form of one of the dancers on the stage."
        set engaged [list]
        set linking "is"
        if {[state get spirit-bald]} then {
            lappend engaged "the bald man from the auditorium"
        }
        if {[state get spirit-lizard]} then {
            lappend engaged "the lizard man from the theater"
        }
        if {[state get spirit-gamer]} then {
            lappend engaged "the gamer"
        }
        if {[state get spirit-baker]} then {
            lappend engaged "the baker"
        }
        if {[llength $engaged] > 0} then {
            set engaged [lreplace $engaged 0 0 [string toupper [lindex $engaged 0] 0 0]]
        }
        if {[llength $engaged] > 1} then {
            set index [expr {[llength $engaged] - 1}]
            set engaged [lreplace $engaged $index $index "and [lindex $engaged $index]"]
            set linking "are"
        }
        if {[llength $engaged] > 2} then {
            set text [join $engaged ", "]
        } else {
            set text [join $engaged " "]
        }
        if {[llength $engaged] > 0} then {
            puts " $text $linking standing behind the dancer, also now veiled behind shadows.\
            Silver Starlight speaks first."
        } else {
            puts " Several smaller shadows encircle the dancer. Silver Starlight speaks first."
        }
        if {[state get false-stage-ran] eq {yes}} then {
            puts "\"Welcome to the party! You're just in time to see me finish the job!\""
        } else {
            puts "\"Took you long enough. You're just in time to see me finish the job!\""
        }
        state put spirit-bald no
        state put spirit-lizard no
        state put spirit-gamer no
        state put spirit-baker no
        state put false-stage no
        state put false-stage-ran yes
        # //// Also, maybe some (cosmetic) thing if you have Atheena's blade, just for completeness?
        if {[llength $engaged] >= 4} then {
            # //// There will be a second case here if you have some specific item
            puts "The five shadow beings move together and begin to morph into one\
            large shadow monster, much taller than either you or Starlight. Silver\
            Starlight doesn't miss a beat, immediately beginning to chant a spell,\
            but her magic has little effect on the monster. The monster speaks with\
            a deep, distorted voice."
            puts "\"You stand no chance against us, mortals.\""
            puts "In one attack, the monster attacks both of you, and a white light engulfs\
            you. When the light clears, you find yourselves back in the small shed, the\
            portal on the back wall still open."
            return arcadeDownLoss
        } else {
            puts "Silver Starlight holds her scepter high and dispels all of the shadows\
            in one attack. As soon as she does so, a white light engulfs both of you. When\
            the light clears, you find yourself back in the shed with Starlight. The portal\
            is still open on the back wall."
            return arcadeDownEasy
        }
    }

    proc arcadeDownEasy {} {
        puts "\"That... didn't feel like it worked. I don't think all of the spirits were\
        there. I think we need to make sure all of the spirits are down in that shrine\
        before we fight them. If you're ready to go back through and try again, just let\
        me know.\""
        prompt {} {
            {"\"Okay.\"" yes ::Prison::Cottage::shed}
        }
    }

    proc arcadeDownLoss {} {
        # //// Once we've decided which item is going to result in a victory, Starlight will
        # give a hint about it, at least telling us what to look for
        puts "\"That... didn't work out. I guess we just need a bit more power, but at least\
        we managed to gather all of the spirits in one place. Let me know if you want to go\
        back and try again.\""
        prompt {} {
            {"\"Okay.\"" yes ::Prison::Cottage::shed}
        }
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
