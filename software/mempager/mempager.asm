;
; Test for the paging mechanism of the HD6309 computer
;
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

; run program in non-paged part of memory!
    ORG $8000
    
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
; START OF PROGRAM
; ==================================================
    
__START:    
    LDS #STACK
    ORCC #%01010000 ; disable interrupts
    
    LDA #$00
    STA PAGEREG
    
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
    
    ; ==================================================
    ; Write + read to page 2
    ; ==================================================
    ; set page register
    LDA #$02
    STA PAGEREG

    LDX #TEXT1
    JSR PRINTSTRING
    
    LDA #$FF
    STA $0000
    LDX #WRITETEXT
    JSR PRINTSTRING
    JSR PRINTAHEX
    LDX #EOLSTR
    JSR PRINTSTRING
    
    LDA $0000
    LDX #READTEXT
    JSR PRINTSTRING
    JSR PRINTAHEX    
    LDX #EOLSTR    
    JSR PRINTSTRING
    CMPA #$FF
    BNE PAGE_ERROR    

    ; ==================================================
    ; Write + read to page 0
    ; ==================================================    
    ; set page register
    LDA #$00
    STA PAGEREG

    LDX #TEXT0
    JSR PRINTSTRING
    
    LDA #$AA
    STA $0000
    LDX #WRITETEXT
    JSR PRINTSTRING
    JSR PRINTAHEX
    LDX #EOLSTR
    JSR PRINTSTRING    
    
    LDA $0000
    LDX #READTEXT
    JSR PRINTSTRING
    JSR PRINTAHEX
    LDX #EOLSTR
    JSR PRINTSTRING     
    CMPA #$AA
    BNE PAGE_ERROR
   
    
    ; ==================================================
    ; Read again from page 2
    ; ==================================================    
    ; set page register
    LDA #$02
    STA PAGEREG

    LDX #TEXT1
    JSR PRINTSTRING
    
    LDA $0000
    LDX #READTEXT
    JSR PRINTSTRING
    JSR PRINTAHEX
    CMPA #$FF
    BNE PAGE_ERROR    
    LDX #EOLSTR
    JSR PRINTSTRING
    JMP MEMTEST
    
PAGE_ERROR:
    LDX #PAGEERRORSTR
    JSR PRINTSTRING
    JMP QUIT    
    
    ; ==================================================
    ; Perform exhaustive memory test
    ; ================================================== 
MEMTEST:    
    CLRB        ; page ID
    
NEXTPAGE:
    CMPB #1     ; don't check page 1 because
                ; that's where the program is running!
    BEQ SKIPPAGE
    CMPB #32    ; no more than 32 pages!
    BHS DONE
    STB PAGEREG
    LDX #CHECKSTR
    JSR PRINTSTRING
    TFR B,A
    JSR PRINTAHEX
    LDA #13
    JSR OUTCHAR
    
    LDX #$0000    
NEXTBYTE:
    LDA #$AA
    STA ,X
    LDA ,X
    CMPA #$AA
    BNE MEM_ERROR
    LDA #$55
    STA ,X
    LDA ,X+
    CMPA #$55
    BNE MEM_ERROR    
    CMPX #$8000
    BNE NEXTBYTE
SKIPPAGE:
    INCB
    JMP NEXTPAGE
    
DONE:
    LDX #DONESTR
    JSR PRINTSTRING
    JMP QUIT
        
MEM_ERROR:
    LDX #MEMERRORSTR
    JSR PRINTSTRING
    JMP QUIT
    
; ==================================================
; Program end
; ==================================================     
    
QUIT:
    JMP QUIT

; ==================================================
; Strings
; ==================================================         
    
TEXT0:    
    .ascii "Page register set to 0."
    .db 13,10,0    
    
TEXT1:    
    .ascii "Page register set to 2."
    .db 13,10,0

PAGEERRORSTR:
    .ascii "Paging error!"
    .db 13,10,0

MEMERRORSTR:
    .ascii "Memory error!"
    .db 13,10,0

CHECKSTR:
    .asciz "Checking page $"
    
DONESTR:
    .ascii "Done: memory ok!"
    .db 13,10,0
    
READTEXT:
    .asciz "Data read as: $"

WRITETEXT:
    .asciz "Data written: $"

EOLSTR:
    .db 13,10,0
    