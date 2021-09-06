    processor 6502

    seg code
    org $F000       ; Define the code origin at $F000

Start:
    sei             ; Disable interrupts
    cld             ; Disable the BCD (decimal) math mode
    ldx #$FF        ; Load $FF to X register
    txs             ; transfer the X register to the stack (stack pointer)
                    ; $FF is the last memory address we have access to
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear the Page Zero region ($00 to $FF)
; Meaning the entire RAM and also the entire TIA register
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #0          ; A = 0
    ldx #$FF        ; X = #$FF -> loop counter

MemLoop:
    sta $0,X        ; Store the value of A inside in position 0+FF(FE,FD...)
    dex             ; X--
    bne MemLoop     ; Loop until X is equal to zero (zflag)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fill the ROM size to exaclty 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    org $FFFC       ; set the origin at the end of the cartridge address space
    .word Start     ; FFFC - FFFD Reset vector at $FFFC (where the program starts) (2 bytes)
    .word Start     ; FFFE - FFFF Interrupt vector at $FFFE -> unused (2 bytes)