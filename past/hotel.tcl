
namespace eval Past::Hotel {

    proc ritzyHall {} {
        puts "== Past Ritzy Inn - Hallway =="
        puts "The hallway stretches on for quite a ways, and there appear to be\
        several floors above this one."
        prompt {} {
            {"Go to Room 211" {[inv has {Ritzy Inn Room Key}]} ritzyRoom}
            {"Go to the basement" {[state get heard-science] eq {yes}} ::Past::Science::mainRoom}
            {"Go to the lobby" yes ritzyInn}
        }
    }

    proc ritzyRoom {} {
        puts "== Past Ritzy Inn - Bedroom =="
        puts "The key card to Room 211 opens the door. There is another party's luggage laying on\
        the floor of the room. Clearly, someone else has the room right now."
        # //// Something in the luggage to steal
        prompt {} {
            {"Go to sleep" yes ::Dream::Transit::firstRoom}
            {"Exit the room" yes ritzyHall}
        }
    }

    proc ritzyInn {} {
        puts "== Past Ritzy Inn =="
        puts "This is obviously a high-class building. There are several people moving to and fro,\
        all of them dressed in the finest garb. Behind a large \"Guest Services\" counter sits a\
        young man with glasses. The bronze nameplate in front of him informs you that his name\
        is Todd."
        prompt {} {
            {"Talk to Todd" yes ritzyTalk}
            {"Go toward the hallway" yes ritzyHall}
            {"Leave" yes ::Empty::place}
        }
    }

    proc ritzyTalk {} {
        puts "\"I'm terribly sorry, but we don't have any vacancies at the moment. Please\
        come back at one o'clock after today's guests have departed.\""
        prompt {} {
            {"\"Never mind.\"" yes ritzyInn}
        }
    }

}
