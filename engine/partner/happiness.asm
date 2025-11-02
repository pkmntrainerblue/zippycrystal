;=====================================================================
; GetPartnerPikachuHappiness
;   Returns happiness of first Partner Pikachu in party.
;   Output: hScriptVar = happiness (0 if not found)
;=====================================================================
GetPartnerPikachuHappiness:
	ld hl, wPartyMon1Species
	ld de, PARTYMON_STRUCT_LENGTH    ; 48
	ld b, PARTY_LENGTH               ; 6

.loop
	; --- Skip empty slot ---
	ld a, [hl]
	and a
	jr z, .next

	; --- Skip egg ---
	cp EGG
	jr z, .next

	; --- Must be PIKACHU ---
	cp PIKACHU
	jr nz, .next

	; --- Check form byte (offset 35) ---
	push hl
	ld bc, MON_FORM                  ; 35
	add hl, bc
	ld a, [hl]
	pop hl

	cp PARTNER_FORM                  ; 6
	jr nz, .next

	; --- Found Partner Pikachu! Get happiness (offset 15) ---
	push hl
	ld bc, MON_HAPPINESS             ; 15
	add hl, bc
	ld a, [hl]
	ldh [hScriptVar], a
	pop hl
	ret                              ; SUCCESS

.next
	add hl, de
	dec b
	jr nz, .loop

	; --- Not found ---
	xor a
	ldh [hScriptVar], a
	ret
