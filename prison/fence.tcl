
namespace eval Prison::Fence {

    proc approach {} {
        puts "== Exercise Fields - Grass Patch =="
        puts -nonewline "There are no other prisoners on this side of the field. A small patch\
        of grass serves as a home for a handful of plants and flowers."
        switch [state get the-fence] {
            no {
                puts " Behind the plants, the metal prison fence transitions into\
                a very out-of-place white picket fence."
            }
            shovel {
                puts " The Fence stands motionless behind a strange metal base sitting\
                on the floor. There is a shovel leaning up against the Fence."
            }
            shovel1 {
                puts " The Fence stands motionless behind a strange metal base sitting\
                on the floor."
            }
            paperclip - paperclip1 - default {
                puts " The Fence stands motionless behind the plants."
            }
        }
        prompt {} {
            {"Climb over the fence" {[state get the-fence] eq {no}} climb}
            {"Talk to the Fence" {[state get the-fence] ne {no}} fence}
            {"Go back" yes ::Prison::Exercise::fields}
        }
    }

    proc climb {} {
        puts "You hop onto the fence and begin to climb, when the fence yelps in pain."
        puts "\"Hey! Get off me!\""
        prompt {} {
            {"\"You can talk?\"" yes climb1}
            {"Back away slowly" yes approach}
        }
    }

    proc climb1 {} {
        puts "\"Yeah, I can talk! And I have feelings too! Where do you get off just jumping\
        on a person like that?\""
        prompt {} {
            {"\"I'm sorry.\"" yes climbSorry}
            {"\"You don't look like a person.\"" yes climbLook}
        }
    }

    proc climbSorry {} {
        puts "\"That's alright. Common mistake. Anyway, let's start over. Hi, I'm\
        the Fence.\""
        prompt {} {
            {"\"Hi.... the Fence.\"" yes climbHi}
        }
    }

    proc climbLook {} {
        puts "\"And you don't look much like an inmate, but here we are! Anyway, why\
        don't we start over? Hi, I'm the Fence.\""
        prompt {} {
            {"\"Hi.... the Fence.\"" yes climbHi}
        }
    }

    proc climbHi {} {
        puts "\"Now that I think about it, you may actually be able to help me.\
        See, I've always had a sort of life dream. I want to be an engineer. But...\
        being a sentient fencepost makes that a bit difficult. If you could bring me\
        some supplies, I could build something cool. How does that sound?\""
        prompt {} {
            {"\"What supplies do you need?\"" yes climbHi1}
        }
    }

    proc climbHi1 {} {
        puts "\"Uhhhhhhh....... let's see, right now I could use a paperclip! Not a small\
        paperclip. I need one of the really big ones. If you can bring me a paperclip,\
        I'd really appreciate it!\""
        state put the-fence paperclip
        prompt {} {
            {"Offer the Brass Paperclip" {[inv has {Brass Paperclip}]} paperclip}
            {"\"Okay.\"" yes approach}
        }
    }

    proc fence {} {
        switch [state get the-fence] {
            no - paperclip {
                puts "\"Hiiii! I'm looking for a paperclip.\""
                prompt {} {
                    {"Offer the Brass Paperclip" {[inv has {Brass Paperclip}]} paperclip}
                    {"\"Okay.\"" yes approach}
                }
            }
            paperclip1 {
                puts "\"Thank you for the paperclip! I'll let you know if I\
                need anything else!\""
                prompt {} {
                    {"\"Alright.\"" yes approach}
                }
            }
            shovel {
                puts "\"Hmmmmmm.... I still haven't decided what I'm building yet.\
                But I don't think I'll need this Shovel. You can take it if you want!\""
                prompt {} {
                    {"Take the Shovel" yes shovel}
                    {"\"Maybe later.\"" yes approach}
                }
            }
            shovel1 {
                # ////
                prompt {} {
                    {"\"Okay.\"" yes approach}
                }
            }
        }
    }

    proc paperclip {} {
        puts "\"A Brass Paperclip?! This is perfect!\""
        puts "You forfeit the Brass Paperclip."
        inv remove {Brass Paperclip}
        state put the-fence paperclip1
        puts "\"I'll let you know what I need next! Thank you!\""
        puts {}
        return approach
    }

    proc shovel {} {
        puts "You got a Shovel!"
        inv add {Shovel}
        state put the-fence shovel1
        puts {}
        return approach
    }

}
