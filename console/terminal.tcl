
namespace eval Console::Terminal {

    proc gate {} {
        puts "== Console Room - Gate =="
        puts "On your left and right, there are tall walls filled with what appears to\
        be circuitry. These walls lead up to a exceedingly large double doors against\
        the back wall. There are no handles on the doors, and there doesn't appear to\
        be any sort of password or lock mechanism to open them. Behind you, your vision\
        blurs and the world becomes too hazy to make out. The surrounding area is eerily\
        quiet save for the hum of several computers."
        prompt {} {
            {"Force the door open" yes forceDoor}
            {"Wander into the haze" yes fade}
        }
    }

    proc forceDoor {} {
        puts "You punch, kick, and bash the door in every way you can think of, but\
        it doesn't move even an inch."
        puts {}
        return gate
    }

    proc fade {} {
        puts "As you wander about, your vision fades in and out, until suddenly the\
        world becomes crisp once again, and you find yourself in the commons."
        puts {}
        return {::Dream::World::commons 1}
    }

}
