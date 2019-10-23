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

; SHOULD BE IN RAM!
SPI_OUT   .db 0   ; SPI output shadow register
SPI_SPEED .db 255

SPI_DELAY:
    PSHS A
    LDA SPI_SPEED
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
; READ SDCARD 1 BYTE RESPONSE INTO MEM -> X PTR
;   assumed that NSS is 0
;   saves X
; ==================================================
SDRX1:
    JSR SPI_RXA
    TSTA
    BMI SDRX1       ; MSB should be 0
    STA ,X
    RTS

; ==================================================
; READ SDCARD 4 BYTE RESPONSE INTO MEM -> X PTR
;   assumed that NSS is 0
;   saves X
; ==================================================
SDRX5:
    JSR SPI_RXA
    TSTA
    BMI SDRX5       ; MSB should be 0
    STA 0,X
    JSR SPI_RXA
    STA 1,X
    JSR SPI_RXA
    STA 2,X
    JSR SPI_RXA
    STA 3,X
    JSR SPI_RXA
    STA 4,X    
    RTS

; ==================================================
;   SD CARD INIT 
; ==================================================

; can be in ROM:
CMD0:   .db $40,0,0,0,0,$95
CMD8:   .db $48,0,0,1,$AA,$87
CMD41:  .db $69,0x40,0,0,0,1
CMD55:  .db $77,0,0,0,0,1
CMD58:  .db $7A,0,0,0,0,1

; SDRESP must be in RAM!
SDRESP:  .db 0,0,0,0,0

SDFAIL:
    LDX #SDERR
    JSR PRINTSTRING
    LDX #ASK    
    JSR PRINTSTRING
    JSR INCHAR      ; wait for key press
    ; intentional fall-through
    
    ; === INIT ENTRY POINT ===
SDINIT:
    LDA #255
    STA SPI_SPEED   ; set slowest speed
    JSR NSS1        ; deselect card
    JSR MOSI1       ; default state for MOSI
    JSR SCK0        ; default state for SCK
    LDB #10         ; 10 bytes -> spec says at least 74 clock cycles
    
SDINIT1:
    LDA #$FF        ; make sure MOSI stays at '1'
    JSR SPI_TXA     ; send idle sequence
    DECB
    BNE SDINIT1

    ; === send CMD0 init sequence ===
    LDB #10         ; try CMD0 max 10x 
TRYCMD0:
    DECB
    BEQ SDFAIL
    LDX #CMD0
    JSR SDTXCMD

    ; read CMD0 response
    ; should be $01 for OK
    LDX #SDRESP
    JSR SDRX1
    JSR NSS1
    LDA 0,X     
    CMPA #$01       ; check status code
    BNE TRYCMD0
    
    ; === send CMD8  ===
    LDB #10         ; try CMD8 max 10x 
TRYCMD8:
    DECB
    BEQ SDFAIL    
    LDX #CMD8
    JSR SDTXCMD

    ; read response
    LDX #SDRESP
    JSR SDRX5
    JSR NSS1
    LDA 0,X
    CMPA #$01       ; check status code
    BNE TRYCMD8
    LDA 3,X
    CMPA #$01
    BNE TRYCMD8     ; check voltage range
    LDA 4,X
    CMPA #$AA
    BNE TRYCMD8
    
    ; == idle period ==
    LDA #$FF
    JSR SPI_TXA
    LDA #$FF
    JSR SPI_TXA
    LDA #$FF
    JSR SPI_TXA
    LDA #$FF
    JSR SPI_TXA

    LDB #10
INIT_AGAIN:
    DECB
    LBEQ SDERR

    ; === send CMD55  ===
    LDX #CMD55
    JSR SDTXCMD

    ; read response
    LDX #SDRESP
    JSR SDRX1
    JSR NSS1
    ; ignore response for now.. 

    ; === send ACMD41  ===
    LDX #CMD41
    JSR SDTXCMD

    ; read response
    LDX #SDRESP
    JSR SDRX1
    JSR NSS1

    ; init bit should be zero to indicate
    ; card came out of init.

    LDA 0,X
    ANDA #1
    BNE INIT_AGAIN

    ; === send CMD58  ===
    ; to read OCR register
    ;
    ; bit 30 is Card capacitry status
    ; bit 31 is Card power up status
    ;
    LDB #10
CMD58AGAIN:
    DECB
    LBEQ SDERR

    LDX #CMD58
    JSR SDTXCMD

    ; read response
    LDX #SDRESP
    JSR SDRX5
    JSR NSS1
    LDA 0,X
    CMPA #$00
    LBNE SDERR
    LDA 1,X           ; check the capacity
    ANDA #$C0
    CMPA #$C0
    BNE CMD58AGAIN

    ; tell user the SD card was initialized
    LDX #SDOK1
    JSR PRINTSTRING

    ; set fast speed
    LDA #1
    STA SPI_SPEED
  
    RTS

; ==================================================
;   SD CARD - READ SINGLE BLOCK
;   A - MSB of 16-bit block index
;   B - LSB of 16-bit block index
;   X - Destination pointer
;
;   return: Z=1 if no error.
;
;   Assumption: SD card is a high-capacity card
;               which always uses 512-byte
;               fixed-size blocks
; ==================================================

SDREAD:
    PSHS A
    LDA #$FF        ; send 8 idle clocks
    JSR SPI_TXA

    JSR NSS0        ; select card
    
    LDA #$FF        ; send 8 idle clocks
    JSR SPI_TXA

    LDA #$51        ; CMD17
    JSR SPI_TXA
    CLRA            ; address 31-24 -> 0
    JSR SPI_TXA
    CLRA            ; address 23-16 -> 0
    JSR SPI_TXA
    PULS A          ; address 15-8 -> MSB block index
    JSR SPI_TXA
    TFR B,A         ; address 7-0 -> LSB block index
    JSR SPI_TXA
    LDA #$01        ; dummy CRC + stop bit
    JSR SPI_TXA

    ; turn around
    LDA #$FF        ; send 8 idle clocks
    JSR SPI_TXA

    ; read response
    PSHS X
    LDX #SDRESP
    JSR SDRX1
    LDA 0,X         ; get response code
    BEQ SDREAD_ROK  ; expected = 0
    PULS X
    JMP SDREAD_ERR

SDREAD_ROK:
    PULS X
    ; wait for data response token (0xFE)
SDREAD_AGAIN:
    JSR SPI_RXA
    CMPA #$FF
    BEQ SDREAD_AGAIN

    ; check for 0xFE
    CMPA #$FE
    BNE SDREAD_ERR  ; didnt find response token -> error

    ; read the 512-byte data block (512 bytes)
    ; but store only the first 256 bytes
    ;
    ; alternatively, send CMD12 to terminate xfer
    ; which is faster
    ;
    CLRB
SDREAD_BLK1:    
    JSR SPI_RXA
    STA ,X+
    DECB 
    BNE SDREAD_BLK1

    CLRB  ; superfluous, but ok.
SDREAD_BLK2:
    JSR SPI_RXA
    DECB 
    BNE SDREAD_BLK2

    ; read the 16-bit CRC
    ; and ignore it :)
    JSR SPI_RXA
    JSR SPI_RXA

    ; de-select SD card
    JSR NSS1

SDREAD_OK:
    ORCC #$04       ; set zero flag
    RTS

SDREAD_ERR:
    JSR NSS1
    JSR PRINTAHEX
    ANDCC #$FB      ; clear zero flag
    RTS

; ==================================================
;   SD CARD - WRITE SINGLE BLOCK
;   A - MSB of 16-bit block index
;   B - LSB of 16-bit block index
;   X - Source pointer
;
;   return: Z=1 if no error.
;
;   Assumption: SD card is a high-capacity card
;               which always uses 512-byte
;               fixed-size blocks
; ==================================================

SDWRITE:
    PSHS A
    LDA #$FF        ; send 8 idle clocks
    JSR SPI_TXA

    JSR NSS0        ; select card
    
    LDA #$FF        ; send 8 idle clocks
    JSR SPI_TXA

    LDA #$58        ; CMD24
    JSR SPI_TXA
    CLRA            ; address 31-24 -> 0
    JSR SPI_TXA
    CLRA            ; address 23-16 -> 0
    JSR SPI_TXA
    PULS A          ; address 15-8 -> MSB block index
    JSR SPI_TXA
    TFR B,A         ; address 7-0 -> LSB block index
    JSR SPI_TXA
    LDA #$01        ; dummy CRC + stop bit
    JSR SPI_TXA

    ; turn around
    LDA #$FF        ; send 8 idle clocks
    JSR SPI_TXA

    ; read response
    PSHS X
    LDX #SDRESP
    JSR SDRX1
    LDA 0,X         ; get response code
    BEQ SDWRITE_ROK  ; expected = 0
    PULS X
    JMP SDWRITE_ERR

SDWRITE_ROK:
    PULS X
    ; send mandatory dummy byte
    LDA #$FF
    JSR SPI_TXA

    ; send start-of-packet byte 0xFE
    LDA #$FE
    JSR SPI_TXA

    ; send the 512-byte data block    
    CLRB
SDWRITE_BLK1:
    LDA ,X+
    JSR SPI_TXA
    DECB
    BNE SDWRITE_BLK1

    CLRB
SDWRITE_BLK2:
    CLRA            ; fill last part of sector with 0
    JSR SPI_TXA
    DECB
    BNE SDWRITE_BLK2

    ; send dummy CRC
    CLRA
    JSR SPI_TXA    
    LDA #$01
    JSR SPI_TXA

    ; wait for the data accept token
    CLRB
SDWRITE_TOK:
    DECB
    BEQ SDWRITE_ERR ;  time-out
    JSR SPI_RXA
    CMPA #$FF
    BEQ SDWRITE_TOK

    ; check token
    ANDA #$1F
    CMPA #$05       ; $05 = data accepted
    BNE SDWRITE_ERR
    

SDWRITE_OK:
    JSR NSS1
    ORCC #$04       ; set zero flag
    RTS

SDWRITE_ERR:
    JSR NSS1
    JSR PRINTAHEX
    ANDCC #$FB      ; clear zero flag
    RTS

; ==================================================
;   ENTRY POINT
; ==================================================

START:
    LDX #BANNER
    JSR PRINTSTRING
    JSR SDINIT

AGAIN:
    ; try to read sector 0 and display
    CLRA
    CLRB
    LDX #$2000
    JSR SDREAD
    BNE ERROR

    ; display sector data
    LDX #$2000
    CLRB
DISPSEC:
    LDA ,X+
    JSR PRINTAHEX
    DECB
    BNE DISPSEC
    LDX #EOLSTR
    JSR PRINTSTRING

    ; write to sector 0
    JSR INCHAR
    JSR OUTCHAR
    LDX #$2000
    CLRB
FILLSEC:
    STA ,X+
    DECB
    BNE FILLSEC
    
    CLRA
    CLRB
    LDX #$2000
    JSR SDWRITE
    BNE ERROR
    JMP AGAIN



ERROR:
    LDX #ERRORTXT
    JSR PRINTSTRING
    JMP START



LOOP:
    JMP LOOP


BANNER .ascii "=== HD6309 SD card test ==="
       .db 10,13,10,13,0

ASK    .ascii "Press any key to try again"
       .db 10,13,0

SDERR  .ascii "Error: failed to init SD card"
       .db 10,13,0

SDOK1  .ascii "SD card ok"
       .db 10,13,0

ERRORTXT  .ascii "I/O error - sector 0"
          .db 10,13,0

EOLSTR .db 10,13,0
