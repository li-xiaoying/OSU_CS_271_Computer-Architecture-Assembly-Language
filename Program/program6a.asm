TITLE Program #6a Demonstrating low-level I/O procedures    (program6a.asm)

; Author:                Xiaoying Li
; Last Modified:         12/07/2019
; OSU email address:     lixiaoyi@oregonstate.edu
; Course number/section: CS_271_400_F2019
; Project Number:        #6a              
; Due Date:              12/08/2019
; Description:           The program will get 10 valid integers from the user and store the numeric values into an array. 
;                        The program will then display the list of integers, their sum, and the average value of the list.

INCLUDE Irvine32.inc


;---------------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The displayString MACRO displays output on the screen.
; Parameter: string to be displayed.
;---------------------------------------------------------------------------------------------------------------------------------------------------------
displayString MACRO stringToDisplay
	push	edx

	mov		edx, stringToDisplay
	call	WriteString

	pop		edx
ENDM


;---------------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The getString MACRO displays a prompt, then get the user¡¯s keyboard input into a memory location.
; Parameter: popmpt to display and memory location to store the input.
;---------------------------------------------------------------------------------------------------------------------------------------------------------
getString MACRO prompt, stringToGet
	push	eax
	push	ecx
	push	edx

	mov		edx, prompt
	call	WriteString
	mov		edx, stringToGet
	mov		ecx, 32
	call	ReadString

	pop		edx
	pop		ecx
	pop		eax
ENDM


.data
programTitle	BYTE	"Demonstrating low-level I/O procedures", 0
programmerName	BYTE	"Written by: Xiaoying Li", 0
instruction1	BYTE	"Please provide 10 decimal integers.", 0
instruction2	BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
instruction3	BYTE	"After you have finished inputting the raw numbers I will display a listof the integers, their sum, and their average value.", 0
ECDescription	BYTE	"**Extra Credit: Number each line of user input and display a running subtotal of the user¡¯s numbers.", 0
promptMessage	BYTE	". Please enter an integer number: ", 0
errorMessage	BYTE	"      ERROR: You did not enter an integer number or your number was too big.", 0
tryAgainMessage	BYTE	"   Please try again: ", 0
subtotalMessage	BYTE	"   Subtotal: ", 0
inputString		BYTE	11 DUP(?)
outputString	BYTE	11 DUP(?)
array			DWORD	10 DUP(?)
sum				DWORD	0
average			DWORD	0
arrayMessage	BYTE	"You entered the following numbers:", 0
comma			BYTE	", ", 0
sumMessage		BYTE	"The sum of these numbers is: ", 0
averageMessage	BYTE	"The average is: ", 0
goodbyeMessage	BYTE	"Thanks for playing!", 0


.code
;---------------------------------------------------------------------------------------------------------------------------------------------------------
; The main procedure consists mostly of procedure calls. It's a list of what the program will do.
;---------------------------------------------------------------------------------------------------------------------------------------------------------
main PROC
;Display the program title, programmer's name and brief instruction for the user.
	displayString	OFFSET programTitle
	call	Crlf
	displayString	OFFSET programmerName
	call	Crlf
	call	Crlf
	displayString	OFFSET instruction1
	call	Crlf
	displayString	OFFSET instruction2
	call	Crlf
	displayString	OFFSET instruction3
	call	Crlf
	displayString	OFFSET ECDescription
	call	Crlf
	call	Crlf
	
	push	OFFSET inputString
	push	OFFSET outputString
	push	OFFSET array
	push	OFFSET sum
	push	OFFSET average
	call	fillArrayAndCalculate
	call	Crlf

;Display the list of integers.
	displayString	OFFSET arrayMessage
	call	Crlf
	push	OFFSET array
	push	OFFSET comma
	push	OFFSET inputString
	push	OFFSET outputString
	call	displayArray
	call	Crlf

;Display the sum value of the list.
	displayString	OFFSET sumMessage
	push	sum
	push	OFFSET inputString
	push	OFFSET outputString
	call	WriteVal
	call	Crlf

;Display the average value of the list.
	displayString	OFFSET averageMessage
	push	average
	push	OFFSET inputString
	push	OFFSET outputString
	call	WriteVal
	call	Crlf
	
	displayString	OFFSET goodbyeMessage

	exit
main ENDP


;---------------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The fillArrayAndCalculate procedure gets 10 valid integers from the user and store the numeric values into an array.
;              It also numbers each line of user input and displays a running subtotal of the user¡¯s numbers.
; Pre-conditions: All parameters are passed on the system stack.
; Post-conditions: 10 valid integers are got and stored in the passed parameter "array";
;                  each line of user input is numbered;
;                  running subtotals of the user¡¯s numbers are displayed;
;                  the sum value of the list is stored into the passed parameter "sum".
; Registers changed: eax, ebx, ecx, edx, edi
;---------------------------------------------------------------------------------------------------------------------------------------------------------
fillArrayAndCalculate PROC
	push	ebp
	mov		ebp, esp

	push	eax
	push	ebx
	push	ecx
	push	edx
	push	edi

	mov		eax, 1			;line counter
	mov		ebx, 0			;subtotal
	mov		ecx, 10			;loop counter
	mov		edi, [ebp+16]	;first element of array

fillArray:
;Display line number.
	push	eax				;line counter
	push	[ebp+24]		;inputString
	push	[ebp+20]		;outputString
	call	WriteVal

;Get one valid integer from user and store the value into the array.
	push	edi				;current element of array
	push	[ebp+24]		;inputString
	call	ReadVal

;Calculate and display the running subtotal.
	displayString	OFFSET subtotalMessage	
	add		ebx, [edi]		;add the new value to running subtotal	
	push	ebx				;subtotal
	push	[ebp+24]		;inputString
	push	[ebp+20]		;outputString
	call	WriteVal

;Move to next element and loop until 10 valid integers are got from user.
	add		edi, 4			;next element in array
	inc		eax				;line counter
	call	Crlf
	loop	fillArray

;Store the sum value of the list into the passed parameter "sum".
	mov		eax, [ebp+12]	;sum
	mov		[eax], ebx

;Calculate average.
	mov		eax, ebx		;sum
	mov		ebx, 10
	mov		edx, 0
	div		ebx

;Store the average value of the list into the passed parameter "average".
	mov		ebx, [ebp+8]	;average
	mov		[ebx], eax

	pop		edi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax

	pop		ebp
	ret		20
fillArrayAndCalculate ENDP


;---------------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The ReadVal procedure accepts a numeric string input from the keyboard and computes the corresponding integer value.
;              It also validate user¡¯s numeric input the hard way: read the user's input as a string, and convert the string to numeric form. 
;              If the user enters non-integers or the number is too large for 32-bit registers, an error message is displayed and the number is discarded.
; Pre-conditions: a numeric string is inputed from the keyboard;
;                 all parameters are passed on the system stack.
; Post-conditions: a valid corresponding integer value is computed.
; Registers changed: eax, ebx, ecx, edx, esi
;---------------------------------------------------------------------------------------------------------------------------------------------------------
ReadVal PROC
	push	ebp
	mov		ebp, esp

	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi

;Invoke the getString macro to get the user¡¯s string of digits.
	getString	OFFSET promptMessage, [ebp+8]	;inputString

;Validate user's input.
validate:	
	mov		esi, [ebp+8]						;inputString
	mov		eax, 0								;character value
	mov		ebx, 1								;10's multiple, 1, 1, 100, 1000 ... used to convert a string to an integer
	mov		ecx, 0								;character counter
	mov		edx, 0								;accumulator used when converting a string to an integer
	cld

;Get the length of user's input string.
getLength:
	lodsb
	cmp		al, 0
	je		validateLength				
	inc		ecx									;character counter
	jmp		getLength

;Validate if the length of user's input string is no more than 10.
validateLength:
	cmp		ecx, 10								;character counter
	jg		invalid

;Move to the last byte of the string.
;Adapted from demo6.asm.
	mov		esi, [ebp+8]						;inputString
	add		esi, ecx							;character counter
	dec		esi
	std

;Validate if every character of user's input string is a digit.
validateInteger:
	lodsb
	cmp		al, 48								;0's ASCII value
	jl		invalid
	cmp		al, 57								;9's ASCII value
	jg		invalid

;If the character is a didit, convert it to its decimal value and its actual value in the integer.
	sub		al, 48
	push	edx									;save accumulator
	mul		ebx									;10's multiple
	pop		edx									;restore accumulator

;Add the character's value to accumulator.
	add		edx, eax		
	push	edx									;save accumulator

;Mutiply 10's multiple by 10 for next character.
	mov		eax, ebx
	mov		ebx, 10
	mul		ebx
	mov		ebx, eax

;Move to next character.
	mov		eax, 0
	pop		edx									;restore accumulator
	loop	validateInteger
	jmp		nextPrompt

;If user's input string is invalid, ask user to try again.
invalid:
	displayString	OFFSET errorMessage
	call	Crlf
	getString	OFFSET tryAgainMessage, [ebp+8]	;Invoke the getString macro to get the user¡¯s string of digits.
	jmp		validate

;If user's input string is valid, store the value into the array and move to next prompt.
nextPrompt:
	mov		ebx, [ebp+12]						;current element of array
	mov		[ebx], edx							;final value of accumulator

	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax

	pop		ebp
	ret		8
ReadVal ENDP


;---------------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The WriteVal procedure accepts a 32 bit unsigned integer and displays the corresponding ASCII representation on the console.
; Pre-conditions: all parameters are passed on the system stack including a 32 bit unsigned integer.
; Post-conditions: the integer's corresponding ASCII representation is displayed on the console.
; Registers changed: eax, ebx, ecx, edx, edi, esi
;---------------------------------------------------------------------------------------------------------------------------------------------------------
WriteVal PROC
	push	ebp
	mov		ebp, esp

	push	eax
	push	ebx
	push	ecx
	push	edx
	push	edi
	push	esi

	mov		eax, [ebp+16]	;the integer value
	mov		edi, [ebp+12]	;inputString
	mov		ecx, 0			;digit counter
	cld

;Convert the integer value to its corresponding string.
convert:
	mov		edx, 0
	mov		ebx, 10
	div		ebx
	mov		ebx, edx		;divide the integr value by 10, and the remainder is the current digit
	add		ebx, 48			;convert the digit to its ASCII value
	push	eax				;save the quotient, which is the remaining digits
	mov		eax, ebx		;load the digit to string
	stosb
	pop		eax				;restore the quotient, which is the remaining digits
	inc		ecx				;digit counter
	cmp		eax, 0			;loop until every digit are converted to its corresponding string
	je		reverseString
	jmp		convert

;The converted string is in reverse order, reverse the string.
;Adapted from demo6.asm.
reverseString:	
	stosb	
	mov		esi, [ebp+12]	;first byte of inputString
	add		esi, ecx
	dec		esi				;last byte of inputString
	mov		edi, [ebp+8]	;first byte of outputString

reverse:	
	std						;get characters from end to beginning
	lodsb
	cld						;store characters from beginning to end
	stosb
	loop	reverse

	mov		eax, 0
	stosb

;Invoke the displayString macro to produce the output.
	displayString	[ebp+8]
	
	pop		esi
	pop		edi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax

	pop		ebp
	ret		12
WriteVal ENDP


;---------------------------------------------------------------------------------------------------------------------------------------------------------
; Description:The displayArray procedure displays the list of integers.
; Pre-conditions: all parameters are passed on the system stack.
; Post-conditions: the list of integers are displayed.
; Registers changed: ecx, esi
;---------------------------------------------------------------------------------------------------------------------------------------------------------
displayArray PROC
	push	ebp
	mov		ebp, esp
		
	push	ecx
	push	esi

	mov		ecx, 10
	mov		esi, [ebp+20]		;first element of array

displayElement:
	push	[esi]				;current element of array
	push	[ebp+12]			;inputString
	push	[ebp+8]				;outputString
	call	WriteVal
	cmp		ecx, 1				;no comma after the last element
	je		noComma
	displayString	[ebp+16]	;comma
	add		esi, 4				;move to next element
	
noComma:
	loop	displayElement
	
	pop				esi
	pop				ecx

	pop				ebp
	ret				16
displayArray ENDP


END main