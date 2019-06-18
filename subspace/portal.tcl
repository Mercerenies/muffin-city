
namespace eval Subspace::Portal {

    proc portalRoom {} {
        puts "== Subspace Projection Room =="
        switch [state get subspace-portal] {
            no {
                puts -nonewline "The projector sits in the middle of the room and appears to\
                currently be inactive."
            }
            river {
                puts -nonewline "The projector in the middle of the room is active and\
                projects a calm, cold river."
            }
        }
        if {[state get hero-blade] eq {no}} then {
            puts " A young woman in silver armor is standing next to the projector."
        } elseif {[state get necro-cipher] eq {help}} {
            puts {}
        } else {
            puts " Atheena is standing next to the projector."
        }
        prompt {} {
            {"Talk to the woman" {[state get hero-blade] eq {no}} atheena}
            {"Talk to Atheena" {([state get hero-blade] ne {no}) && ([state get necro-cipher] ne {help})} atheena}
            {"Pass through the portal" {[state get subspace-portal] ne {no}} portal}
            {"Head back to the hub" yes ::Subspace::Hub::hub}
        }
    }

    proc portal {} {
        switch [state get subspace-portal] {
            river {
                return ::Prison::Forest::river
            }
        }
    }

    proc atheena {} {
        switch [state get hero-blade] {
            no {
                puts "\"Greetings! I am Atheena, hero of the Seven Seas! How do you do?\""
                state put hero-blade met
                prompt {} {
                    {"\"What are you doing in subspace?\"" yes atheenaIntro}
                    {"\"Goodbye.\"" yes portalRoom}
                }
            }
            met {
                puts "\"Greetings!\""
                prompt {} {
                    {"\"What are you doing in subspace?\"" yes atheenaIntro}
                    {"\"Goodbye.\"" yes portalRoom}
                }
            }
            talked {
                if {([state get merchant-fought] eq {fought}) && ([state get merchant-atheena] eq {yes})} then {
                    puts "\"I will join you in your fight against the robot when you confront him!\""
                } else {
                    puts "\"Greetings!\""
                }
                prompt {} {
                    {"\"Could you turn the portal on?\"" {[state get subspace-portal] eq {no}} basicPortal}
                    {"\"Is that the only place the portal can go?\"" {([state get subspace-portal] ne {no}) && ([state get hero-crystal] eq {no})} atheenaCrystal}
                    {"\"There's a madman at the taco shop!\"" {[state get necro-cipher] eq {rising}} atheenaHelp}
                    {"\"I need help fighting an evil robot.\"" {([state get merchant-fought] eq {fought}) && ([state get merchant-atheena] eq {no}) && [inv has {Self-Destruct Chip}]} atheenaMerchant}
                    {"\"Thank you for the help with Joe.\"" {[state get necro-cipher] in {beaten yes}} atheenaThanks}
                    {"\"Thank you for the help with Merchant-bot.\"" {[state get merchant-war] eq {yes}} atheenaThanksBot}
                    {"\"Goodbye.\"" yes portalRoom}
                }
            }
        }
    }

    proc atheenaIntro {} {
        puts "\"Alas, I was trapped here by an evil wizard, with no way to return to my own\
        time. And thus, I have learned the ways of the portal projector. If you would like me\
        to activate the portal device, please let me know.\""
        state put hero-blade talked
        prompt {} {
            {"\"Please turn it on.\"" yes basicPortal}
            {"\"Maybe later.\"" yes portalRoom}
        }
    }

    proc atheenaHelp {} {
        puts "\"A madman?! How foul! Come, we shall defeat this villain together!\""
        puts "Without another word, Atheena races toward the taco shop, her hand\
        on the hilt of her blade."
        state put necro-cipher help
        puts {}
        return portalRoom
    }

    proc atheenaThanks {} {
        puts "\"As hero of the Seven Seas, it is my duty to help those in need. You are\
        very welcome.\""
        puts {}
        return portalRoom
    }

    proc atheenaMerchant {} {
        puts "\"An evil robot?! Enslaving humans? I see no nobler cause than to vanquish the\
        monster! I will be there when you need me! You have my word!\""
        state put merchant-atheena yes
        puts {}
        return portalRoom
    }

    proc atheenaThanksBot {} {
        puts "\"It is always my pleasure to help those in need.\""
        puts {}
        return portalRoom
    }

    proc atheenaCrystal {} {
        puts "\"Once upon a time, it could be modified. The projector is operated by a\
        specially-cut diamond. But the bank claimed the diamond as collateral long before\
        I got here, and the device has been inoperable since.\""
        state put hero-crystal intro
        puts {}
        return portalRoom
    }

    proc basicPortal {} {
        puts "\"Of course.\""
        puts "Atheena activates the portal device."
        puts {}
        state put subspace-portal river
        return portalRoom
    }

}
