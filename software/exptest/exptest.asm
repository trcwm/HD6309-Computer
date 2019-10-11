; HD6309 Computer expansion port test
;
; Retro Challenge 2019/10
; Niels A. Moseley
; www.moseleyinstruments.com
;

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
    
    CMPA #'R'
    BEQ PORT_READ
    
    CMPA #'W'
    BEQ PORT_WRITE

    LDX #HUH        ; error -> invalid command
    JSR PRINTSTRING
    JSR OUTCHAR     ; print command char
    LDA #39         ; apostrophe
    JSR OUTCHAR
    LDX #EOLSTR
    JSR PRINTSTRING
    JMP CMDAGAIN

PORT_READ:
    LDX #IOPORT
    LDA 0,X
    LDX #PORTTXT
    JSR PRINTSTRING
    JSR PRINTAHEX
    LDX #EOLSTR
    JSR PRINTSTRING
    JMP CMDAGAIN

PORT_WRITE:
    LDX #IOPORT
    STB 0,X
    LDX #PORTTXT2
    JSR PRINTSTRING
    TFR B,A
    JSR PRINTAHEX
    LDX #EOLSTR
    JSR PRINTSTRING
    INCB
    JMP CMDAGAIN

BANNER .ascii "HD6309 I/O port test"
       .db 10,13,0

ASK    .ascii "Press R for READ - W for WRITE"
       .db 10,13,0

HUH    .ascii "Invalid command '"
       .db 0

PORTTXT .ascii  "Read  : "
        .db 0

PORTTXT2 .ascii "Write : "
         .db 0

EOLSTR .db 10,13,0
