
namespace eval Prison::Cottage {

    proc yard {} {
        puts "== Cottage Yard =="
        puts "A large yard gives way to a small, quaint one-story cottage. Beside the\
        cottage, there sits an old wooden shed."
        prompt {} {
            {"Enter the cottage" yes cottage}
            {"Enter the shed" yes shed}
            {"Head back into the forest" yes wander}
        }
    }

    proc cottage {} {
        puts "== Cottage =="
        puts "The inside of the cottage is equally quaint, with a relatively large\
        central living space. There is a sofa up against the wall and some stairs\
        leading to an underground area."
        # //// The family is here
        # //// Also, sleeping on the sofa
        prompt {} {
            {"Take a nap on the sofa" yes {::Dream::Transit::awaken ::Dream::Transit::thirdRoom}}
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

    proc wander {} {
        # //// Once you've cleared the evil spirits, perhaps this actually does take you back
        puts "You head back into the forest and travel in a straight line. Rather quickly,\
        you end up back at the cottage."
        puts {}
        return yard
    }

}
