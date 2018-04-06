
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
            return -gameover
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
            return -gameover
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
        if {($hp <= 0) && ($ahp <= 0)} then {
            return defeated
        } elseif {$ehp <= 0} then {
            return -gameover
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
        return -gameover
    }

    proc defeated {} {
        puts "\"Now you perish!\""
        puts {}
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door murder
        }
        return ::Underworld::Lobby::murder
    }

}
