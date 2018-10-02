
namespace eval Prison::Guard {

    proc talk {} {
        switch [state get prison-guard] {
            fired - search {
                puts "\"Head down, inmate. You've no business being out here.\""
                prompt {} {
                    {"Go inside" yes ::Prison::South::hallway}
                    {"\"What happened to that other guard?\"" yes fired}
                }
            }
            paid {
                puts "\"Ngh... such a pain... the warden breathing down my throat... please leave me alone...\""
                prompt {} {
                    {"Go inside" yes ::Prison::South::hallway}
                    {"\"What if the warden were to find out about our little bribe?\"" yes free}
                }
            }
            cleared {
                puts "\"Ngh... good to be back...\""
                prompt {} {
                    {"Go inside" yes ::Prison::South::hallway}
                    {"\"Did Attorney-Man help you?\"" {[state get attorney-guard] ne {yes}} attorney}
                    {"\"Can you open the gate?\"" {[state get attorney-guard] eq {yes}} free1}
                }
            }
            default {
                puts "\"Ngh... all these prisoners... so much work...\""
                prompt {} {
                    {"Go inside" yes ::Prison::South::hallway}
                    {"Bribe the guard with a Silver Coin" {[inv has {Silver Coin}]} bribe}
                }
            }
        }
    }

    proc attorney {} {
        puts "\"Huh...? Oh... yeah... he's a good lawyer...\""
        state put attorney-guard yes
        state put attorney-man [switch [state get attorney-man] {
            fed {expr 1}
            1 {expr 2}
            2 {expr {done}}
        }]
        prompt {} {
            {"Go inside" yes ::Prison::South::hallway}
            {"\"Can you open the gate?\"" yes free1}
        }
    }

    proc fired {} {
        puts "\"If you must know, he was terminated as a result of allegations of bribery. Now, step inside.\""
        state put prison-guard search
        prompt {} {
            {"Go inside" yes ::Prison::South::hallway}
        }
    }

    proc free {} {
        puts "\"... Ugh... what a pain. You can go... just don't come back...\""
        puts "The guard opens the prison gate."
        state put prison-guard fired
        state put awaiting-bus trees
        prompt {} {
            {"Leave the prison" yes ::Prison::Forest::gate}
        }
    }

    proc free1 {} {
        puts "\"... Oh, sure... just for helping me... ngh...\""
        puts "The guard opens the prison gate."
        state put awaiting-bus trees
        prompt {} {
            {"Leave the prison" yes ::Prison::Forest::gate}
        }
    }

    proc bribe {} {
        puts "\"Oh, sure, why not... go ahead... get out of here...\""
        puts "The guard takes your bribe and opens the gate."
        state put prison-guard paid
        state put awaiting-bus trees
        inv remove {Silver Coin}
        prompt {} {
            {"Leave the prison" yes ::Prison::Forest::gate}
        }
    }

}
