
namespace eval Underworld::Abyss {

    proc firstFloor {} {
        puts "== Abyss - First Floor =="
        puts "The lower floor of the platform is nearer the abyss itself.\
        You cannot see anything in the pitch-black abyss. On the lower\
        floor, there are thousands of disembodied souls wandering around,\
        seemingly with no objective in mind. A set of stairs leads back up\
        to the second floor."
        prompt {} {
            {"Go upstairs" yes secondFloor}
            {"Dive into the abyss" yes void}
        }
    }

    proc secondFloor {} {
        puts "== Abyss - Second Floor =="
        puts "A large circular platform overlooks a deep, possibly\
        bottomless pit. There is a set of stairs leading down toward\
        the pit. All around you, several hundred disembodied souls\
        wander blindly, seemingly unaware of your presence or of the\
        presence of any of the other souls. Behind you, a somewhat narrow\
        tunnel forks in two directions."
        # //// A third floor
        prompt {} {
            {"Head toward the tunnel" yes fork}
            {"Go downstairs" yes firstFloor}
        }
    }

    # //// A third floor, where the ruler is (he has the Necromancy
    # Certificate that fell from above)

    proc void {} {
        puts "== Abyss - The Void =="
        puts "The void is pitch black. You can see nothing in any direction. Even looking\
        up, you cannot see the platform from which you dove. You are suddenly feeling very\
        drowsy."
        # //// If you have a lantern, then you'll see something
        # (muffin?) down here
        prompt {} {
            {"Go forward" yes voidDirection}
            {"Go backward" yes voidDirection}
            {"Go to sleep" yes voidSleep}
        }
    }

    proc voidDirection {} {
        puts "You wander a bit, but you don't manage to get very far before dropping to the\
        ground and falling asleep."
        puts {}
        return {::Dream::Transit::awaken ::Dream::Transit::thirdRoom}
    }

    proc voidSleep {} {
        puts "You wander a bit, but you don't manage to get very far before dropping to the\
        ground and falling asleep."
        puts {}
        return {::Dream::Transit::awaken ::Dream::Transit::thirdRoom}
    }

    proc fork {} {
        puts "== Underworld Tunnel - Fork =="
        puts "The tunnel branches off in two directions. To the right, you can see\
        Dr. Cipher's lab and the elevator, but the tunnel is too narrow for you to\
        fit through. The path to the left continues for some time, and behind you is\
        the abyss."
        # //// To the left
        prompt {} {
            {"Go left" yes ::Empty::place}
            {"Approach the abyss" yes secondFloor}
        }
    }

}
