GetPartnerPikachuHappiness:
; Returns happiness of the first Partner Pikachu in the party (any slot)
; Returns 0 and copies no name if not found
; Skips eggs

	ld hl, wPartyMon1Species
	ld de, PARTYMON_STRUCT_LENGTH
	ld b, PARTY_LENGTH ; 6

.loop
	ld a, [hl]        ; species
	and a             ; 0 = empty slot
	jr z, .next_slot
	cp EGG
	jr z, .next_slot

	; Check if it's PIKACHU
	cp PIKACHU
	jr nz, .next_slot

	; Save species for name
	ld [wNamedObjectIndex], a

	; Load form byte
	push hl
	ld bc, MON_FORM - MON_SPECIES
	add hl, bc
	ld a, [hl]
	ld [wNamedObjectIndex+1], a
	pop hl

	; Check if form == PARTNER_FORM (6)
	cp PARTNER_FORM
	jr nz, .next_slot

	; It's Partner Pikachu! Now check egg flag
	push hl
	ld bc, MON_IS_EGG - MON_FORM
	add hl, bc
	bit MON_IS_EGG_F, [hl]
	pop hl
	jr nz, .next_slot  ; eggs don't have happiness

	; Load happiness
	push hl
	ld bc, MON_HAPPINESS - MON_IS_EGG
	add hl, bc
	ld a, [hl]
	ldh [hScriptVar], a
	pop hl

	; Success: copy name and exit
	call GetPokemonName
	farjp CopyPokemonName_Buffer1_Buffer3

.next_slot
	add hl, de        ; next mon
	dec b
	jr nz, .loop

	; Not found: return 0
	xor a
	ldh [hScriptVar], a
	ret
