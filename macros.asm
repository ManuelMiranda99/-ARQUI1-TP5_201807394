; PRINT ON THE SCREEN
print macro string
    Pushear
    mov ah, 09h             ; PRINT
    mov dx, offset string
    int 21h
    Popear
endm

; GET CHARACTER
getChar macro    
    mov ah, 01h
    int 21h
endm

; CLEAN STRING
Clean macro string, numBytes, char
    local RepeatLoop
    Pushear
    xor si, si
    xor cx, cx
    mov cx, numBytes
    RepeatLoop:
        mov string[si], char
        inc si
    Loop RepeatLoop
    Popear
endm

; GET TEXT UNTIL THE USER WRITE ENTER
getText macro string
    local getCharacter, EndGC, Backspace
    Pushear
    xor si, si

    getCharacter:
        getChar
        cmp al, 0dh
            je EndGC
        cmp al, 08h
            je Backspace
        mov string[si], al
        inc si
        jmp getCharacter
    Backspace:
        mov al, 24h
        dec si
        mov string[si], al
        jmp getCharacter
    EndGC:        
        mov al, 24h
        mov string[si], al
        Popear
endm

; Move cursor
; The screen in text mode have 25 rows and 80 columns
moveCursor macro row, column
    Pushear
    mov ah, 02h
    mov dh, row
    mov dl, column
    int 10h
    Popear
endm

; CLEAN CONSOLE
ClearConsole macro
    local ClearConsoleRepeat
    Pushear
    mov dx, 50h
    ClearConsoleRepeat:
        print newLine
    Loop ClearConsoleRepeat
    moveCursor 00h, 00h
    Popear
endm

printPixel macro x, y, color
    Pushear

    mov ah, 0ch
    mov al, color
    mov bh, 0h
    mov dx, y
    mov cx, x

    int 10h

    Popear
endm

ConcatText macro string1, string2, numBytes
    local RepeatConcat, EndGC

    xor di, di
    mov cx, numBytes
    RepeatConcat:
        mov al, string2[di]
        cmp al, 24h
            je EndGC
        inc di
        mov string1[si], al
        inc si
    Loop RepeatConcat
    EndGC:
endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;;\\\\\\\\\\\\\\     FUNCTIONS    \\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    getOFunction macro string
        local X4, X3, X2, X1, X0
        Pushear

        xor si, si
        
        ConcatText string, msgFunctionM, SIZEOF msgFunctionM
                
        X4:
            ConcatText string, valueX4, SIZEOF valueX4

            mov string[si], 78h         ; x
            inc si
            mov string[si], 34h         ; 4
            inc si

        X3:

            mov string[si], 2bh         ; +
            inc si

            ConcatText string, valueX3, SIZEOF valueX3

            mov string[si], 78h         ; x
            inc si
            mov string[si], 33h         ; 3
            inc si

        X2:

            mov string[si], 2bh         ; +
            inc si

            ConcatText string, valueX2, SIZEOF valueX2

            mov string[si], 78h         ; x
            inc si
            mov string[si], 32h         ; 2
            inc si

        X1:

            mov string[si], 2bh         ; +
            inc si

            ConcatText string, valueX1, SIZEOF valueX1

            mov string[si], 78h         ; x
            inc si
            mov string[si], 31h         ; 1
            inc si

        X0:

            mov string[si], 2bh         ; +
            inc si

            ConcatText string, valueX0, SIZEOF valueX0

        Popear
    endm

    getDFunction macro string

    endm

    getIFunction macro string

    endm

    valueOFunction macro

    endm

    valueDFunction macro

    endm

    valueIFunction macro

    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;;\\\\\\\\\\\\\\\\  CALCULATOR  \\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    AnalizeText macro file

    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;;\\\\\\\\\\\\\\\\     GRAPH    \\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    GraphAxis macro
        local x_axis, y_axis

        mov cx, 13eh
        x_axis:
            printPixel cx, 5fh, 4fh
        Loop x_axis
        mov cx, 0c6h
        y_axis:
            printPixel 9fh, cx, 4fh
        Loop y_axis
    endm

    GraphOriginalMacro macro

    endm

    GraphDerivedMacro macro

    endm

    GraphIntegralMacro macro

    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\     FILES     \\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ; GET ROUTE OF A FILE
    getRoute macro string
        local getCharacter, EndGC, Backspace
        Pushear
        xor si, si
        getCharacter:
            getChar
            ; If al == \n
            cmp al, 0dh
                je EndGC
            ; If al == \b
            cmp al, 08h
                je Backspace
            ; else
            mov string[si], al
            inc si
            jmp getCharacter
        Backspace:
            mov al, 24h
            dec si
            mov string[si], al
            jmp getCharacter
        EndGC:        
            mov al, 00h
            mov string[si], al
            Popear
    endm

    ; OPEN FILE
    OpenFile macro route, handler
        Pushear
        mov ah, 3dh
        mov al, 020h
        lea dx, route
        int 21h
        mov handler, ax
        ; JUMP IF AN ERROR OCCURRED WHILE OPENING THE FILE
        jc OpenError    
        Popear
    endm

    ; CLOSE FILE
    CloseFile macro handler
        mov ah, 3eh
        mov bx, handler
        int 21h
        ; JUMP IF THE FILE DOESNT CLOSE FINE
        jc CloseError
    endm

    ; CREATE FILE
    CreateFile macro string, handler
        mov ah, 3ch
        mov cx, 00h
        lea dx, string
        int 21h
        mov handler, ax
        ; JUMP IF AN ERROR OCCURS WHILE CREATING THE FILE
        jc CreateError    
    endm

    ; WRITE ON FILE
    WriteOnFile macro handler, info, numBytes
        PUSH ax
        PUSH bx
        PUSH cx
        PUSh dx
        
        mov ah, 40h
        mov bx, handler
        mov cx, numBytes
        lea dx, info
        int 21h
        ; JUMP IF AN ERROR OCCURS DURING WRITING IN THE FILE
        jc WriteError

        POP dx
        POP cx
        POP bx
        POP ax
    endm

    ; READ FILE
    ReadFile macro handler, info, numBytes    
        mov ah, 3fh
        mov bx, handler
        mov cx, numBytes
        lea dx, info
        int 21h    
        jc ReadError
    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\ GET DATE \\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ; PRINCIPAL MACRO FOR DATE AND HOUR
    getDateAndHour macro stringDate, stringHour
        
        Pushear
        xor si, si

        getDate
        ; DL = DAY. DH = MONTH

        ConvertToString stringDate, dl ; NUMBER -> STRING. DAY

        mov stringDate[si], 2fh ; /
        inc si

        ConvertToString stringDate, dh ; NUMBER -> STRING. MONTH

        mov stringDate[si], 2fh ; /
        inc si

        mov stringDate[si], 32h ; 2
        inc si

        mov stringDate[si], 30h ; 0
        inc si

        mov stringDate[si], 32h ; 2
        inc si

        mov stringDate[si], 30h ; 0
        inc si

        mov stringDate[si],20h
        inc si
        mov stringDate[si],20h
        inc si

        getHour
        ; CH = HOUR. CL = MINUTES.
        
        ConvertToString stringDate, ch ; NUMBER -> STRING. HOUR

        mov stringDate[si],3ah ; :
        inc si

        ConvertToString stringDate, cl ; NUMBER -> STRING. MINUTES

        mov stringDate[si],3ah ; :
        inc si

        ConvertToString stringDate, dh ; NUMBER -> STRING. SECONDS

        Popear
    endm

    ; GET DATE
    getDate macro 
        mov ah, 2ah
        int 21h
    endm

    ; GET HOUR
    getHour macro
        mov ah, 2ch
        int 21h
    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\ Conversions \\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ConvertToNumber macro string
        local Begin, EndGC
        
        xor ax, ax
        xor bx, bx
        xor cx, cx
        mov bx, 10
        xor si, si
        
        Begin:
            mov cl, string[si]
            ; If the ascii is less than the ascii of 0
            cmp cl, 48
                jl EndGC
            ; If the ascii is more than the ascii of 9
            cmp cl, 57
                jg EndGC
            inc si
            sub cl, 48  ; Subtract 48 to get the number
            mul bx      ; Multiply by 10
            add ax, cx

            jmp Begin  
        
        EndGC:
            ; The string converted to number is in the registry ax
    endm

    ConvertToString macro string, numberToConvert
        Push ax
        Push bx

        xor ax, ax
        xor bx, bx
        mov bl, 0ah
        mov al, numberToConvert
        div bl

        getNumber string, al
        getNumber string, ah

        Pop ax
        Pop bx
    endm


    getNumber macro string, numberToConvert
        local zero, one, two, three, four, five, six, seven, eight, nine
        local EndGC

        cmp numberToConvert, 00h
            je zero
        cmp numberToConvert, 01h
            je one
        cmp numberToConvert, 02h
            je two
        cmp numberToConvert, 03h
            je three
        cmp numberToConvert, 04h
            je four
        cmp numberToConvert, 05h
            je five
        cmp numberToConvert, 06h
            je six
        cmp numberToConvert, 07h
            je seven
        cmp numberToConvert, 08h
            je eight
        cmp numberToConvert, 09h
            je nine
        jmp EndGC

        zero:
            mov string[si], 30h
            inc si
            jmp EndGC
        one:
            mov string[si], 31h
            inc si
            jmp EndGC
        two:
            mov string[si], 32h
            inc si
            jmp EndGC
        three:
            mov string[si], 33h
            inc si
            jmp EndGC
        four:
            mov string[si], 34h
            inc si
            jmp EndGC
        five:
            mov string[si], 35h
            inc si
            jmp EndGC
        six:
            mov string[si], 36h
            inc si
            jmp EndGC
        seven:
            mov string[si], 37h
            inc si
            jmp EndGC
        eight:
            mov string[si], 38h
            inc si
            jmp EndGC
        nine:
            mov string[si], 39h
            inc si
            jmp EndGC
        EndGC:
    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\ RECOVER THINGS \\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    Pushear macro
        push ax
        push bx
        push cx
        push dx
        push si
        push di
    endm

    Popear macro                    
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
    endm