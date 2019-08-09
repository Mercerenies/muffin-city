
namespace eval Empty {

    proc place {} {
        puts "You drift away from spacetime and everything that exists as you realize that\
        this branch has not been written yet. Everything falls apart around you."
        return -gameover
    }

    proc back {room} {
        puts "You briefly drift out of spacetime as you realize that this part of the game has\
        not been designed yet. Fortunately, the effects subside quickly."
        puts {}
        return $room
    }

}
