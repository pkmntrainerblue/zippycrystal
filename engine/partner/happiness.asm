;=====================================================================
; GetPartnerPikachuHappiness
;   Returns happiness of first PIKACHU_PARTNER_FORM in party.
;   Output: hScriptVar = happiness (0 if not found)
;=====================================================================
GetPartnerPikachuHappiness:
    ld hl, wPartyMon1Species
    ld de, PARTYMON_STRUCT_LENGTH    ; 48
    ld b, PARTY_LENGTH               ; 6

.loop
    ; --- Skip empty ---
    ld a, [hl]
    and a
    jr z, .next

    ; --- Skip egg ---
    cp EGG
    jr z, .next

    ; --- Must be PIKACHU ---
    cp PIKACHU
    jr nz, .next

    ; --- Get form byte ---
    push hl
    ld bc, MON_FORM                  ; 35
    add hl, bc
    ld a, [hl]                       ; form byte
    pop hl

    ; --- Check if extended species (bit 7 set) ---
    and EXTSPECIES_MASK
    jr z, .next                      ; not extended → not partner

    ; --- Combine: (form & %10000000) | species ---
    push hl
    ld bc, MON_FORM
    add hl, bc
    ld a, [hl]                       ; form
    and %10000000
    ld c, a
    pop hl
    ld a, [hl]                       ; species low
    or c
    cp PIKACHU_PARTNER_FORM          ; $18a
    jr nz, .next

    ; --- Found! Get happiness ---
    push hl
    ld bc, MON_HAPPINESS             ; 15
    add hl, bc
    ld a, [hl]
    ldh [hScriptVar], a
    pop hl
    ret

.next
    add hl, de
    dec b
    jr nz, .loop

    xor a
    ldh [hScriptVar], a
    ret
