
namespace eval City::Robbery {

    proc jumped {back} {
        puts {}
        puts "Suddenly, a robber leaps out from behind a building and points a gun in your face!"
        puts "\"Gimme yer money! Yer bein' robbed!\""
        set o1 [list {Give Silver Coin} {[inv has {Silver Coin}]} "giveAway {Silver Coin} {$back}"]
        set o2 [list {Give Platinum Card} {[inv has {Platinum Card}]} "giveAway {Platinum Card} {$back}"]
        set o3 [list {"I don't have any money!"} yes "haveNone $back"]
        set o4 [list {"No!"} yes refuse]
        prompt {} [list $o1 $o2 $o3 $o4]
    }

    proc giveAway {item back} {
        puts "\"That's right!\""
        puts "The robber takes your $item and runs off."
        inv remove $item
        state put city-thug island
        state put stolen-good $item
        puts {}
        return $back
    }

    proc refuse {} {
        puts "The robber pulls the trigger."
        state put city-thug hiding
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door murder
        }
        puts {}
        return ::Underworld::Lobby::murder
    }

    proc haveNone {back} {
        if {[inv has "Silver Coin"] || [inv has "Platinum Card"]} then {
            puts "\"Yer lyin'!\""
            puts "The robber pulls the trigger on his gun."
            state put city-thug hiding
            if {[state get lobby-door] ne {yes}} then {
                state put lobby-door murder
            }
            puts {}
            return ::Underworld::Lobby::murder
        } else {
            puts "\"Ngh... fine! Get lost!\""
            puts "The robber runs off into the night."
            state put city-thug no
            puts {}
            return $back
        }
    }

}
