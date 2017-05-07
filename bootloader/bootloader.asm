;
; Bootloader for HD6309 computer
; Retro Challenge 2017/04
; Niels A. Moseley
; www.moseleyinstruments.com
;
; Version
;   1.0 - initial version
;   1.1 - replaced custom loader with SREC loader
;   1.2 - moved the ISR trampoline addresses to
;         non-paged memory.

; ==================================================
; SYSTEM CONSTANTS
; ==================================================

RAMSTART  EQU $0000
RAMEND    EQU $E000
STACK     EQU $DFF0

; ==================================================
; BOOTLOADER ADDRESSES
; ==================================================
JMPADDR   EQU $DFFE     ; 16 bits
SRECCHK   EQU $DFFD     ; 8 bits
SRECERR   EQU $DFFC     ; 8 bits
SRECTMP   EQU $DFFB     ; 8 bits

; ==================================================
; ISR TRAMPOLINE ADDRESSES
; ==================================================

NMIADDR   EQU $DFEA     ; 16 bits
SWIADDR   EQU $DFE8     ; 16 bits
IRQADDR   EQU $DFE6     ; 16 bits
FIRQADDR  EQU $DFE4     ; 16 bits
SWI2ADDR  EQU $DFE2     ; 16 bits                        
SWI3ADDR  EQU $DFE0     ; 16 bits
                        
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

EXP_ADDR   EQU $E010

    ORG $F000   ; START OF ROM

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
; WRITE A REGISTER AS HEX TO UART
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
; START OF PROGRAM
; ==================================================

START:
    ORCC #%01010000 ; disable interrupts
    
    ; ****************************************
    ; init UART 
    ;   baud divisor to 48 -> 9600 baud
    ;   8 bits, 1 stop bit, no parity
    ; 
    ; ****************************************
    CLRA 
    STA SER_IER     ; no interrupts
    NOP
    NOP
    NOP
    NOP
    STA SER_FCR     ; no FIFO
    NOP
    NOP
    NOP
    NOP    
    LDA #$83        ; 8 bits per symbol, no parity, enable baud reg access
    STA SER_LCR     ;   line control
    NOP
    NOP
    NOP
    NOP    
    LDA #$4         ; set at least one led to ON
    STA SER_MCR     ;   modem control
    NOP
    NOP
    NOP
    NOP    
    LDA #48
    STA SER_DLL
    NOP
    NOP
    NOP
    NOP    
    CLRA
    STA SER_DLM
    NOP
    NOP
    NOP
    NOP    
    LDA #$03        ; 8 bits per symbol, no parity, disable baud reg access
    STA SER_LCR
    NOP
    NOP    
    NOP
    NOP
        
    ; ****************************************
    ; CHECK MEMORY 0 .. 0xDFFF
    ; ****************************************
    LDX #RAMSTART
MEMCHKLP:
    CLRA
    STA ,X
    LDA ,X
    CMPA #$00
    BNE MEMERROR     ; jump if not zero
    LDA #$FF
    STA ,X
    LDA ,X+
    CMPA #$FF
    BNE MEMERROR     ; jump if not equal
    CMPX #RAMEND
    BNE MEMCHKLP
    JMP MEMOK

MEMERROR:    
    LDA #$0C        ; both LEDS on
    STA SER_MCR     ;   modem control    
    NOP
    NOP
MEMERROR_1:
    NOP
    NOP
    LDB SER_LSR
    BITB #32
    BEQ MEMERROR_1
    NOP
    NOP    
    LDA #'E'
    STA SER_TX
STOP:   
    LDA #$F0
    STA EXP_ADDR
    JMP MEMERROR

    ; PRINT THE SIGN-ON MESSAGE
MEMOK:    
    LDS #STACK      ; LOAD THE STACK
    LDX #SIGNON
    JSR PRINTSTRING    
    JMP SRECLOADER
    
; ==================================================    
; SRECORD LOADER
;   https://en.wikipedia.org/wiki/SREC_(file_format)
; SUPPORTS
;   S0 - dumps to the terminal (not implemented)
;   S1 - 16-bit address data record
;   S9 - 16-bit start address
;
; Inspired by Alan Garfield's loader
; https://github.com/alangarf/amx_axc_m68k/blob/master/loader.s#L206
; ================================================== 
SRECLOADER:
    JSR  INCHAR     ; get character
    CMPA #'S'       ; is it an S record?
    BNE  SRECLOADER ; skip, if it isnt
    
    JSR  INCHAR     ; get next char
    CMPA #'1'       ; is it an S5 count
    BEQ  _LD_S1    
    CMPA #'9'       ; is it an S9 termination record?
    BEQ  _LD_S9
    JMP  SRECLOADER
    
_LD_S1:
    CLRB
    STB  SRECCHK    ; clear checksum
    STB  SRECERR    ; clear error flag
    JSR  SRECREAD   ; get S1 packet length
    SUBA #3         ; calculate number of payload bytes
    PSHS A          ; save the count
    JSR  SRECREAD   ; load MSB of address
    TFR  A,B        ; 
    JSR  SRECREAD   ; load LSB of address
    EXG  A,B        ; D = [MSB, LSB]
    TFR  D,X        ; X = load address
    PULS B          ; B = byte count
    JMP  _LD_DATA
    
_LD_S9:
    CLRB
    STB  SRECCHK    ; clear checksum
    JSR  SRECREAD   ; get S9 packet length
    JSR  SRECREAD   ; load MSB of address
    TFR  A,B        ; 
    JSR  SRECREAD   ; load LSB of address
    EXG  A,B        ; D = [MSB, LSB]
    STD  JMPADDR    ; store jump address
    JSR SRECREAD    ; read checksum byte
    LDB SRECCHK
    INCB            ; adjust for 1s complement!
    BEQ _LD_OK      ; total sum should be zero
    LDA #$FF
    STA SRECERR     ; set error flag    
_LD_OK:
    JMP _LD_TERM

; Load data part of packet
; expects B to have the number of
; bytes to read. Data is stored
; using the X index register
_LD_DATA:    
    JSR SRECREAD
    STA ,X+
    DECB
    BNE _LD_DATA    ; loop until there is no more data to read
    JSR SRECREAD    ; read checksum byte
    LDB SRECCHK
    INCB            ; adjust for 1s complement!
    BEQ _LD_DATA_OK ; total sum should be zero
    LDA #'X'        ; print X for every bad record
    JSR OUTCHAR
    LDA #$FF
    STA SRECERR     ; set error flag
    JMP SRECLOADER  ; try again .. 

_LD_DATA_OK:
    LDA #'*'        ; print * for every good record
    JSR OUTCHAR
    JMP SRECLOADER  ; next record .. 
    
; Check for errors
_LD_TERM:
    LDA SRECERR         ; load error flags
    BEQ _LD_NOERRORS    
    LDX #SRECERRORSTR    ; report error
    JSR PRINTSTRING
    JMP SRECLOADER      ; try again..
_LD_NOERRORS:
    LDX #ADDRSTR
    JSR PRINTSTRING
    LDA JMPADDR
    JSR PRINTAHEX
    LDA JMPADDR+1
    JSR PRINTAHEX
    LDX #EOLSTR
    JSR PRINTSTRING
    JMP [JMPADDR]       ; jump to start address
    
; ========================================
;   SREC LOADER
;   READ BYTE AS ASCII HEX DIGIT
;
;   return contents in A, update checksum
; ========================================
SRECREAD:
    PSHS B
    CLRA
    JSR  READHEXDIGIT
    LSLA
    LSLA
    LSLA
    LSLA
    JSR  READHEXDIGIT
    ;JSR  PRINTAHEX
    ; update checksum
    TFR  A,B
    ADDB SRECCHK
    STB  SRECCHK
    PULS B
    RTS

; ========================================
;   SREC LOADER - READ HEX DIGIT
;
; read an ASCII hex digit 0-9,A-F from
; the UART, convert to 4-bit binary
; and OR it with the contents in A.
; ========================================
READHEXDIGIT:
    PSHS B
    PSHS A          ; save A for later    
    JSR INCHAR
    SUBA #'0'       ; move ascii 0 down to binary 0
    BMI READHEX_ERR
    CMPA #9
    BLE READHEX_OK  ; 0-9 found
    SUBA #7         ; drop 'A' down to 10
    CMPA #$F
    BLE READHEX_OK
    
READHEX_ERR:
    PULS A
    PULS B
    RTS

READHEX_OK:
    STA SRECTMP     ; store 4-bit value in temp
    PULS A          ; restore old value
    ORA SRECTMP     ; or the hex value
    PULS B
    RTS
    
; ==================================================    
; INTERRUPT SERVICE ROUTINE INDIRECTIONS
; ==================================================    

SWI3VECTOR_ISR:
    JMP START

SWI2VECTOR_ISR:
    JMP [SWI2ADDR]
    
FIRQVECTOR_ISR:
    JMP [FIRQADDR]
    
IRQVECTOR_ISR:
    JMP [IRQADDR]
    
SWIVECTOR_ISR:
    JMP [SWIADDR]
    
NMIVECTOR_ISR:
    JMP [NMIADDR]
        
; ==================================================    
; DATA 
; ==================================================        
    
SIGNON .ascii "HD6309 Computer / Retrochallenge 2017/04"
       .db 13,10
       .ascii "By Niels Moseley "       
       .db 13,10
       .ascii "Bootloader v1.1 - expecting SREC"
       .db 13,10,13,10,0

SRECERRORSTR:
        .db 13,10
        .ascii "SREC checksum errors! Aborting."
EOLSTR:        
        .db 13,10,0

ADDRSTR:
        .db 13,10
        .ascii "Jumping to $"
        .db 0
; ==================================================    
; RESET AND INTERRUPT VECTOR TABLE
; ==================================================

    ORG $FFF2
SWI3VECTOR:  FDB SWI3VECTOR_ISR
SWI2VECTOR:  FDB SWI2VECTOR_ISR
FIRQVECTOR:  FDB FIRQVECTOR_ISR
IRQVECTOR:   FDB IRQVECTOR_ISR
SWIVECTOR:   FDB SWIVECTOR_ISR
NMIVECTOR:   FDB NMIVECTOR_ISR
RESETVECTOR: FDB START 
