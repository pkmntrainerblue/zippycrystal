SECTION "Follower Script", ROMX

FollowerScript::
	faceplayer
	cry PIKACHU
    special GetFirstPokemonHappiness
	ifgreater $f9, .AdoresYou
	ifgreater $c7, .ReallyTrustsYou
	ifgreater $95, .HappyWithYou
	ifgreater $63, .CuriousAboutYou
	ifgreater $31, .NotUsedToYou
    ifequalfwd $0, .DisgustedByYou
;fallthrough
.NotUsedToYou:
    opentext
    writetext .NotUsedToYouText
    waitbutton
    closetext
    end

.NotUsedToYouText:
    text "Pikachu seems"
    line "wary of you."
    done

.AdoresYou:
    applymovement FOLLOWER, .jumping
    showemote EMOTE_HEART, FOLLOWER, 30
    opentext
    writetext .AdoresYouText
    waitbutton
    closetext
    end

.jumping:
    jump_in_place
    jump_in_place
    jump_in_place
    step_end

.AdoresYouText:
    text "Pikachu absolutely"
    line "adores you!"
    done
    
.ReallyTrustsYou:
;   applymovement FOLLOWER, .dance
    showemote EMOTE_HAPPY, FOLLOWER, 30
    opentext
    writetext .ReallyTrustsYouText
    waitbutton
    closetext
    end

.ReallyTrustsYouText:
    text "Pikachu trusts you"
    line "completely."
    done

.HappyWithYou:
    showemote EMOTE_HAPPY, FOLLOWER, 30
    opentext
    writetext .HappyWithYouText
    waitbutton
    closetext
    end

.HappyWithYouText:
    text "Pikachu is content"
    line "spending time with"
    cont "you."
    done

.CuriousAboutYou:
    opentext
    writetext .CuriousAboutYouText
    waitbutton
    closetext
    end

.CuriousAboutYouText:
    text "Pikachu appears to"
    line "be watching you"
    cont "closely."
    done

.DisgustedByYou:
    showemote EMOTE_SAD, FOLLOWER, 30
    opentext
    writetext .DisgustedByYouText
    waitbutton
    closetext
    end

.DisgustedByYouText:
    text "Pikachu refuses to"
    line "even look at you."
    done
