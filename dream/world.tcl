
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
            {"Go up the stairs" yes ::Empty::place}
        }
    }

}
