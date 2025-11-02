;=====================================================================
; GetPartnerPikachuHappiness
;   Returns happiness of first PIKACHU_PARTNER_FORM in party.
;   Output: hScriptVar = happiness (0 if not found)
;=====================================================================
GetPartnerPikachuHappiness:
	ld hl, wPartyMon1Species
	ld de, PARTYMON_STRUCT_LENGTH
	ld b, PARTY_LENGTH

.loop
	ld a, [hl]                      ; load species byte
	and a
	jr z, .next                     ; empty slot

	cp EGG
	jr z, .next                     ; egg

	ld c, a                         ; c = species low byte
	ld a, [wNamedObjectIndex + 1]   ; wait no, load form
	push hl
	ld bc, MON_IS_EGG - MON_SPECIES ; offset to form/egg byte
	add hl, bc
	ld a, [hl]                      ; a = form byte
	pop hl

	ld b, a                         ; b = form
	
	; combine: full index = (form & 0x80) | species
	and %10000000                   ; bit 7 (9th bit for >254)
	or c                            ; OR species low
	cp PIKACHU_PARTNER_FORM         ; single check!
	jr nz, .next

	; --- Found! Get happiness ---
	push hl
	ld bc, MON_HAPPINESS - MON_IS_EGG
	add hl, bc
	ld a, [hl]
	ldh [hScriptVar], a
	pop hl
	ret                             ; success

.next
	add hl, de
	dec b
	jr nz, .loop

	xor a
	ldh [hScriptVar], a
	ret
