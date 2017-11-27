
namespace eval Dream::World {

    proc suitcase {} {
        puts "== Stolen Suitcase =="
        puts "You are no longer moving, and you do not hear anyone nearby."
        prompt {} {
            {"Exit the suitcase" yes unclaimed}
        }
    }

    proc unclaimed {} {
        puts "== Unclaimed Luggage Center =="
        puts "You find yourself in a large, circular room. The walls are an odd mixture of\
        colors that you can't quite name, and it seems as though the color scheme shifts as\
        the focus of your eyes changes. There is a sign overhead that reads \"Magical Deluge\
        Gun\", or something like it; you can't quite focus on the sign very well. There are\
        other suitcases and boxes here. A staircase leads up and out of the area."
        # /////
        prompt {} {
            {"Go up the stairs" yes commons}
        }
    }

    proc commons {} {
        puts "== Floating Commons =="
        puts "You are on a central platform with several modes of transportation surrounding\
        it. The area, and especially the horizon, is odd, and your eyes can't properly focus\
        on any single object. There appears to be a train station to the left, a pier to the\
        right, and an airport straight ahead. A set of stairs leads down into an underground\
        room. The platform seems to be suspended in midair, held above an empty void by nothing."
        prompt {} {
            {"Go to the station" yes station}
            {"Go to the pier" yes pier}
            {"Go to the airport" yes airport}
            {"Go downstairs" yes unclaimed}
        }
    }

    proc station {} {
        puts "== Train Station =="
        puts "The train station is slightly elevated from the remainder of the commons. A\
        conductor is standing by the train, which is sitting stationary on the tracks."
        prompt {} {
            {"Talk to the conductor" yes conductor}
            {"Board the train" yes third}
            {"Go back to the commons" yes commons}
        }
    }

    proc pier {} {
        puts "== Floating Pier =="
        # ////
        prompt {} {
            {"Go back to the commons" yes commons}
        }
    }

    proc airport {} {
        puts "== Airport =="
        # ////
        prompt {} {
            {"Go back to the commons" yes commons}
        }
    }

    proc conductor {} {
        puts "\"Good evening. Feel free to step aboard the train whenever you are ready\
        to depart.\""
        prompt {} {
            {"\"Thank you.\"" yes station}
        }
    }

    proc third {} {
        puts "== 3rd Class Car =="
        puts "The car is completely abandoned and the lights appear to be off. The door exiting\
        the train is open."
        prompt {} {
            {"Go backward one car" yes {::Dream::Destination::locked ::Dream::World::third}}
            {"Go forward one car" yes {::Dream::Destination::locked ::Dream::World::third}}
            {"Enter the room" yes thirdRoom}
            {"Get off the train" yes station}
        }
    }

    proc thirdRoom {} {
        puts "== 3rd Class Room =="
        puts "The room is deserted, and the lights are off."
        prompt {} {
            {"Go to sleep" yes {::Dream::Transit::sleep ::Dream::Destination::thirdRoom}}
            {"Exit the room" yes third}
        }
    }

}
