
namespace eval Prison::Cottage {

    proc yard {} {
        puts "== Cottage Yard =="
        puts -nonewline "A large yard gives way to a small, quaint one-story cottage.\
        Beside the cottage, there sits an old wooden shed."
        if {[state get cottage-spirit] in {no evil}} then {
            puts " A friendly-looking farmer is cleaning up the yard."
        } else {
            puts {}
        }
        prompt {} {
            {"Talk to the farmer" {[state get cottage-spirit] in {no evil}} farmer}
            {"Enter the cottage" yes cottage}
            {"Enter the shed" yes shed}
            {"Head back into the forest" yes wander}
        }
    }

    proc cottage {} {
        puts "== Cottage =="
        puts -nonewline "The inside of the cottage is equally quaint, with a\
        relatively large central living space. There is a sofa up against the wall,\
        a table over in the opposite corner, and some stairs leading to an underground\
        area."
        if {[state get cottage-spirit] in {no evil}} then {
            puts " A young woman is preparing a meal, while her son waits patiently\
            at the table."
        } else {
            puts {}
        }
        prompt {} {
            {"Take a nap on the sofa" yes {::Dream::Transit::awaken ::Dream::Transit::thirdRoom}}
            {"Talk to the woman" {[state get cottage-spirit] in {no evil}} wife}
            {"Talk to the child" {[state get cottage-spirit] in {no evil}} son}
            {"Go downstairs" yes downstairs}
            {"Go back outside" yes yard}
        }
    }

    proc shed {} {
        puts "== Cottage Shed =="
        puts "The shed is relatively small but open. There are tools on shelves against\
        all of the walls but the entire middle of the shed is open space."
        # //// The sorcerer character whom I haven't decided on a name for yet
        prompt {} {
            {"Go back outside" yes yard}
        }
    }

    proc downstairs {} {
        puts "== Cottage Cellar =="
        # //// The Hatman is going to be here.
        puts "The cellar is dimly lit and relatively small. There are some bottled\
        beverages on a rack against the back wall."
        prompt {} {
            {"Go upstairs" yes cottage}
        }
    }

    proc farmer {} {
        if {[state get cottage-spirit] eq {evil}} then {
            return farmerIdle
        }
        puts "\"Well, hello there, stranger. It's such a nice day out, isn't it?\""
        prompt {} {
            {"\"Yes, it is.\"" yes farmer1}
        }
    }

    proc farmer1 {} {
        puts "\"My family is inside. Feel free to say hi to them. I should be getting\
        back to work.\""
        state put cottage-spirit evil
        prompt {} {
            {"\"Have a good day.\"" yes yard}
        }
    }

    proc farmerIdle {} {
        puts "\"Hello there, stranger.\""
        puts {}
        return yard
    }

    proc wife {} {
        puts "\"Hello, stranger!\""
        puts {}
        return cottage
    }

    proc son {} {
        puts "\"Dinner will be ready soon.\""
        puts {}
        return cottage
    }

    proc wander {} {
        # //// Once you've cleared the evil spirits, perhaps this actually does take you back
        puts "You head back into the forest and travel in a straight line. Rather quickly,\
        you end up back at the cottage."
        puts {}
        return yard
    }

}
