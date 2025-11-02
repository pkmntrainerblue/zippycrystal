;=====================================================================
; GetPartnerPikachuHappiness
;   Returns happiness of first Partner Pikachu (form = 6) in party.
;   Sets hScriptVar = happiness
;   Copies name to Buffer3 via CopyPokemonName_Buffer1_Buffer3
;   Returns 0 if not found
;=====================================================================
GetPartnerPikachuHappiness:
	ld hl, wPartyMon1Species
	ld de, PARTYMON_STRUCT_LENGTH
	ld b, PARTY_LENGTH

.loop
	ld a, [hl]                  ; species
	and a
	jr z, .next                 ; empty
	cp EGG
	jr z, .next                 ; egg

	cp PIKACHU
	jr nz, .next

	; --- Check form (same byte as egg flag) ---
	ld bc, MON_IS_EGG - MON_SPECIES  ; = 35
	push hl
	add hl, bc
	ld a, [hl]
	pop hl

	cp PARTNER_FORM             ; 6
	jr nz, .next

	; --- Not egg (form != 1), already checked species != EGG ---
	; --- Read happiness ---
	ld bc, MON_HAPPINESS - MON_IS_EGG  ; = 15 - 35 = -20
	push hl
	add hl, bc
	ld a, [hl]
	ldh [hScriptVar], a
	pop hl

	; --- Set up name (species + form) ---
	ld a, PIKACHU
	ld [wNamedObjectIndex], a
	ld a, PARTNER_FORM
	ld [wNamedObjectIndex+1], a

	call GetPokemonName
	farjp CopyPokemonName_Buffer1_Buffer3

.next
	add hl, de
	dec b
	jr nz, .loop

	; --- Not found ---
	xor a
	ldh [hScriptVar], a
	ret
