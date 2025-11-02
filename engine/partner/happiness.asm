GetPartnerPikachuHappiness:
; returns first Partner Pikachu's happiness in party (any slot), else 0
; copies name only in the success case

	ld hl, wPartyMon1Species
	ld de, PARTYMON_STRUCT_LENGTH
	ld c, 0 ; slot counter (0-5)

.loop
	ld a, [hl] ; species
	and a    ; end of party? (species 0)
	jr z, .not_partner
	cp -1    ; or $ff terminator if used
	jr z, .not_partner

	push hl
	push bc
	ld [wNamedObjectIndex], a
	ld bc, MON_FORM - MON_SPECIES
	add hl, bc
	ld a, [hl]
	ld [wNamedObjectIndex+1], a

	; Is this Partner Pikachu?
	ld a, LOW(SPECIES_PIKACHU_PARTNER)
	cp [wNamedObjectIndex]
	jr nz, .no_match
	ld a, HIGH(SPECIES_PIKACHU_PARTNER)
	cp [wNamedObjectIndex+1]
	jr nz, .no_match

	; It is Partner Pikachu – check egg and load happiness
	ld bc, MON_IS_EGG - MON_FORM
	add hl, bc
	bit MON_IS_EGG_F, [hl]
	jr nz, .no_match ; eggs have no happiness

	ld bc, MON_HAPPINESS - MON_IS_EGG
	add hl, bc
	ld a, [hl]
	ldh [hScriptVar], a

	pop bc ; discard counter
	pop hl ; discard struct start
	call GetPokemonName
	farjp CopyPokemonName_Buffer1_Buffer3

.no_match
	pop bc
	pop hl

	; Advance to next mon
	add hl, de
	inc c
	ld a, c
	cp PARTY_SIZE
	jr nz, .loop

.not_partner
	xor a
	ldh [hScriptVar], a
	ret
