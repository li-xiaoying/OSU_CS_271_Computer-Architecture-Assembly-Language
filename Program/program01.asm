TITLE Program #1 Elementary Arithmetic    (program01.asm)

; Author:                Xiaoying Li
; Last Modified:         10/12/2019
; OSU email address:     lixiaoyi@oregonstate.edu
; Course number/section: CS_271_400_F2019
; Project Number:        #1                
; Due Date:              10/13/2019
; Description:           Write and test a MASM program to perform the tasks listed below.
;                          1. Display your name and program title on the output screen.
;                          2. Display instructions for the user.
;                          3. Prompt the user to enter two numbers.
;                          4. Calculate the sum, difference, product, (integer) quotient and remainder of the numbers.
;                          5. Display a terminating message.

INCLUDE Irvine32.inc

.data
myNameAndProgramTitle	BYTE	"Elementary Arithmetic by Xiaoying Li", 0
instructions			BYTE	"Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.", 0
EC1Description			BYTE	"**Extra Credit 1: Validate the second number to be less than the first.", 0
EC2Description			BYTE	"**Extra Credit 2: Display the square of each number.", 0
promptNumber1			BYTE	"First number: ", 0
promptNumber2			BYTE	"Second number: ", 0
number1					DWORD	?
number2					DWORD	?
sum						DWORD	?
sumString				BYTE	" + ", 0
difference				DWORD	?
differenceString		BYTE	" - ", 0
product					DWORD	?
productString			BYTE	" * ", 0
quotient				DWORD	?
quotientString			BYTE	" / ", 0
remainder				DWORD	?
remainderString			BYTE	" remainder ", 0
square1					DWORD	?
square2					DWORD	?
squareString			BYTE	"Square of ", 0
equalString				BYTE	" = ", 0
errorMessage			BYTE	"The second number must be less than the first!", 0
terminatingMessage		BYTE	"Impressed? Bye!", 0

.code
main PROC

;Display my name and the program title.
	mov		edx, OFFSET myNameAndProgramTitle
	call	WriteString
	call	Crlf

;Display instructions for the user.
	mov		edx, OFFSET instructions
	call	WriteString
	call	Crlf

;Display description of the extra credit 1.
	mov		edx, OFFSET EC1Description
	call	WriteString
	call	Crlf

;Display description of the extra credit 2.
	mov		edx, OFFSET EC2Description
	call	WriteString
	call	Crlf

;Prompt the user to enter the first number.
	mov		edx, OFFSET promptNumber1
	call	WriteString
	call	ReadInt
	mov		number1, eax

;Prompt the user to enter the second number.
	mov		edx, OFFSET promptNumber2
	call	WriteString
	call	ReadInt
	mov		number2, eax

;Validate the second number to be less than the first.
	cmp		eax, number1
	jnb		Error
	jb		Calculate

;If the second number were not less than the first, print the error message and end the program.
Error:
	mov		edx, OFFSET errorMessage
	call	WriteString
	call	Crlf
	jmp		TerminateProgram

;If the second number were less than the first, do the calculation.
Calculate:
;Calculate the sum.
	mov		eax, number1
	add		eax, number2
	mov		sum, eax

;Calculate the difference.
	mov		eax, number1
	sub		eax, number2
	mov		difference, eax

;Calculate the product.
	mov		eax, number1
	mov		ebx, number2
	mul		ebx
	mov		product, eax

;Calculate the quotient and remainder.
	mov		eax, number1
	mov		ebx, number2
	mov		edx, 0
	div		ebx
	mov		quotient, eax
	mov		remainder, edx

;Calculate the square of the first number.
	mov		eax, number1
	mov		ebx, number1
	mul		ebx
	mov		square1, eax

;Calculate the square of the second number.
	mov		eax, number2
	mov		ebx, number2
	mul		ebx
	mov		square2, eax

;Display the sum.
	mov		eax, number1
	call	WriteDec
	mov		edx, OFFSET sumString
	call	WriteString
	mov		eax, number2
	call	WriteDec
	mov		edx, OFFSET equalString
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	Crlf

;Display the difference.
	mov		eax, number1
	call	WriteDec
	mov		edx, OFFSET differenceString
	call	WriteString
	mov		eax, number2
	call	WriteDec
	mov		edx, OFFSET equalString
	call	WriteString
	mov		eax, difference
	call	WriteDec
	call	Crlf

;Display the product.
	mov		eax, number1
	call	WriteDec
	mov		edx, OFFSET productString
	call	WriteString
	mov		eax, number2
	call	WriteDec
	mov		edx, OFFSET equalString
	call	WriteString
	mov		eax, product
	call	WriteDec
	call	Crlf

;Display the quotient and remiander.
	mov		eax, number1
	call	WriteDec
	mov		edx, OFFSET quotientString
	call	WriteString
	mov		eax, number2
	call	WriteDec
	mov		edx, OFFSET equalString
	call	WriteString
	mov		eax, quotient
	call	WriteDec
	mov		edx, OFFSET remainderString
	call	WriteString
	mov		eax, remainder
	call	WriteDec
	call	Crlf

;Display the the square of the first number.
	mov		edx, OFFSET squareString
	call	WriteString
	mov		eax, number1
	call	WriteDec
	mov		edx, OFFSET equalString
	call	WriteString
	mov		eax, square1
	call	WriteDec
	call	Crlf

;Display the the square of the Second number.
	mov		edx, OFFSET squareString
	call	WriteString
	mov		eax, number2
	call	WriteDec
	mov		edx, OFFSET equalString
	call	WriteString
	mov		eax, square2
	call	WriteDec
	call	Crlf

TerminateProgram:	
;Display the terminating message
	mov		edx, OFFSET terminatingMessage
	call	WriteString
	exit

main ENDP

END main
