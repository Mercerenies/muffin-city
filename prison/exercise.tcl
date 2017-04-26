
namespace eval Prison::Exercise {

    proc fields {} {
        puts "== Exercise Fields =="
        puts "You are outside under the bright light of the sun. There are several prisoners moving\
        about, playing various sports. There is a basketball court on one side of the field and\
        a small grassy patch on the opposite side."
        if {![state get exercise-soul] && [inv has {Soul Crystal}]} then {
            puts "... Your Soul Crystal starts vibrating in your pocket."
        }
        prompt {} {
            {"Approach the prisoners" yes talking}
            {"Use the Soul Crystal" {![state get exercise-soul] && [inv has {Soul Crystal}]} stealing}
            {"Go back inside" yes ::Prison::North::hallway}
        }
    }

    proc talking {} {
        if {[state get exercise-soul]} then {
            puts "The leader of the group of inmates looks depressed and just walks away when you approach him.\
            The others follow him."
            puts {}
            return fields
        }
        puts "They don't seem too interested in you and simply proceed with their game as though\
        you aren't there."
        prompt {} {
            {"\"Hey, can I talk to you guys?\"" yes attention}
            {"\"Hey, stupid!\"" yes insult}
            {"Back off" yes fields}
        }
    }

    proc attention {} {
        puts "The prisoners continue ignoring you."
        prompt {} {
            {"\"Are you deaf? I'm talking, here, moron!\"" yes insult}
            {"Back off" yes fields}
        }
    }

    proc insult {} {
        puts "\"What did you just say to me? I'm going to give you one chance to take that back.\""
        prompt {} {
            {"\"Okay, I'm sorry.\"" yes backOff}
            {"\"What, are you scared?\"" yes fight}
        }
    }

    proc backOff {} {
        puts "\"That's better.\""
        puts {}
        return fields
    }

    proc fight {} {
        puts "\"That's it. You're going down!\""
        puts "The prisoner takes a small dagger from his boot and thrusts it into your chest."
        state put lobby-door murder
        puts {}
        return ::Underworld::Lobby::murder
    }

    proc stealing {} {
        puts "You activate your Soul Crystal, and a floating essence emerges from the leader of the gang\
        of thugs, not unlike the essences in Johnny Death's display case. You got the Inmate's Soul!"
        inv add {Inmate's Soul}
        state put exercise-soul yes
        puts {}
        return fields
    }

}
