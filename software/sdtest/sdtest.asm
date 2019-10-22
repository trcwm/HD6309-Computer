; HD6309 Computer SD card expansion test
;
; Retro Challenge 2019/10
; Niels A. Moseley
; www.moseleyinstruments.com
;
; INPORT:
;   bit 7: /CARD_DETECT
;   bit 6: MISO
;
; OUTPORT:
;   bit 7: /SS
;   bit 6: MOSI
;   bit 5: SCK
;
; default state for the MOSI line is '1'
;
; https://electronics.stackexchange.com/questions/77417/what-is-the-correct-command-sequence-for-microsd-card-initialization-in-spi

; ==================================================
; SYSTEM CONSTANTS
; ==================================================

RAMSTART  EQU $0000
RAMEND    EQU $E000
STACK     EQU $DFE0

PAGEREG   EQU $E800
IOPORT    EQU $E010

; ==================================================
; UART ADDRESSES
; ==================================================
SER_TX     EQU $E000
SER_RX     EQU $E000
SER_IER    EQU $E001
SER_FCR    EQU $E002
SER_ISR    EQU $E002
SER_LCR    EQU $E003
SER_MCR    EQU $E004
SER_LSR    EQU $E005
SER_MSR    EQU $E006
SER_SPR    EQU $E007
SER_DLL    EQU $E000
SER_DLM    EQU $E001

    ORG $0000
    
    JMP START

; ==================================================
; OUTPUT A CHARACTER TO THE CONSOLE
; BLOCKS ON UART TX FULL
; ==================================================
OUTCHAR:
    PSHS B
OUTCHAR_1:
    LDB SER_LSR
    BITB #32
    NOP
    NOP
    BEQ OUTCHAR_1
    STA SER_TX
    PULS B
    RTS    

; ==================================================
; GET A CHARACTER FROM THE CONSOLE
; BLOCKS ON UART RX EMPTY
; ==================================================    

INCHAR:
    PSHS B
INCHAR_1:
    LDB SER_LSR
    BITB #1
    NOP
    NOP    
    BEQ INCHAR_1
    LDA SER_RX
    PULS B
    RTS    
    
; ==================================================
; PRINT STRING POINTED TO BY X
; BLOCKS ON UART TX FULL
; ==================================================     
PRINTSTRING:
    PSHS A
PRINTSTRING_1:
    LDA ,X+
    BEQ PS_END
    JSR OUTCHAR
    JMP PRINTSTRING_1
PS_END:
    PULS A
    RTS     

; ==================================================
; WRITE 'A' REGISTER AS HEX TO UART
; BLOCKS ON UART TX FULL
; ==================================================        
PRINTAHEX:
    PSHS A
    PSHS A
    ; convert MS nibble
    LSRA
    LSRA
    LSRA
    LSRA
    CMPA #9
    BLS PRINTAHEX_1
    ADDA #7             ; 'A'-'9'-1 : 65 - 57 - 1 = 7
PRINTAHEX_1:
    ADDA #'0'
    JSR OUTCHAR
    ; convert LS nibble
    PULS A
    ANDA #$0F
    CMPA #9
    BLS PRINTAHEX_2
    ADDA #7
PRINTAHEX_2:
    ADDA #'0'
    JSR OUTCHAR
    PULS A
    RTS


; ==================================================
;   SPI INTERFACE - delay for a bit
; ==================================================

SPI_OUT .db 0   ; SPI output shadow register

SPI_DELAY:
    PSHS A
    CLRA
SPI_DELAY1:  
    DECA
    BNE SPI_DELAY1
    PULS A
    RTS

; ==================================================
;   SPI INTERFACE - 
; ==================================================

SCK1:
    PSHS A
    LDA SPI_OUT
    ORA #32
    STA SPI_OUT
    STA IOPORT
    PULS A
    RTS

SCK0:
    PSHS A
    LDA SPI_OUT
    ANDA #$DF
    STA SPI_OUT
    STA IOPORT
    PULS A
    RTS

NSS1:
    PSHS A
    LDA SPI_OUT
    ORA #128
    STA SPI_OUT
    STA IOPORT
    PULS A
    RTS

NSS0:
    PSHS A
    LDA SPI_OUT
    ANDA #$7F
    STA SPI_OUT
    STA IOPORT
    PULS A
    RTS

MOSI1:
    PSHS A
    LDA SPI_OUT
    ORA #64
    STA SPI_OUT
    STA IOPORT
    PULS A
    RTS

MOSI0:
    PSHS A
    LDA SPI_OUT
    ANDA #$B5
    STA SPI_OUT
    STA IOPORT
    PULS A
    RTS

; SEND 'A' register, MSB first
SPI_TXA:
    PSHS B
    LDB #8
SPI_TX_NEXTBIT:    
    TSTA
    ; set the MOSI state
    BPL SPI_TXA0  ; is MSB of A is 0 -> branch
    BSR MOSI1
    BRA SPI_TXA1
SPI_TXA0:
    BSR MOSI0
SPI_TXA1:
    ; toggle the SCK line
    BSR SCK1
    BSR SPI_DELAY
    BSR SCK0
    BSR SPI_DELAY
    ASLA
    DECB
    BNE SPI_TX_NEXTBIT
    PULS B
    RTS

; READ MISO into 'A' register
SPI_RXA:
    PSHS B
    LDB #8
    BSR MOSI1     ; default state when RXing
SPI_RX_NEXT_BIT:
    BSR SCK1
    JSR SPI_DELAY
    ; read MISO bit
    PSHS B
    LDB IOPORT
    ASLB 
    ASLB          ; shift MISO bit into the carry flag
    ROLA          ; into A register
    PULS B

    BSR SCK0
    JSR SPI_DELAY

    DECB
    BNE SPI_RX_NEXT_BIT
    PULS B
    RTS

; ==================================================
; SEND SDCARD COMMAND POINTED TO BY X REG
;   assumed that NSS is 1
;   sets NSS to 0
; ==================================================
SDTXCMD:
    LDA #$FF      ; send 8 idle clocks
    JSR SPI_TXA
    
    JSR NSS0
    
    LDA #$FF      ; send 8 idle clocks
    JSR SPI_TXA

    
    LDA ,X+       ; cmd byte
    JSR SPI_TXA
    LDA ,X+       ; payload byte 1
    JSR SPI_TXA
    LDA ,X+       ; payload byte 2
    JSR SPI_TXA
    LDA ,X+       ; payload byte 3
    JSR SPI_TXA 
    LDA ,X+       ; payload byte 4
    JSR SPI_TXA
    LDA ,X
    JSR SPI_TXA   ; checksum + stop bit

    ; turn-around time
    LDA #$FF
    JSR SPI_TXA

    RTS

; ==================================================
;   SD CARD INIT 
; ==================================================

CMD0:   .db $40,0,0,0,0,$95
CMD8:   .db $48,0,0,1,$AA,$87
CMD41:  .db $69,0x40,0,0,0,1
CMD55:  .db $77,0,0,0,0,1
CMD58:  .db $7A,0,0,0,0,1

SDINIT:
    JSR NSS1  ; deselect card
    JSR MOSI1 ; default state for MOSI
    JSR SCK0  ; default state for SCK
    LDB #10   ; 10 bytes -> spec says at least 74 clock cycles
    
SDINIT1:
    LDA #$FF      ; make sure MOSI stays at '1'
    JSR SPI_TXA   ; send A (and destroys it)
    DECB
    BNE SDINIT1

    ; === send CMD0 init sequence ===
    LDX #CMD0
    JSR SDTXCMD

    ; read response
    LDX #CMD0TXT
    JSR PRINTSTRING
    JSR SPI_RXA
    JSR PRINTAHEX
    JSR NSS1

    LDX #EOLSTR
    JSR PRINTSTRING
    
    ; === send CMD8  ===
    LDX #CMD8
    JSR SDTXCMD

    ; read response
    LDX #CMD8TXT
    JSR PRINTSTRING

    JSR SPI_RXA
    JSR PRINTAHEX
    JSR SPI_RXA
    JSR PRINTAHEX
    JSR SPI_RXA
    JSR PRINTAHEX
    JSR SPI_RXA
    JSR PRINTAHEX
    JSR SPI_RXA
    JSR PRINTAHEX    
    JSR NSS1

    LDX #EOLSTR
    JSR PRINTSTRING

    ; == idle period
    LDA #$FF
    JSR SPI_TXA
    LDA #$FF
    JSR SPI_TXA
    LDA #$FF
    JSR SPI_TXA
    LDA #$FF
    JSR SPI_TXA

INIT_AGAIN:
    ; === send CMD55  ===
    LDX #CMD55
    JSR SDTXCMD

    ; read response
    LDX #CMD55TXT
    JSR PRINTSTRING

    JSR SPI_RXA
    JSR PRINTAHEX
    JSR NSS1

    LDX #EOLSTR
    JSR PRINTSTRING


    ; === send ACMD41  ===
    LDX #CMD41
    JSR SDTXCMD

    ; read response
    LDX #ACMD41TXT
    JSR PRINTSTRING

    JSR SPI_RXA
    PSHS A
    JSR PRINTAHEX
    JSR NSS1

    LDX #EOLSTR
    JSR PRINTSTRING
    PULS A
    ANDA #1
    BNE INIT_AGAIN

    ; === send CMD58  ===
    LDB #1
CMD58AGAIN:
    PSHS B
    LDX #CMD58
    JSR SDTXCMD

    ; read response
    LDX #CMD58TXT
    JSR PRINTSTRING

    JSR SPI_RXA
    JSR PRINTAHEX
    JSR SPI_RXA
    JSR PRINTAHEX
    JSR SPI_RXA
    JSR PRINTAHEX
    JSR SPI_RXA
    JSR PRINTAHEX
    JSR SPI_RXA
    JSR PRINTAHEX    
    JSR NSS1

    LDX #EOLSTR
    JSR PRINTSTRING

    PULS B
    DECB
    BNE CMD58AGAIN



    RTS

; ==================================================
;   ENTRY POINT
; ==================================================

START:
    LDX #BANNER
    JSR PRINTSTRING
    CLRB

CMDAGAIN:
    ; ask for user input
    LDX #ASK
    JSR PRINTSTRING

    JSR INCHAR
    
    CMPA #'S'
    BEQ INITSDCARD

    LDX #EOLSTR
    JSR PRINTSTRING
    JMP CMDAGAIN

INITSDCARD:
    JSR SDINIT
    JMP CMDAGAIN

BANNER .ascii "HD6309 SD card test"
       .db 10,13,0

ASK    .ascii "Press S to send init sequence"
       .db 10,13,0


CMD0TXT  .ascii "CMD0  : "
         .db 0
CMD8TXT  .ascii "CMD8  : "
         .db 0
CMD55TXT .ascii "CMD55 : "
         .db 0
CMD58TXT .ascii "CMD58 : "
         .db 0
ACMD41TXT .ascii "ACMD41: "
          .db 0

EOLSTR .db 10,13,0
