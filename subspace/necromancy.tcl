
namespace eval Subspace::Necromancy {

    proc boss {helper} {
        puts "*******************"
        puts "*   BOSS BATTLE   *"
        puts "*     VERSUS      *"
        puts "* NECROMANCER JOE *"
        puts "*******************"
        puts {}
        switch $helper {
            no {
                return {solo 100 100}
            }
            atheena {
                puts "You can feel the power of Atheena's blade protecting you."
                puts {}
                return {team 100 100 100}
            }
        }
    }

    proc solo {hp ehp} {
        if {$hp <= 0} then {
            return defeated
        } elseif {$ehp <= 0} then {
            return victory
        }
        puts "Player HP: [format {%3d}  $hp]/100"
        puts "Joe    HP: [format {%3d} $ehp]/100"
        puts {}
        puts "Player's turn."
        set option1 "{Fist of Rage} yes {soloFist $hp $ehp}"
        set option2 "{Righteous Roundhouse Kick} yes {soloKick $hp $ehp}"
        set option3 "{Rest} yes {soloRest $hp $ehp}"
        prompt {} [list $option1 $option2 $option3]
    }

    proc soloFist {hp ehp} {
        puts "Player used Fist of Rage! Dealt 2 damage!"
        set ehp [expr {$ehp - 2}]
        puts {}
        return [list soloEnemyTurn $hp $ehp]
    }

    proc soloKick {hp ehp} {
        puts "Player used Righteous Roundhouse Kick! Dealt 3 damage!"
        set ehp [expr {$ehp - 3}]
        puts {}
        return [list soloEnemyTurn $hp $ehp]
    }

    proc soloRest {hp ehp} {
        puts "Player rested! Healed 1 HP!"
        set hp [expr {$hp + 1}]
        puts {}
        return [list soloEnemyTurn $hp $ehp]
    }

    proc soloEnemyTurn {hp ehp} {
        if {$hp <= 0} then {
            return defeated
        } elseif {$ehp <= 0} then {
            return victory
        }
        puts "Joe's turn."
        switch [expr {$ehp % 6}] {
            0 - 1 {
                puts "Joe used Shroud of Darkness! Dealt 31 damage!"
                set hp [expr {$hp - 31}]
            }
            2 - 3 {
                puts "Joe used Accursed Grip! Dealt 34 damage!"
                set hp [expr {$hp - 34}]
            }
            4 - 5 {
                puts "Joe used Flames from Below! Dealt 36 damage!"
                set hp [expr {$hp - 36}]
            }
        }
        puts {}
        return [list solo $hp $ehp]
    }

    proc team {hp ahp ehp} {
        if {($hp <= 0) || ($ahp <= 0)} then {
            return defeated
        } elseif {$ehp <= 0} then {
            return victory
        }
        puts "Player  HP: [format {%3d}  $hp]/100"
        puts "Atheena HP: [format {%3d} $ahp]/100"
        puts "Joe     HP: [format {%3d} $ehp]/100"
        puts {}
        puts "Player's turn."
        set option1 "{Fist of Rage} yes {teamFist $hp $ahp $ehp}"
        set option2 "{Righteous Roundhouse Kick} yes {teamKick $hp $ahp $ehp}"
        set option3 "{Rest} yes {teamRest $hp $ahp $ehp}"
        prompt {} [list $option1 $option2 $option3]
    }

    proc teamFist {hp ahp ehp} {
        puts "Player used Fist of Rage! Dealt 2 damage!"
        set ehp [expr {$ehp - 2}]
        puts {}
        return [list teamEnemyTurn $hp $ahp $ehp]
    }

    proc teamKick {hp ahp ehp} {
        puts "Player used Righteous Roundhouse Kick! Dealt 3 damage!"
        set ehp [expr {$ehp - 3}]
        puts {}
        return [list teamEnemyTurn $hp $ahp $ehp]
    }

    proc teamRest {hp ahp ehp} {
        puts "Player rested! Healed 1 HP!"
        set hp [expr {$hp + 1}]
        puts {}
        return [list teamEnemyTurn $hp $ahp $ehp]
    }

    proc teamEnemyTurn {hp ahp ehp} {
        if {($hp <= 0) || ($ahp <= 0)} then {
            return defeated
        } elseif {$ehp <= 0} then {
            return victory
        }
        puts "Atheena's turn."
        puts "Atheena used Blade of Heroes! Dealt 26 damage!"
        set ehp [expr {$ehp - 26}]
        puts {}
        if {($hp <= 0) || ($ahp <= 0)} then {
            return defeated
        } elseif {$ehp <= 0} then {
            return victory
        }
        puts "Joe's turn."
        if {($ehp % 10) > 5} then {
            set target "Player"
            set thp0 $hp
            set thp {hp}
        } else {
            set target "Atheena"
            set thp0 $ahp
            set thp {ahp}
        }
        puts "$thp0 $thp"
        switch [expr {$ehp % 6}] {
            0 - 1 {
                puts "Joe used Shroud of Darkness on $target! Dealt 8 damage!"
                set $thp [expr {$thp0 - 8}]
            }
            2 - 3 {
                puts "Joe used Accursed Grip on $target! Dealt 9 damage!"
                set $thp [expr {$thp0 - 9}]
            }
            4 - 5 {
                puts "Joe used Flames from Below on $target! Dealt 11 damage!"
                set $thp [expr {$thp0 - 11}]
            }
        }
        puts {}
        return [list team $hp $ahp $ehp]
    }

    proc defeated {} {
        puts "\"Now you perish!\""
        puts {}
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door murder
        }
        return ::Underworld::Lobby::murder
    }

    proc victory {} {
        puts "\"No! Not like this! Not when I was so close!\""
        puts "Atheena leaps forward and delivers one final blow.\
        As the Blade of Heroes pierces his chest, Joe disappears in\
        a bath of divine white light. The spirits of the dead retreat\
        back into the hole in the ground, which remains present."
        puts "\"Excellent teamwork!\""
        prompt {} {
            {"\"We did it!\"" yes {victory1 we}}
            {"\"Thank you!\"" yes {victory1 thank}}
        }
    }

    proc victory1 {answer} {
        switch $answer {
            we {
                puts "\"Yes we did! Now, if you require any further assistance, I shall\
                be in the projection room.\""
            }
            thank {
                puts "\"You're quite welcome. Now, if you require any further assistance, I\
                shall be in the projection room.\""
            }
        }
        puts "Atheena sheathes her blade and walks back out the door calmly. After\
        a moment, the Taco Man looks at you."
        puts "\"You saved my shop again! Thank you so much!\""
        prompt {} {
            {"\"All in a day's work.\"" yes victory2}
            {"\"Glad I could help.\"" yes victory2}
        }
    }

    proc victory2 {} {
        puts "\"This cursed hole in the ground may cause trouble for business. Perhaps you\
        should investigate it. When you have the time, of course.\""
        state put necro-cipher beaten
        prompt {} {
            {"\"I will.\"" yes ::Subspace::Taco::shop}
        }
    }

}
