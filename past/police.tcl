
namespace eval Past::Police {

    proc station {} {
        puts "== Police Station - Past =="
        puts "There are several officers on duty, many wandering about and others sitting at\
        desks filing paperwork."
        prompt {} {
            {"Go back outside" yes ::Past::District::police}
            {"\"I killed a man!\"" yes stationConfess}
        }
    }

    proc stationConfess {} {
        puts "As soon as you open your mouth to confess, the entire room fades to white.\
        Everyone and everything around you disappears, and you find yourself in a strange\
        new location."
        puts {}
        state put subspace-reason arrest
        return ::Subspace::Hub::hub
    }

    proc courthouse {} {
        puts "== Courthouse Entrance - Past =="
        puts "The doors to the courthouse are wide open, inviting any and all who pass\
        by through its gates."
        prompt {} {
            {"Enter the courthouse" yes courthouseInside}
            {"Go back" yes ::Past::District::police}
        }
    }

    proc courthouseInside {} {
        puts "== Courthouse Foyer - Past =="
        puts -nonewline "The front room of the foyer is open and spacious. The crimson carpet\
        extends to a courtroom on the top floor. Down the hall, there are several offices\
        on either side. Two bailiffs stand on either side of the entrance."
        if {[state get courtroom-key] eq {no}} then {
            puts {}
        } else {
            puts " One of the windows is shattered."
        }
        prompt {} {
            {"Go upstairs" yes courtroom}
            {"Go down the hall" yes courthouseHall}
            {"Leave the courthouse" yes courthouse}
        }
    }

    proc courthouseHall {} {
        puts "The bailiffs stop you."
        puts "\"That area is restricted! You can't go back there.\""
        puts {}
        return courthouseInside
    }

    proc courtroom {} {
        puts "== Courtroom =="
        puts "The courtroom looks like any other, with a jury box on the right, several seats\
        in the back, and a bench for the judge at the front. There does not appear to be a trial\
        going on right now, as the area is deserted."
        if {[state get courtroom-key] eq {no}} then {
            puts "A young man runs out from the back room, obviously in a hurry. As he runs, he\
            tosses a key at you."
            puts "\"I gotta get outta here! Take dis and don't tell 'em you 'ave it!\""
            puts "The young man exits the courtroom and leaps out a nearby window."
            puts "You got a Courthouse Key!"
            state put courtroom-key has
            inv add {Courthouse Key}
        }
        prompt {} {
            {"Go back" yes courthouseInside}
        }
    }

}
