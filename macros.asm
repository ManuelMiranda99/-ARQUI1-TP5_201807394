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
    xor si, si
    xor ax, ax
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

TestingAX macro

    xor di, di
    mov testing[di], ah
    inc di
    mov testing[di], al

    print testing
    Push ax
    getChar
    Pop ax

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

            mov string[si], 58h         ; X
            inc si
            mov string[si], 34h         ; 4
            inc si

        X3:

            mov string[si], 2bh         ; +
            inc si

            ConcatText string, valueX3, SIZEOF valueX3

            mov string[si], 58h         ; X
            inc si
            mov string[si], 33h         ; 3
            inc si

        X2:

            mov string[si], 2bh         ; +
            inc si

            ConcatText string, valueX2, SIZEOF valueX2

            mov string[si], 58h         ; X
            inc si
            mov string[si], 32h         ; 2
            inc si

        X1:

            mov string[si], 2bh         ; +
            inc si

            ConcatText string, valueX1, SIZEOF valueX1

            mov string[si], 58h         ; X
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
        local X3, X2, X1, X0
        Pushear

        xor si, si

        ConcatText string, msgDerived, SIZEOF msgDerived

        ; X4 -> X3
        X3:
            ConvertToNumber valueX4     ; Value in ax        

            mov bx, 04h

            mul bx                      ; AX = valueX4 * 4

            ConvertToString valueXD3

            ConcatText string, valueXD3, SIZEOF valueXD3

            mov string[si], 58h         ; X
            inc si
            mov string[si], 33h         ; 3
            inc si

        ; X3 -> X2
        X2:
            ConvertToNumber valueX3     ; Value in ax        

            mov bx, 03h

            mul bx                      ; AX = valueX3 * 3

            ConvertToString valueXD2

            mov string[si], 2bh         ; +
            inc si

            ConcatText string, valueXD2, SIZEOF valueXD2

            mov string[si], 58h         ; X
            inc si
            mov string[si], 32h         ; 2
            inc si

        ; X2 -> X1
        X1:
            ConvertToNumber valueX2     ; Value in ax        

            mov bx, 02h

            mul bx                      ; AX = valueX3 * 2

            ConvertToString valueXD1

            mov string[si], 2bh         ; +
            inc si

            ConcatText string, valueXD1, SIZEOF valueXD1

            mov string[si], 58h         ; X
            inc si
            mov string[si], 31h         ; 1
            inc si        
        
        ; X1 -> X0
        X0:
            ConvertToNumber valueX1     ; Value in ax        

            ConvertToString valueXD0

            mov string[si], 2bh         ; +
            inc si

            ConcatText string, valueXD0, SIZEOF valueXD0

        Popear
    endm

    getIFunction macro string
        local X5, NegativeX5, FollowX5, EndNegX5, EndPosX5, X4, NegativeX4, FollowX4, EndNegX4, EndPosX4, X3, NegativeX3, FollowX3, EndNegX3, EndPosX3, X2, NegativeX2, FollowX2, EndNegX2, EndPosX2, X1, NegativeX1, FollowX1, EndNegX5, EndPosX5, X0, NegativeX0, FollowX0
        Pushear

        xor si, si

        ConcatText string, msgIntegral, SIZEOF msgIntegral

        ; X4 -> X5
        X5:
            ConvertToNumber valueX4
            xor di, di

            test ax, 1000000000000000b
                jnz NegativeX5
            jmp FollowX5
            
            NegativeX5:
                neg ax
            FollowX5:
            mov bl, 05h

            div bl

            ConvertToString valueXI5

            ConcatText string, valueX4, SIZEOF valueX4

            mov string[si], 2fh             ; /
            inc si
            mov string[si], 35h             ; 5
            inc si
            mov string[si], 58h             ; X
            inc si
            mov string[si], 35h             ; 5
            inc si

        ; X3 -> X4
        X4:
            mov string[si], 2bh         ; +
            inc si

            ConvertToNumber valueX3

            test ax, 1000000000000000b
                jnz NegativeX4
            jmp FollowX4
            
            NegativeX4:
                neg ax
            FollowX4:
            mov bl, 04h

            div bl

            xor ah, ah

            ConvertToString valueXI4

            ConcatText string, valueX3, SIZEOF valueX3

            mov string[si], 2fh             ; /
            inc si
            mov string[si], 34h             ; 4
            inc si
            mov string[si], 58h             ; X
            inc si
            mov string[si], 34h             ; 4
            inc si

        ; X2 -> X3
        X3:
            mov string[si], 2bh         ; +
            inc si

            ConvertToNumber valueX2

            test ax, 1000000000000000b
                jnz NegativeX3
            jmp FollowX3
            
            NegativeX3:
                neg ax
            FollowX3:
            mov bl, 03h

            div bl

            xor ah, ah

            ConvertToString valueXI3

            ConcatText string, valueX2, SIZEOF valueX2

            mov string[si], 2fh             ; /
            inc si
            mov string[si], 33h             ; 3
            inc si
            mov string[si], 58h             ; X
            inc si
            mov string[si], 33h             ; 3
            inc si

        ; X1 -> X2
        X2:
            mov string[si], 2bh         ; +
            inc si

            ConvertToNumber valueX1

            test ax, 1000000000000000b
                jnz NegativeX2
            jmp FollowX2
            
            NegativeX2:
                neg ax
            FollowX2:
            mov bl, 02h

            div bl

            xor ah, ah

            ConvertToString valueXI2

            ConcatText string, valueX1, SIZEOF valueX1

            mov string[si], 2fh             ; /
            inc si
            mov string[si], 32h             ; 2
            inc si
            mov string[si], 58h             ; X
            inc si
            mov string[si], 32h             ; 2
            inc si


        ; X0 -> X1
        X1:
            mov string[si], 2bh         ; +
            inc si

            ConvertToNumber valueX0

            ConvertToString valueXI1

            ConcatText string, valueX0, SIZEOF valueX0

            mov string[si], 58h             ; X
            inc si
            mov string[si], 31h             ; 1
            inc si


        ; +C
        X0:
            ConcatText string, msgC, SIZEOF msgC

        Popear
    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;;\\\\\\\\\\\\\\\\  CALCULATOR  \\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    AnalizeText macro file
        local StartA, EndGC, EndOperators, InvalidSymbol, CheckEnd, Symbol, Space, SecondAnalize, SymbolPass, SpacePass, InvalidSymbolPass

        xor si, si
        xor ax, ax
        mov si, SIZEOF file

        mov cx, SIZEOF file

        CheckEnd:
            dec si
            mov al, file[si]
            cmp al, ';'
                je StartA
        Loop CheckEnd

        jmp NoEndCharError
        
        StartA:            
            Clean operands, SIZEOF operands, '$'
            Clean operators, SIZEOF operators, '$'
            xor si, si
            xor cx, cx
            ; For the array of operators
            xor di, di

            
        StartAnalize:
            mov al, file[si]

            cmp al, '+'
                je Symbol
            cmp al, '-'
                je Symbol
            cmp al, '*'
                je Symbol
            cmp al, '/'
                je Symbol
            cmp al, ' '
                je Space
            cmp al, ';'
                je EndOperators
            ; If the ascii is less than the ascii of 0
            cmp al, 48
                jl InvalidSymbol
            ; If the ascii is more than the ascii of 9
            cmp al, 57
                jg InvalidSymbol
            ; NUMBER
            inc si
            jmp StartAnalize
        Symbol:
            inc si
            mov operators[di], al
            inc di
            jmp StartAnalize
        Space:
            inc si
            jmp StartAnalize
        InvalidSymbol:
            Push di

            xor di, di
            
            mov cl, al
            mov charI[di], cl
            
            print invalidCharE
            print charI
            getChar
            
            Pop di
            inc si
            jmp StartAnalize

        EndOperators:
            xor si, si
            xor ax, ax
            xor cx, cx
            ; For the array of operands
            xor di, di
            
        SecondAnalize:
            mov al, file[si]

            ; Symbols pass
                cmp al, '+'
                    je SymbolPass
                cmp al, '-'
                    je SymbolPass
                cmp al, '*'
                    je SymbolPass
                cmp al, '/'
                    je SymbolPass
                cmp al, ' '
                    je SpacePass
                cmp al, ';'
                    je EndGC
                ; If the ascii is less than the ascii of 0
                cmp al, 48
                    jl InvalidSymbolPass
                ; If the ascii is more than the ascii of 9
                cmp al, 57
                    jg InvalidSymbolPass
            ; NUMBER            
                inc si
                ; Al -> x10. Ah -> x1.
                mov ah, file[si]

                Push di

                xor di, di

                Clean auxInt, SIZEOF auxInt, '$'

                mov auxInt[di], al
                inc di
                mov auxInt[di], ah

                Pop di

                ConvertToNumber auxInt                

                mov operands[di], ax

                inc di
                inc di
                inc si
                
            jmp SecondAnalize
        SymbolPass:
            inc si            
            jmp SecondAnalize
        SpacePass:
            inc si
            jmp SecondAnalize
        InvalidSymbolPass:        
            inc si
            jmp SecondAnalize

        EndGC:
            cmp charI[00h], 00h
                jne Start
            mov operands[di], 4fh    ; O
            inc di
            inc di
            mov operands[di], 54h   ; T
            inc di
            inc di
            mov operands[di], 54h   ; T
            inc di
            inc di
            mov operands[di], 4fh    ; O
            OperateMacro
    endm

    OperateMacro macro
        local EndGC, Division, Multiplication, Subtraction, Addition
        ; operators --- operands

        xor si, si
        xor di, di
        
        mov cx, SIZEOF operators
        Division:
            mov al, operators[si]
            cmp al, '/'
                je MakeDivision
            cmp al, '$'
                je EndDiv
            jmp NextDiv

            MakeDivision:
                xor dx, dx     
                mov ax, operands[di]

                inc di
                inc di
                mov bx, operands[di]

                div bx                  ; Operands[di] / Operands[di+1]                
                
                Clean auxInt, SIZEOF auxInt, '$'

                ConvertToString auxInt

                ConvertToNumber auxInt

                dec di
                dec di
                mov operands[di], ax

                inc di
                inc di

                ; Move array
                MoveArrays

                ;print operators
                ;print newLine
                ;print operands
                ;getChar

                dec si
                dec di
                dec di

            NextDiv:
                inc di
                inc di
        dec cx
            jne Division 
        
        EndDiv:

        xor si, si
        xor di, di
        
        mov cx, SIZEOF operators
        Multiplication:
            mov al, operators[si]
            cmp al, '*'
                je MakeMultiplication
            cmp al, '$'
                je EndMul
            jmp NextMul

            MakeMultiplication:
                xor dx, dx
                mov ax, operands[di]

                inc di
                inc di
                mov bx, operands[di]

                mul bx

                Clean auxInt, SIZEOF auxInt, '$'

                ConvertToString auxInt

                ConvertToNumber auxInt

                dec di
                dec di
                mov operands[di], ax

                inc di
                inc di

                ; Move array
                MoveArrays

                ;print operators
                ;print newLine
                ;print operands
                ;getChar

                dec di
                dec di
            NextMul:
                inc si
                inc di
                inc di
        dec cx
            jne Multiplication

        EndMul:

        xor si, si
        xor di, di
        
        mov cx, SIZEOF operators
        Subtraction:
            mov al, operators[si]
            cmp al, '-'
                je MakeSub
            cmp al, '$'
                je EndSub
            jmp NextSub

            MakeSub:
                xor dx, dx
                mov ax, operands[di]

                inc di
                inc di
                mov bx, operands[di]

                sub ax, bx

                dec di
                dec di
                mov operands[di], ax

                inc di
                inc di

                ; Move array
                MoveArrays

                ;print operators
                ;print newLine
                ;print operands
                ;getChar

                dec di
                dec di
            NextSub:
                inc si
                inc di
                inc di
        dec cx
            jne Subtraction

        EndSub:

        xor si, si
        xor di, di
        
        mov cx, SIZEOF operators
        Addition:
            mov al, operators[si]
            cmp al, '+'
                je MakeAdd
            cmp al, '$'
                je EndAdd
            jmp NextAdd

            MakeAdd:
                xor dx, dx
                mov ax, operands[di]

                inc di
                inc di
                mov bx, operands[di]

                add ax, bx

                dec di
                dec di
                mov operands[di], ax

                inc di
                inc di

                ; Move Array
                MoveArrays

                ;print operators
                ;print newLine
                ;print operands
                ;getChar

                dec di
                dec di

            NextAdd:
                inc si
                inc di
                inc di
        dec cx
            jne Addition

        EndAdd:
        xor di, di
        mov ax, operands[di]
        Clean auxInt, SIZEOF auxInt, '$'
        ConvertToString auxInt
        print resultMsg
        print auxInt
        getChar
    endm

    MoveArrays macro
        local OperatorsLoop, OperandsLoop, EndOperatorsLoop, EndOperandsLoop, EndGC
        Pushear

        mov cx, SIZEOF operators
        OperatorsLoop:
            mov al, operators[si]
            cmp al, '$'
                je EndOperatorsLoop
            mov al, operators[si+1]
            mov operators[si], al
            inc si

        Loop OperatorsLoop

        EndOperatorsLoop:
            xor cx, cx

        mov cx, SIZEOF operands
        OperandsLoop:
            mov ax, operands[di]
            mov ax, operands[di+2]
            mov operands[di], ax
            inc di
            inc di
        Loop OperandsLoop

        jmp EndGC
        EndGC:
        Popear
    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;;\\\\\\\\\\\\\\\\     GRAPH    \\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    GraphAxis macro
        local x_axis, y_axis

        mov cx, 13eh
        x_axis:
            printPixel cx, 63h, 4fh
        Loop x_axis
        mov cx, 0c6h
        y_axis:
            printPixel 9fh, cx, 4fh
        Loop y_axis
    endm

    GraphOriginalMacro macro inferior, superior
        local Follow, NegativeInferior, RepeatNegative, RepeatPositive, NegativeXN, PositiveXN, PrintN, NegativeXP, PositiveXP, PrintP, EndOfLoopNeg, EndOfLoopPos
        Pushear

        xor si, si
        xor di, di
        xor ax, ax
        xor bx, bx
        xor cx, cx

        ConvertToNumber inferior

        test ax, 1000000000000000b
            jnz NegativeInferior
        jmp Follow

        NegativeInferior:
            neg ax

        Follow:
        mov cx, ax

        ; -X
        RepeatNegative:
            Push cx                 ; Save the value of cx                                              (1)

            ; X4
                MultiplyXsTimes cx, 03h

                Push ax                 ; Save the value of X^4

                ConvertToNumber valueX4 ; Convert the coefficient D x^4

                mov bx, ax              ; Move the result of the conversion to bx

                Pop ax                  ; Restore the value of ax

                mul bx                  ; Multiply by the coefficient the value of ax

                Pop cx                  ; Restore the value for the Loop                                (1)
            ;
            Push ax                 ; Save the value of DX^4

            Push cx                 ; Save the value of cx for the loop                                 (2)
            
            ; X3
                MultiplyXsTimes cx, 02h

                neg ax

                Push ax                 ; Save the value of X^3

                ConvertToNumber valueX3 ; Convert the coefficient C x^3

                mov bx, ax              ; Move the result of the conversion

                Pop ax                  ; Restore the value of ax

                mul bx                  ; Multiply by the coefficient the value of ax

                Pop cx                  ; Restore the value for the loop                                (2)

            ; Move the value of CX^3 to bx
            mov bx, ax

            Pop ax                      ; Restore the value of ax
            
            add ax, bx                  ; AX = DX^4 + CX^3

            Push ax                     ; Save the value of DX^4 + CX^3

            Push cx                      ; Save the value of cx for the loop                            (3)

            ; X2
                MultiplyXsTimes cx, 01h

                Push ax                 ; Save the value of X^2

                ConvertToNumber valueX2 ; Convert the coefficient B x^2

                mov bx, ax              ; Move the result of the conversion to bx

                Pop ax                  ; Restore the value of ax

                mul bx                  ; Multiply by the coefficient the value of ax

                Pop cx                  ; Restore the value for the loop                                (3)

            ; Move the value of BX^2 to bx
            mov bx, ax

            Pop ax                      ; Restore the value of ax
            
            add ax, bx                  ; AX = DX^4 + CX^3 + BX^2

            Push ax                     ; Save the value of DX^4 + CX^3 + BX^2

            Push cx                      ; Save the value of cx for the loop                            (4)           
            ; X1
                ConvertToNumber valueX1 ; Convert the coefficient A x^1

                Pop cx                  ; Restore the value of cx                                       (4)
                
                Push cx
                
                neg cx

                mul cx                  ; Multiply by the value of cx (x)

                Pop cx

            ; Move the value of AX^1 to bx
            mov bx, ax

            Pop ax                      ; Restore the value of ax

            add ax, bx                  ; AX = DX^4 + CX^3 + BX^2 + AX^1

            Push ax                     ; Save the value of ax

            Push cx                     ;                                                               (5)
            ; X0
                ConvertToNumber valueX0 ; Convert the coefficient E

                mov bx, ax

                Pop cx                  ;                                                               (5)

            Pop ax

            add ax, bx

            ; Print pixels
            
            ; X axis
            mov bx, 9fh
            sub bx, cx

            test ax, 1000000000000000b
                jnz NegativeXN
            jmp PositiveXN

            NegativeXN:
                neg ax
                ; Y axis
                mov dx, 63h
                add dx, ax
                jmp PrintN
            PositiveXN:
                ; Y axis
                mov dx, 63h
                sub dx, ax

            PrintN:                
                cmp ax, 63h
                    jae EndOfLoopNeg
                printPixel bx, dx, 4fh


            EndOfLoopNeg:
        dec cx
            jne RepeatNegative

        ConvertToNumber superior

        mov cx, ax

        ; +X
        RepeatPositive:
            Push cx                 ; Save the value of cx                                              (1)

            ; X4
                MultiplyXsTimes cx, 03h

                Push ax                 ; Save the value of X^4

                ConvertToNumber valueX4 ; Convert the coefficient D x^4

                mov bx, ax              ; Move the result of the conversion to bx

                Pop ax                  ; Restore the value of ax

                mul bx                  ; Multiply by the coefficient the value of ax

                Pop cx                  ; Restore the value for the Loop                                (1)
            ;
            Push ax                 ; Save the value of DX^4

            Push cx                 ; Save the value of cx for the loop                                 (2)
            
            ; X3
                MultiplyXsTimes cx, 02h

                Push ax                 ; Save the value of X^3

                ConvertToNumber valueX3 ; Convert the coefficient C x^3

                mov bx, ax              ; Move the result of the conversion

                Pop ax                  ; Restore the value of ax

                mul bx                  ; Multiply by the coefficient the value of ax

                Pop cx                  ; Restore the value for the loop                                (2)

            ; Move the value of CX^3 to bx
            mov bx, ax

            Pop ax                      ; Restore the value of ax
            
            add ax, bx                  ; AX = DX^4 + CX^3

            Push ax                     ; Save the value of DX^4 + CX^3

            Push cx                      ; Save the value of cx for the loop                            (3)

            ; X2
                MultiplyXsTimes cx, 01h

                Push ax                 ; Save the value of X^2

                ConvertToNumber valueX2 ; Convert the coefficient B x^2

                mov bx, ax              ; Move the result of the conversion to bx

                Pop ax                  ; Restore the value of ax

                mul bx                  ; Multiply by the coefficient the value of ax

                Pop cx                  ; Restore the value for the loop                                (3)

            ; Move the value of BX^2 to bx
            mov bx, ax

            Pop ax                      ; Restore the value of ax
            
            add ax, bx                  ; AX = DX^4 + CX^3 + BX^2

            Push ax                     ; Save the value of DX^4 + CX^3 + BX^2

            Push cx                      ; Save the value of cx for the loop                            (4)           
            ; X1
                ConvertToNumber valueX1 ; Convert the coefficient A x^1

                Pop cx                  ; Restore the value of cx                                       (4)

                mul cx                  ; Multiply by the value of cx (x)

            ; Move the value of AX^1 to bx
            mov bx, ax

            Pop ax                      ; Restore the value of ax

            add ax, bx                  ; AX = DX^4 + CX^3 + BX^2 + AX^1

            Push ax                     ; Save the value of ax

            Push cx                     ;                                                               (5)
            ; X0
                ConvertToNumber valueX0 ; Convert the coefficient E

                mov bx, ax

                Pop cx                  ;                                                               (5)

            Pop ax

            add ax, bx            
            
            ; Print pixels
            
            ; X axis
            mov bx, 9fh
            add bx, cx

            test ax, 1000000000000000b
                jnz NegativeXP
            jmp PositiveXP

            NegativeXP:
                neg ax
                ; Y axis
                mov dx, 63h
                add dx, ax
                jmp PrintP
            PositiveXP:
                ; Y axis
                mov dx, 63h
                sub dx, ax

            PrintP:                
                cmp ax, 63h
                    jae EndOfLoopPos
                printPixel bx, dx, 4fh


            EndOfLoopPos:
        dec cx
            jne RepeatPositive

        Popear
    endm

    GraphDerivedMacro macro inferior, superior
        local Follow, NegativeInferior, RepeatNegative, RepeatPositive, NegativeXN, PositiveXN, PrintN, NegativeXP, PositiveXP, PrintP, EndOfLoopNeg, EndOfLoopPos
        Pushear

        xor si, si
        xor di, di
        xor ax, ax
        xor bx, bx
        xor cx, cx

        ConvertToNumber inferior

        test ax, 1000000000000000b
            jnz NegativeInferior
        jmp Follow

        NegativeInferior:
            neg ax

        Follow:
        mov cx, ax

        ; -X
        RepeatNegative:
            Push cx                         ; Save the value of cx

            ; X3
                MultiplyXsTimes cx, 02h

                neg ax

                Push ax                     ; Save the value of X^3

                ConvertToNumber valueXD3    ; Convert the coefficient C x^3

                mov bx, ax

                Pop ax

                mul bx                      ; Multiply by CX^3                

                Pop cx                      ; Restore the value for the loop
            Push ax

            Push cx

            ; X2
                MultiplyXsTimes cx, 01h

                Push ax

                ConvertToNumber valueXD2

                mov bx, ax

                Pop ax

                mul bx

                Pop cx

            mov bx, ax

            Pop ax

            add ax, bx
            
            Push ax

            Push cx

            ; X1
                ConvertToNumber valueXD1 

                Pop cx                  
                
                Push cx
                
                neg cx

                mul cx                  

                Pop cx
            ; Move the value of AX^1 to bx
            mov bx, ax

            Pop ax                     

            add ax, bx                 

            Push ax                     

            Push cx                     
            ; X0
                ConvertToNumber valueXD0

                mov bx, ax

                Pop cx                  

            Pop ax

            add ax, bx

            ; Print pixels

            ; X axis
            mov bx, 9fh
            sub bx, cx

            test ax, 1000000000000000b
                jnz NegativeXN
            jmp PositiveXN

            NegativeXN:
                neg ax
                ; Y axis
                mov dx, 63h
                add dx, ax
                jmp PrintN
            PositiveXN:
                ; Y axis
                mov dx, 63h
                sub dx, ax

            PrintN:
                cmp ax, 63h
                    jae EndOfLoopNeg
                printPixel bx, dx, 4fh

            EndOfLoopNeg:
        dec cx
            jne RepeatNegative

        ConvertToNumber superior

        mov cx, ax

        ; +X
        RepeatPositive:
            Push cx                         ; Save the value of cx

            ; X3
                MultiplyXsTimes cx, 02h

                Push ax                     ; Save the value of X^3

                ConvertToNumber valueXD3    ; Convert the coefficient C x^3

                mov bx, ax

                Pop ax

                mul bx                      ; Multiply by CX^3

                Pop cx                      ; Restore the value for the loop
            Push ax

            Push cx

            ; X2
                MultiplyXsTimes cx, 01h

                Push ax

                ConvertToNumber valueXD2

                Mov bx, ax

                Pop ax

                mul bx

                Pop cx

            mov bx, ax

            Pop ax

            add ax, bx
            
            Push ax

            Push cx

            ; X1
                ConvertToNumber valueXD1 

                Pop cx                  
                
                Push cx
                
                mul cx                  

                Pop cx
            ; Move the value of AX^1 to bx
            mov bx, ax

            Pop ax                     

            add ax, bx                 

            Push ax                     

            Push cx                     
            ; X0
                ConvertToNumber valueXD0 

                mov bx, ax

                Pop cx

            Pop ax

            add ax, bx

            ; Print pixels

            ; X axis
            mov bx, 9fh
            add bx, cx

            test ax, 1000000000000000b
                jnz NegativeXP
            jmp PositiveXP

            NegativeXP:
                neg ax
                ; Y axis
                mov dx, 63h
                add dx, ax
                jmp PrintP
            PositiveXP:
                ; Y axis
                mov dx, 63h
                sub dx, ax

            PrintP:
                cmp ax, 63h
                    jae EndOfLoopPos
                printPixel bx, dx, 4fh

            EndOfLoopPos:
        dec cx
            jne RepeatPositive

        Popear
    endm

    GraphIntegralMacro macro inferior, superior
        local Follow, NegativeInferior, RepeatNegative, RepeatPositive, NegativeXN, PositiveXN, PrintN, NegativeXP, PositiveXP, PrintP, EndOfLoopNeg, EndOfLoopPos
        Pushear

        xor si, si
        xor di, di
        xor ax, ax
        xor bx, bx
        xor cx, cx

        ConvertToNumber inferior

        test ax, 1000000000000000b
            jnz NegativeInferior
        jmp Follow

        NegativeInferior:
            neg ax

        Follow:
        mov cx, ax

        ; -X
        RepeatNegative:
            Push cx

            ; X5
                MultiplyXsTimes cx, 04h

                neg ax

                Push ax

                ConvertToNumber valueXI5

                mov bx, ax

                Pop ax

                mul bx

                Pop cx
            Push ax

            Push cx

            ; X4
                MultiplyXsTimes cx, 03h

                Push ax

                ConvertToNumber valueXI4

                mov bx, ax

                Pop ax

                mul bx

                Pop cx
            mov bx, ax

            Pop ax

            add ax, bx

            Push ax

            Push cx

            ; X3
                MultiplyXsTimes cx, 02h

                neg ax

                Push ax

                ConvertToNumber valueXI3

                mov bx, ax

                Pop ax

                mul bx

                Pop cx

            mov bx, ax

            Pop ax

            add ax, bx

            Push ax

            Push cx

            ; X2
                MultiplyXsTimes cx, 01h

                Push ax

                ConvertToNumber valueXI2

                mov bx, ax

                Pop ax

                mul bx

                Pop cx

            mov bx, ax

            Pop ax

            add ax, bx

            Push ax

            Push cx

            ; X1
                ConvertToNumber valueXI1

                Pop cx

                Push cx

                neg cx

                mul cx

                Pop cx

            mov bx, ax

            Pop ax

            add ax, bx

            Push ax

            Push cx

            ; XO
                ConvertToNumber valueXI0
                mov bx, ax

                Pop cx

            Pop ax

            add ax, bx

            ; Print pixels

            ; X axis
            mov bx, 9fh
            sub bx, cx

            test ax, 1000000000000000b
                jnz NegativeXN
            jmp PositiveXN

            NegativeXN:
                neg ax
                ; Y axis
                mov dx, 63h
                add dx, ax
                jmp PrintN
            PositiveXN:
                ; Y axis
                mov dx, 63h
                sub dx, ax
            
            PrintN:
                cmp ax, 63h
                    jae EndOfLoopNeg
                printPixel bx, dx, 4fh

            EndOfLoopNeg:
        dec cx
            jne RepeatNegative
        
        ConvertToNumber superior

        mov cx, ax

        ; +X
        RepeatPositive:
            Push cx            

            ; X5
                MultiplyXsTimes cx, 04h

                Push ax

                ConvertToNumber valueXI5

                mov bx, ax

                Pop ax

                mul bx

                Pop cx
            Push ax

            Push cx

            ; X4
                MultiplyXsTimes cx, 03h

                Push ax

                ConvertToNumber valueXI4

                mov bx, ax

                Pop ax

                mul bx

                Pop cx
            mov bx, ax

            Pop ax

            add ax, bx

            Push ax

            Push cx

            ; X3
                MultiplyXsTimes cx, 02h

                Push ax

                ConvertToNumber valueXI3

                mov bx, ax

                Pop ax

                mul bx

                Pop cx

            mov bx, ax

            Pop ax

            add ax, bx

            Push ax

            Push cx

            ; X2
                MultiplyXsTimes cx, 01h

                Push ax

                ConvertToNumber valueXI2

                mov bx, ax

                Pop ax

                mul bx

                Pop cx

            mov bx, ax

            Pop ax

            add ax, bx

            Push ax

            Push cx

            ; X1
                ConvertToNumber valueXI1

                Pop cx

                Push cx

                mul cx

                Pop cx

            mov bx, ax

            Pop ax

            add ax, bx

            Push ax

            Push cx

            ; XO
                ConvertToNumber valueXI0
                mov bx, ax

                Pop cx

            Pop ax

            add ax, bx

            ; Print pixels

            ; X axis
            mov bx, 9fh
            add bx, cx

            test ax, 1000000000000000b
                jnz NegativeXP
            jmp PositiveXP

            NegativeXP:
                neg ax
                ; Y axis
                mov dx, 63h
                add dx, ax
                jmp PrintP
            PositiveXP:
                ; Y axis
                mov dx, 63h
                sub dx, ax
            
            PrintP:
                cmp ax, 63h
                    jae EndOfLoopPos
                printPixel bx, dx, 4fh

            EndOfLoopPos:
        dec cx
            jne RepeatPositive
        Popear
    endm

    MultiplyXsTimes macro number, times
        local RepeatMultiply

        xor ax, ax
        xor bx, bx

        mov ax, number

        mov bx, number

        mov cx, times
        RepeatMultiply:
            mul bx
        Loop RepeatMultiply        

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

    GenerateReport macro string
        xor si, si

        ConcatText string, headerReport, SIZEOF headerReport

        ConcatText string, Fdate, SIZEOF Fdate

        ConcatText string, dateMsg, SIZEOF dateMsg

        ConcatText string, newLine, SIZEOF newLine

        ConcatText string, originalMsg, SIZEOF originalMsg

        Clean functionToShow, SIZEOF functionToShow, 24h

        GetOFunction functionToShow

        ConcatText string, tab, SIZEOF tab

        ConcatText string, functionToShow, SIZEOF functionToShow

        ConcatText string, newLine, SIZEOF newLine

        ConcatText string, derivedMsg, SIZEOF derivedMsg
        
        Clean functionToShow, SIZEOF functionToShow, 24h

        getDFunction functionToShow

        ConcatText string, tab, SIZEOF tab

        ConcatText string, functionToShow, SIZEOF functionToShow

        ConcatText string, newLine, SIZEOF newLine

        ConcatText string, integralMsg, SIZEOF integralMsg

        Clean functionToShow, SIZEOF functionToShow, 24h

        getIFunction functionToShow

        ConcatText string, tab, SIZEOF tab

        ConcatText string, functionToShow, SIZEOF functionToShow
    endm

    CheckRoute macro route
        local First, Begin, EndGC
        
        xor si, si

        mov si, SIZEOF route

        Begin:
            dec si
            cmp route[si], 00h
                je Begin
            cmp route[si], '#'
                je EndGC
        jmp InvalidRouteError
        EndGC:
            mov route[si], 00h
            dec si
            cmp route[si], '#'
                jne InvalidRouteError
            mov route[si], 00h
            dec si
            cmp route[si], 'q'
                jne InvalidRouteError
            dec si
            cmp route[si], 'r'
                jne InvalidRouteError
            dec si
            cmp route[si], 'a'
                jne InvalidRouteError
            dec si
            cmp route[si], '.'
                jne InvalidRouteError
    endm

    MoveRoute macro string
        local RepeatMove
        xor si, si
        mov cx, SIZEOF string
        RepeatMove:
            mov al, string[si+2]            
            mov string[si], al
            inc si
        Loop RepeatMove
    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\ GET DATE \\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ; PRINCIPAL MACRO FOR DATE AND HOUR
    getDateAndHour macro stringDate
        
        Pushear
        xor si, si

        getDate
        ; DL = DAY. DH = MONTH

        ConvertToStringDH stringDate, dl ; NUMBER -> STRING. DAY

        mov stringDate[si], 2fh ; /
        inc si

        ConvertToStringDH stringDate, dh ; NUMBER -> STRING. MONTH

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
        
        ConvertToStringDH stringDate, ch ; NUMBER -> STRING. HOUR

        mov stringDate[si],3ah ; :
        inc si

        ConvertToStringDH stringDate, cl ; NUMBER -> STRING. MINUTES

        mov stringDate[si],3ah ; :
        inc si

        ConvertToStringDH stringDate, dh ; NUMBER -> STRING. SECONDS

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
;\\\\\\\\\\\\\\\\\\\ CONVERSIONS \\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ConvertToNumber macro string
        local Begin, EndGC, PositiveSymbol, NegativeSymbol, Negative
        Push si
        
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        mov bx, 10
        xor si, si
        xor di, di
        ; Check signs
        Begin:
            mov cl, string[si]      
            ; If the ascii is +
            cmp cl, '+'
                je PositiveSymbol
            ; If the ascii is -
            cmp cl, '-'
                je NegativeSymbol
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
        PositiveSymbol:
            inc si
            jmp Begin
        NegativeSymbol:
            inc di            
            inc si
            jmp Begin
        Negative:
            ;TestingAX
            xor di, di
            neg ax
            xor dx, dx
        EndGC:        
            cmp di, 01h
                je Negative
            ; The string converted to number is in the registry ax
            ;TestingAX
            Pop si
    endm

    ConvertToString macro string
        local Divide, Divide2, EndCr3, Negative, End2, EndGC
        Push si
        xor si, si
        xor cx, cx
        xor bx, bx
        xor dx, dx
        mov dl, 0ah
        test ax, 1000000000000000b
            jnz Negative
        jmp Divide2
        Negative:
            neg ax
            mov string[si], 45
            inc si
            jmp Divide2
        
        Divide:
            xor ah, ah
        Divide2:
            div dl
            inc cx
            Push ax
            cmp al, 00h
                je EndCr3
            jmp Divide
        EndCr3:
            pop ax
            add ah, 30h
            mov string[si], ah
            inc si
        Loop EndCr3
        mov ah, 24h
        mov string[si], ah
        inc si
        EndGC:
            Pop si
    endm

    ConvertToStringDH macro string, numberToConvert
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