include macros.asm

.model small

; STACK SEGMENT
.stack

; DATA SEGMENT
.data

    ; SPECIAL CHARACTERS
        newLine db 13, 10, '$'
    ; END SPECIAL CHARACTERS

    ; HEADERS AND MENUS
        ; PRINCIPAL MENU
            header db 9, 9, 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 13, 10, 9, 9, 'FACULTAD DE INGENIERIA', 13, 10, 9, 9, 'ESCUELA DE CIENCIAS Y SISTEMAS', 13, 10, 9, 9, 'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1', 13, 10, 9, 9, 'PRIMER SEMESTRE 2020', 13, 10, 9, 9, 'NOMBRE: ANGEL MANUEL MIRANDA ASTURIAS', 13, 10, 9, 9, 'CARNET: 201807394', 13, 10, 9, 9, 'SECCION: A', 13, 10, 9, 9, 'PRACTICA 5', '$'
            menu db 13, 10, 9, 9, '-_-MENU-_-', 13, 10, 9, 9, '1) Ingresar Funcion f(x)', 13, 10, 9, 9, '2) Funcion en memoria', 13, 10, 9, 9, '3) Derivada f`(x)', 13, 10, 9, 9, '4) Integral F(x)', 13, 10, 9, 9, '5) Graficas Funciones', 13, 10, 9, 9, '6) Reporte', 13, 10, 9, 9, '7) Modo Calculadora', 13, 10, 9, 9, '8) Salir', 13, 10, '$'
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
            msgFunctionM db 'f(x) =', '$'

        ; DERIVED 
            headerDerived db 'DERIVADA DE f(x): ', 13, 10, '$'
            msgDerived db 'f`(x) = ', '$'
        
        ; INTEGRAL
            headerIntegral db 'INTEGRAL DE f(x): ', 13, 10, '$'
            msgIntegral db 'F(x) = ', '$'
            msgC db ' + c', '$'
        
        ; GRAPH
            menuGraph db '9, 9, -_-MENU GRAFICAR-_-', 13, 10, 9, 9, '1) Graficar Original f(x)', 13, 10, 9, 9, '2) Graficar Derivada f`(x)', 13, 10, 9, 9, '3) Graficar Integral F(x)', 13, 10, 9, 9, '4) Regresar f(x)', 13, 10, '$'
            msgEnterInterval db 'Ingrese el valor ', '$'
            msgEIU db 'final ', '$'
            msgEID db 'inicial ', '$'
            msgEnterIntervalF db 'del intervalo: ', '$'

    ; END HEADERS AND MENUS

    ; REPORT
        dateMsg db 'Fecha: 00/00/0000', 13, 10
        hourMsg db 'Hora: 00:00:00', 13, 10

        originalMsg db 'Funcion Original', 13, 10
        derivedMsg db 'Funcion Derivada', 13, 10
        integralMsg db 'Funcion Integral', 13, 10
    ; END REPORT

    ; CALCULATOR

        ; END MESSAGE
            resultMsg db 'El resultado de la operacion es: ', '$'

        ; ERRORS
            invalidCharE db 'Caracter invalido:    ', '$'
            missingCharE db 'Falto caracter de finalizacion (', 59, ')', '$'
    ; END CALCULATOR

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
            ; ENTER FUNCTION
        cmp al, 32h
            ; ENTER FUNCTION IN MEMORY
        cmp al, 33h
            ; ENTER DERIVED
        cmp al, 34h
            ; ENTER INTEGRAL
        cmp al, 35h
            ; GRAPH
        cmp al, 36h
            ; REPORTS
        cmp al, 37h
            ; CALCULATOR MODE
        cmp al, 38h
            ; EXIT
            je Exit
        jmp Start
    EnterFunction:
    EnterFunctionMemory:
    Derived:
    INTEGRAL:
    GRAPH:
    REPORTS:
    CALCULATOR:
    Exit:
        mov ah, 4ch     ; END PROGRAM
        xor al, al
        int 21h
    ; ERRORS
main endp

end