;
; Example program for HD6309 computer
; Retro Challenge 2017/04
; Niels A. Moseley
; www.moseleyinstruments.com
;

; ==================================================
; SYSTEM CONSTANTS
; ==================================================

RAMSTART  EQU $0000
RAMEND    EQU $E000
STACK     EQU $DFF0

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

    ORG $0100   ; START OF RAM

    JMP __START
    
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
; START OF PROGRAM
; ==================================================
    
__START:
    LDS #STACK
    ORCC #%01010000 ; disable interrupts
    
    ; ****************************************
    ; init UART 
    ;   baud divisor to 48 -> 9600 baud
    ;   8 bits, 1 stop bit, no parity
    ; 
    ; ****************************************
    CLRA 
    STA SER_IER     ; no interrupts

    STA SER_FCR     ; no FIFO
  
    LDA #$83        ; 8 bits per symbol, no parity, enable baud reg access
    STA SER_LCR     ;   line control
 
    LDA #$4         ; set at least one led to ON
    STA SER_MCR     ;   modem control
   
    LDA #48
    STA SER_DLL
   
    CLRA
    STA SER_DLM
 
    LDA #$03        ; 8 bits per symbol, no parity, disable baud reg access
    STA SER_LCR
 
    LDX #BANNER
    JSR PRINTSTRING

SPIN:
    JMP SPIN
    
BANNER:
    .ascii "             __   __ _____  _   _ ______                 "
    .db 13,10
    .ascii "             \ \ / /|  _  || | | || ___ \                "
    .db 13,10
    .ascii "              \ V / | | | || | | || |_/ /                "
    .db 13,10
    .ascii "               \ /  | | | || | | ||    /                 "
    .db 13,10
    .ascii "               | |  \ \_/ /| |_| || |\ \                 "
    .db 13,10
    .ascii " _____  _____ _\_/ __\___/__\___/ \_|_\_|_  _____ ______ "
    .db 13,10
    .ascii "/  __ \|  _  ||  \/  || ___ \| | | ||_   _||  ___|| ___ \"
    .db 13,10
    .ascii "| /  \/| | | || .  . || |_/ /| | | |  | |  | |__  | |_/ /"
    .db 13,10
    .ascii "| |    | | | || |\/| ||  __/ | | | |  | |  |  __| |    / "
    .db 13,10
    .ascii "| \__/\\ \_/ /| |  | || |    | |_| |  | |  | |___ | |\ \ "
    .db 13,10
    .ascii " \____/ \___/ \_|  |_/\_|_  __\___/   \_/  \____/ \_| \_|"
    .db 13,10
    .ascii "                    |_   _|/  ___|                       "
    .db 13,10
    .ascii "                      | |  \ `--.                        "
    .db 13,10
    .ascii "                      | |   `--. \                       "
    .db 13,10
    .ascii "                     _| |_ /\__/ /                       "
    .db 13,10
    .ascii "   _    _  _____ ____\___/ \____/____  _   _  _____  _   "
    .db 13,10
    .ascii "  | |  | ||  _  || ___ \| | / /|_   _|| \ | ||  __ \| |  "
    .db 13,10
    .ascii "  | |  | || | | || |_/ /| |/ /   | |  |  \| || |  \/| |  "
    .db 13,10
    .ascii "  | |/\| || | | ||    / |    \   | |  | . ` || | __ | |  "
    .db 13,10
    .ascii "  \  /\  /\ \_/ /| |\ \ | |\  \ _| |_ | |\  || |_\ \|_|  "
    .db 13,10
    .ascii "   \/  \/  \___/ \_| \_|\_| \_/ \___/ \_| \_/ \____/(_)  "
    .db 13,10,0