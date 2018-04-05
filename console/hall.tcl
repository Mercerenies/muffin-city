
namespace eval Console::Hall {

    proc main {} {
        puts "== Console Halls - Main Room =="
        puts "The walls spread apart, giving way to a large, relatively\
        triangular room. On the outer wall, there are three doors.\
        The leftmost door looks like it would belong on an office\
        building, the middle door is made of logs and would fit\
        better on a cabin, and the rightmost door is electronic\
        and futuristic."
        prompt {} {
            {"Enter the office door" yes office}
            {"Enter the cabin door" yes cabin}
            {"Enter the electronic door" yes future}
        }
    }

    proc office {} {
        puts "== Console Halls - City Room =="
        if {[state get golden-arches]} then {
            puts "A relatively small triangular room houses four\
            golden arches on the back wall. Behind you, there is a\
            glass door resembling that which you would find within\
            an office building."
        } else {
            puts "A relatively small triangular room is mostly empty.\
            Behind you, there is a glass door resembling that which you\
            would find within an office building."
        }
        prompt {} {
            {"Enter the present day" {[state get golden-arches]} ::City::District::police}
            {"Go back to the main room" yes main}
        }
    }

    proc cabin {} {
        puts "== Console Halls - World Room =="
        if {[state get golden-arches]} then {
            puts "A relatively small triangular room houses four\
            golden arches on the back wall. Behind you, there is a\
            wooden door resembling that which you would find on\
            a log cabin."
        } else {
            puts "A relatively small triangular room is mostly empty.\
            Behind you, there is a wooden door resembling that which\
            you would find on a log cabin."
        }
        prompt {} {
            {"Go back to the main room" yes main}
        }
    }

    proc future {} {
        puts "== Console Halls - Meta Room =="
        if {[state get golden-arches]} then {
            puts "A relatively small triangular room houses four\
            golden arches on the back wall. Behind you, there is a\
            futuristic looking electronic door."
        } else {
            puts "A relatively small triangular room is mostly empty.\
            Behind you, there is a futuristic looking electronic door."
        }
        prompt {} {
            {"Go back to the main room" yes main}
        }
    }

}
