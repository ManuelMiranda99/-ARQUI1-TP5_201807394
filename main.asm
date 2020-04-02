include macros.asm

.model small

; STACK SEGMENT
.stack

; DATA SEGMENT
.data

    ; TESTING
        testing db 'TEST', '$'
    ; END TESTING

    ; SPECIAL CHARACTERS
        newLine db 13, 10, '$'
        cleanChar db '             ', '$'
        tab db 9, '$'
    ; END SPECIAL CHARACTERS

    ; HEADERS AND MENUS
        ; PRINCIPAL MENU
            header db 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 13, 10, 'FACULTAD DE INGENIERIA', 13, 10, 'ESCUELA DE CIENCIAS Y SISTEMAS', 13, 10, 'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1', 13, 10, 'PRIMER SEMESTRE 2020', 13, 10, 'NOMBRE: ANGEL MANUEL MIRANDA ASTURIAS', 13, 10, 'CARNET: 201807394', 13, 10, 'SECCION: A', 13, 10, 'PRACTICA 5', '$'
            menu db 13, 10, 9, '-_-MENU-_-', 13, 10, 9, '1) Ingresar Funcion f(x)', 13, 10, 9, '2) Funcion en memoria', 13, 10, 9, '3) Derivada f`(x)', 13, 10, 9, '4) Integral F(x)', 13, 10, 9, '5) Graficar Funciones', 13, 10, 9, '6) Reporte', 13, 10, 9, '7) Modo Calculadora', 13, 10, 9, '8) Salir', 13, 10, '$'
            msgRoute db 'Ingrese la ruta (##ruta.arq##): ', '$'

        ; ENTER FUNCTION
            headerEnterF db 'INGRESE LOS COEFICIENTES PARA SU FUNCION: ', 13, 10, '$'
            msgEnterF db '- Coeficiente de x', '$'
            msgX4 db '4: ', '$'
            msgX3 db '3: ', '$'
            msgX2 db '2: ', '$'
            msgX1 db '1: ', '$'
            msgX0 db '0: ', '$'

        ; FUNCTION IN MEMORY
            headerFunctionM db 'Funcion en memoria f(x): ', 13, 10, '$'
            msgFunctionM db 'f(x) = '
            txtFunction db 500 dup('$')

        ; DERIVED 
            headerDerived db 'DERIVADA DE f(x): ', 13, 10, '$'
            msgDerived db 'f`(x) = ', '$'
        
        ; INTEGRAL
            headerIntegral db 'INTEGRAL DE f(x): ', 13, 10, '$'
            msgIntegral db 'F(x) = ', '$'
            msgC db ' + c', '$'
            msgEnterC db 'Ingrese el valor c: ', '$'
        
        ; GRAPH
            menuGraph db 9, 9, '-_-MENU GRAFICAR-_-', 13, 10, '1) Graficar Original f(x)', 13, 10, '2) Graficar Derivada f`(x)', 13, 10, '3) Graficar Integral F(x)', 13, 10, '4) Regresar f(x)', 13, 10, '$'
            msgEnterInterval db 'Ingrese el valor ', '$'
            msgEIU db 'final ', '$'
            msgEID db 'inicial ', '$'
            msgEnterIntervalF db 'del intervalo: ', '$'

    ; END HEADERS AND MENUS

    ; REPORT
        headerReport db 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 13, 10, 'FACULTAD DE INGENIERIA', 13, 10, 'ESCUELA DE CIENCIAS Y SISTEMAS', 13, 10, 'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A', 13, 10, 'PRIMER SEMESTRE 2020', 13, 10, 'ANGEL MANUEL MIRANDA ASTURIAS', 13, 10, '201807394', 13, 10, 13, 10, 'REPORTE PRACTICA NO. 5', 13, 10, 13, 10

        dateMsg db 'Fecha: 00/00/0000', 13, 10
        hourMsg db 'Hora: 00:00:00', 13, 10

        originalMsg db 'Funcion Original', 13, 10
        derivedMsg db 'Funcion Derivada', 13, 10
        integralMsg db 'Funcion Integral', 13, 10

        reportTxt db 2000 dup(00h)

        routeReport db 'report.arq'

        reportHandler dw ?
    ; END REPORT

    ; CALCULATOR

        ; ROUTE
            routeCalculator db 50 dup('$')
            handlerCalculator dw ?

        ; FILE
            fileContent db 2000 dup('$')

        ; END MESSAGE
            resultMsg db 'El resultado de la operacion es: ', '$'

        ; ERRORS
            invalidCharE db 'Caracter invalido:    ', '$'
            missingCharE db 'Falto caracter de finalizacion (', 59, ')', '$'
    ; END CALCULATOR

    ; "VARIABLES"
        selectionGraph db 31h

        functionToShow db 500 dup('$')

        auxiliarReader db 5 dup('$')

        valueX4 db 10 dup('$')
        valueX3 db 10 dup('$')
        valueX2 db 10 dup('$')
        valueX1 db 10 dup('$')
        valueX0 db 10 dup('$')

        valueXD3 db 10 dup('$')
        valueXD2 db 10 dup('$')
        valueXD1 db 10 dup('$')
        valueXD0 db 10 dup('$')

        valueXI5 db 10 dup('$')
        valueXI4 db 10 dup('$')
        valueXI3 db 10 dup('$')
        valueXI2 db 10 dup('$')
        valueXI1 db 10 dup('$')
        valueXI0 db 10 dup('$')

        inferiorLimit db 10 dup('$')
        superiorLimit db 10 dup('$')

    ; END VARIABLES

    ; ERRORS
        msgErrorNoFunction db 'No ingreso funcion alguna', '$'
        msgErrorWrite db 'Error al escribir en el archivo', '$'
        msgErrorOpen db 'Error al abrir el archivo', '$'
        msgErrorCreate db 'Error al crear el archivo', '$'
        msgErrorClose db 'Error al cerrar el archivo', '$'
        msgErrorRead db 'Error al leer el archivo', '$'
    ; END ERRORS

; CODE SEGMENT
.code

main proc

    mov ax, @data
    mov ds, ax

    Start:
        ClearConsole
        ; MENU
        print header
        print menu
        getChar

        ClearConsole
        
        ; COMPARE THE CHAR THAT THE USER WRITE IN THE PROGRAM
            cmp al, 31h
                je EnterFunction
            cmp al, 32h
                je EnterFunctionMemory
            cmp al, 33h
                je Derived
            cmp al, 34h
                je Integral
            cmp al, 35h
                je Graph
            cmp al, 36h
                je Reports
            cmp al, 37h
                je Calculator
            cmp al, 38h
                je Exit
        jmp Start
    EnterFunction:
        print headerEnterF
        
        ; X4
            print msgEnterF
            print msgX4

            getText valueX4
            
        ; X3
            print msgEnterF
            print msgX3
            
            getText valueX3

        ; X2
            print msgEnterF
            print msgX2
            
            getText valueX2

        ; X1
            print msgEnterF
            print msgX1

            getText valueX1

        ; X0
            print msgEnterF
            print msgX0

            getText valueX0

        jmp Start
    EnterFunctionMemory:
        xor si, si
        cmp valueX4[si], 24h
            jne ShowFunction
        cmp valueX3[si], 24h
            jne ShowFunction
        cmp valueX2[si], 24h
            jne ShowFunction
        cmp valueX1[si], 24h
            jne ShowFunction
        cmp valueX2[si], 24h
            jne ShowFunction

        print msgErrorNoFunction
        getChar
        jmp Start

        ShowFunction:
            print headerFunctionM

            Clean functionToShow, SIZEOF functionToShow, 24h

            GetOFunction functionToShow

            print tab

            print functionToShow

            getChar

        jmp Start
    Derived:
        xor si, si
        cmp valueX4[si], 24h
            jne ShowDFunction
        cmp valueX3[si], 24h
            jne ShowDFunction
        cmp valueX2[si], 24h
            jne ShowDFunction
        cmp valueX1[si], 24h
            jne ShowDFunction
        cmp valueX2[si], 24h
            jne ShowDFunction

        print msgErrorNoFunction
        getChar
        jmp Start

        ShowDFunction:
            print headerDerived

            Clean functionToShow, SIZEOF functionToShow, 24h

            getDFunction functionToShow

            print tab

            print functionToShow

            getChar

        jmp Start
    Integral:
        xor si, si
        cmp valueX4[si], 24h
            jne ShowIFunction
        cmp valueX3[si], 24h
            jne ShowIFunction
        cmp valueX2[si], 24h
            jne ShowIFunction
        cmp valueX1[si], 24h
            jne ShowIFunction
        cmp valueX2[si], 24h
            jne ShowIFunction

        print msgErrorNoFunction
        getChar
        jmp Start

        ShowIFunction:
            print headerIntegral

            Clean functionToShow, SIZEOF functionToShow, 24h

            getIFunction functionToShow

            print tab

            print functionToShow

            getChar

        jmp Start
    Graph:

        print menuGraph

        Pushear

        getChar

        cmp al, 34h
            je Start

        Push ax

        print newLine

        print msgEnterInterval
        print msgEID
        print msgEnterIntervalF

        getText inferiorLimit

        print newLine

        print msgEnterInterval
        print msgEIU
        print msgEnterIntervalF

        getText superiorLimit

        Pop ax

        cmp al, 31h
            je GraphOriginal
        cmp al, 32h
            je GraphDerived
        cmp al, 33h
            je GraphIntegral

        GraphOriginal:
            ; VIDEO MODE
            mov ax, 0013h
            int 10h

            GraphAxis
            GraphOriginalMacro inferiorLimit, superiorLimit
            jmp EndGraph
        GraphDerived:            
            ; VIDEO MODE
            mov ax, 0013h
            int 10h
            
            getDFunction functionToShow
            
            GraphAxis
            
            GraphDerivedMacro inferiorLimit, superiorLimit
            jmp EndGraph            
        GraphIntegral:
            print newLine
            print msgEnterC

            getText valueXI0

            ; VIDEO MODE
            mov ax, 0013h
            int 10h

            GraphAxis
            GraphIntegralMacro inferiorLimit, superiorLimit
        EndGraph:
            ; WAIT
            mov ah, 10h
            int 16h

            ; TEXT MODE
            mov ax, 0003h
            int 10h

            Popear

            jmp Start
    Reports:

        getDateAndHour dateMsg, hourMsg

        Clean reportTxt, SIZEOF reportTxt, 00h

        CreateFile routeReport, reportHandler

        ;GenerateReport

        WriteOnFile reportHandler, reportTxt, SIZEOF reportTxt

        CloseFile reportHandler

        jmp Start
    Calculator:
        print msgRoute

        Clean routeCalculator, SIZEOF routeCalculator, 24h

        getRoute routeCalculator

        OpenFile routeCalculator, handlerCalculator

        Clean fileContent, SIZEOF fileContent, 56h

        ReadFile handlerCalculator, fileContent, SIZEOF fileContent

        CloseFile handlerCalculator

        AnalizeText fileContent

        jmp Start
    Exit:
        mov ah, 4ch     ; END PROGRAM
        xor al, al
        int 21h
    ; ERRORS
        WriteError:
            print msgErrorWrite
            getChar
            print cleanChar
            print cleanChar
            print cleanChar        
            jmp Start
        OpenError:
            print msgErrorOpen
            getChar
            print cleanChar
            print cleanChar
            print cleanChar        
            jmp Start
        CreateError:
            print msgErrorCreate
            getChar
            print cleanChar
            print cleanChar
            print cleanChar        
            jmp Start
        CloseError:
            print msgErrorClose
            getChar
            print cleanChar
            print cleanChar
            print cleanChar        
            jmp Start
        ReadError:
            print msgErrorRead
            getChar
            print cleanChar
            print cleanChar
            print cleanChar        
            jmp Start
main endp

end