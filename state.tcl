
namespace eval State {

    variable impl [dict create {*}{
        city-thug no
        stolen-good {}
        thug-card {Platinum Card}
        sa-coin no
        trial-crime no
        trial-reason {}
        janitor-door no
        been-to-prison no
        prison-guard no
        awaiting-bus no
        forest-river 0
        lobby-door no
        talked-to-johnny no
        johnny-quest no
        exercise-soul no
        talked-to-cipher no
        second-class-door no
        first-class-door no
        muffin-second no
        motel-room no
        inn-room no
        heard-science no
        butler-game no
        talked-to-louis no
        jumped-into-fire no
        collected-suit no
        fe-coin no
        merchant-bot no
        olive-bought no
        secret-chamber-door no
        attorney-man no
        courtroom-key no
        subspace-attic no
        taco-shop no
        pawn-shop-pass no
        has-suitcase no
        hero-blade no
        hero-crystal no
        subspace-portal no
        attorney-self no
        attorney-thug no
        attorney-guard no
        courthouse-door no
        judge-muffin no
        guard-soul no
        hunter-trail no
        hunter-soul no
        mercury-muffin no
        moon-teleport no
        moon-mechanic no
        moon-train no
        subspace-reason no
        talked-to-acolyte no
        fire-pit no
        talked-to-steve no
        necro-cipher no
        golden-arches no
        talked-to-reaper no
        reaper-has-item no
        reaper-helper no
        stairs-tried no
        talked-to-grigory no
        captain-boat no
        motel-ghost no
        motel-prison no
        motel-warehouse no
        motel-subspace no
        captain-boat-place dream
        talked-to-todd no
        merchant-war no
        judge-paperclip no
        the-fence no
        cottage-spirit no
        false-stage no
        spirit-baker no
        spirit-gamer no
        spirit-bald no
        spirit-muffin no
        spirit-lizard no
        false-stage-ran no
        stage-coin no
        subspace-freedom no
        reaper-blessing no
        obtained-true-reaper no
        steve-disappeared no
        pirate-attack no
        talked-to-hatman no
        treasure-room no
        harry-location no
        police-hut no
        baby-doll no
        hut-password no
        heart-pipe no
        moth-king no
        doll-key no
        rocket-launched no
        washroom-coin no
        brain-control no
        crypto-king no
        crypto-door no
        merchant-fought no
        merchant-atheena no
        merchant-starlight no
        warehouse-owner no
        owner-key no
    }]

    proc get {args} {
        variable impl
        dict get $impl {*}$args
    }

    proc put {args} {
        variable impl
        dict set impl {*}$args
    }

    proc all {} {
        variable impl
        return $impl
    }

    namespace export get put all

    namespace ensemble create -command ::state

}
