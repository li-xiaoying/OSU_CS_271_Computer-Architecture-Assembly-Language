TITLE Program #4 Composite Number Spreadsheet    (program04.asm)

; Author:                Xiaoying Li
; Last Modified:         11/10/2019
; OSU email address:     lixiaoyi@oregonstate.edu
; Course number/section: CS_271_400_F2019
; Project Number:        #4              
; Due Date:              11/10/2019
; Description:           Write a program to calculate composite numbers. 
;							First, the user is instructed to enter the number of composites to be displayed, and is prompted to enter an integer in the range [1 .. 300]. 
;							The user enters a number, n, and the program verifies that 1 ¡Ü n ¡Ü 300. 
;							If n is out of range, the user is re-prompted until they enter a value in the specified range. 
;							The program then calculates and displays all of the composite numbers up to and including the nth composite. 
;							The results should be displayed 10 composites per line with at least 3 spaces between the numbers.

INCLUDE Irvine32.inc

LOWER_LIMIT=1
UPPER_LIMIT=300

.data
programTitle		BYTE	"Welcome to the Composite Number Spreadsheet", 0
programmerName		BYTE	"Programmed by Xiaoying Li", 0
ECDescription		BYTE	"**EC: When the program runs, give the user the option to display only composite numbers that are also odd numbers.", 0
instruction1		BYTE	"This program is capable of generating a list of composite numbers.", 0
instruction2		BYTE	"Simply let me know how many you would like to see.", 0
instruction3		BYTE	"I¡¯ll accept orders for up to 300 composites.", 0
optionInstruction1	BYTE	"You also have the option to display only composite numbers that are also odd numbers.", 0
optionInstruction2	BYTE	"Enter 0 to view all composite numbers.", 0
optionInstruction3	BYTE	"Enter 1 to view only odd composites.", 0
promptOption		BYTE	"Your option [0/1]: ", 0
userOption			DWORD	?
promptNumber		BYTE	"How many composites do you want to view? [1 .. 300]: ", 0
errorMessage		BYTE	"Out of range. Please try again.", 0
count				DWORD	?
currentNumber		DWORD	?
columnNumber		DWORD	?
currentFactor		DWORD	?
two					DWORD	2
spaces				BYTE	"    ", 0
goodbyeMessage		BYTE	"Thanks for using my program!", 0


.code
;----------------------------------------------------------------------------------------------------------------------------------------------------
; The main procedure consists of procedure calls. It's a list of what the program will do.
;----------------------------------------------------------------------------------------------------------------------------------------------------
main PROC
	call	introduction
	call	getUserData
	call	showComposites
	call	goodbye

	exit
main ENDP


;----------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The instroduction procedure outputs program's title and programmer¡¯s name, and instructs the user to enter the number of composites
;              to be displayed. And promot the user enter the option of displaying only composite numbers that are also odd numbers.
; Pre-conditions: none
; Post-conditions: all introductions displayed; user's option get
; Registers changed: eax, edx
;----------------------------------------------------------------------------------------------------------------------------------------------------
introduction PROC
;Display the program title.
	mov		edx, OFFSET programTitle
	call	WriteString
	call	Crlf

;Display programmer's name.
	mov		edx, OFFSET programmerName
	call	WriteString
	call	Crlf

;Display description of the extra credit.
	mov		edx, OFFSET ECDescription
	call	WriteString
	call	Crlf

;Display instructions for the user.
	mov		edx, OFFSET instruction1
	call	WriteString
	call	Crlf
	mov		edx, OFFSET instruction2
	call	WriteString
	call	Crlf
	mov		edx, OFFSET instruction3
	call	WriteString
	call	Crlf

;Give the user the option to display only composite numbers that are also odd numbers.
	mov		edx, OFFSET optionInstruction1
	call	WriteString
	call	Crlf
	mov		edx, OFFSET optionInstruction2
	call	WriteString
	call	Crlf
	mov		edx, OFFSET optionInstruction3
	call	WriteString
	call	Crlf

;Get user's option.
	mov		edx, OFFSET promptOption
	call	WriteString
	call	ReadInt
	mov		userOption, eax

	ret
introduction ENDP


;----------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The getUserData procedure prompts the user to enter an integer in the range [1 .. 300], and verifies the integer 1 ¡Ü n ¡Ü 300. 
;              If n is out of range, re-prompts the user until they enter a value in the specified range.
; Pre-conditions: none
; Post-conditions: get validate user input
; Registers changed: eax, edx
;----------------------------------------------------------------------------------------------------------------------------------------------------
getUserData PROC
;Prompt the user to enter an integer in the range [1 .. 300] and validate the user input.
	mov		edx, OFFSET promptNumber
	call	WriteString
	call	ReadInt
	mov		count, eax
	call	validate

	ret
getUserData ENDP


;----------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The validate procedure verifies the number the user entered is in the range 1 ¡Ü n ¡Ü 300.
; Pre-conditions: get user's input
; Post-conditions: validate user's input in the range 1 ¡Ü n ¡Ü 300
; Registers changed: eax, edx
;----------------------------------------------------------------------------------------------------------------------------------------------------
validate PROC
;Verifie the user input to be 1 ¡Ü n ¡Ü 300.
	cmp		eax, LOWER_LIMIT
	jb		OutOfRange
	cmp		eax, UPPER_LIMIT
	ja		OutOfRange
	jmp		InRange

;If n is out of range, display an error message and re-prompt the user until they enter a value in the specified range.
OutOfRange:
	mov		edx, OFFSET errorMessage
	call	WriteString
	call	Crlf
	call	getUserData

InRange:

	ret
validate ENDP


;----------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The showComposites procedure calculates and displays all of the composite numbers up to and including the nth composite. 
;              The results are displayed 10 composites per line with at least 3 spaces between the numbers.
; Pre-conditions: get validate user input of number of composite numbers
; Post-conditions: calculates and displays all of the composite numbers up to and including the nth composite
; Registers changed: eax, ecx, edx
;----------------------------------------------------------------------------------------------------------------------------------------------------
showComposites PROC
	mov		ecx, count
	mov		currentNumber, 4	;The smallest composite number is 4.
	mov		columnNumber, 10

CalculateDisplayComposites:
	call	isComposite
	mov		eax, userOption		;Before display the compsite number, check if the user chooses to view only odd composites.
	cmp		eax, 0
	je		DisplayComposites	;If the user chooses to view all composite numbers, display the compsite number.
	mov		eax, currentNumber	;If the user chooses to view only odd composites, check whether this composite number is odd or not.
	cdq
	div		two
	cmp		edx, 0
	je		NotOdd

DisplayComposites:				;If this composite number is odd, display the number and loop the next number.
	mov		eax, currentNumber
	call	WriteDec
	mov		edx, OFFSET spaces	;Display the result 10 composites per line with at least 3 spaces between the numbers.
	call	WriteString
	inc		currentNumber
	dec		columnNumber
	jnz		CountingLoop
	call	Crlf
	mov		columnNumber, 10
	jmp		CountingLoop

;If this composite number is not odd, don't display this number and increase the counting loop by 1, then loop the next number.
NotOdd:
	inc		currentNumber
	inc		ecx

;Implement the counting loop (1 to n) using the loop instruction.
CountingLoop:
	loop	CalculateDisplayComposites

	ret
showComposites ENDP


;----------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The isComposites procedure calculates all of the composite numbers up to and including the nth composite. 
; Pre-conditions: get validate user input of number of composite numbers
; Post-conditions: calculates and displays all of the composite numbers up to and including the nth composite
; Registers changed: eax, edx
;----------------------------------------------------------------------------------------------------------------------------------------------------
isComposite PROC
;Everytime this precedure begins to check if a new number is composite, reset the factor to 2.
ResetFactor:
	mov		currentFactor, 2

;Divide the number n by 2, 3, 4,..., n-1 until the remainder is 0.
Division:
	mov		eax, currentNumber
	cdq
	div		currentFactor
	cmp		edx, 0
	je		CompositeFound		;If the remainder is 0, this number is composite number.
	inc		currentFactor
	mov		eax, currentFactor
	cmp		eax, currentNumber
	jb		Division
	inc		currentNumber
	jmp		ResetFactor			;If no factor [2, n-1] of this number is found, this number is not composite, then check the next number.

CompositeFound:

	ret
isComposite ENDP


;----------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The goodbye procedure displays a goodbye message.
; Pre-conditions: all the composite numbers up to and including the nth composite are displayed
; Post-conditions: a goodbye message is displayed
; Registers changed: edx
;----------------------------------------------------------------------------------------------------------------------------------------------------
goodbye PROC
	call	Crlf
	mov		edx, OFFSET goodbyeMessage
	call	WriteString

	ret
goodbye ENDP

END main