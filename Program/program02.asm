TITLE Program #2 Fibonacci Numbers    (program02.asm)

; Author:                Xiaoying Li
; Last Modified:         10/20/2019
; OSU email address:     lixiaoyi@oregonstate.edu
; Course number/section: CS_271_400_F2019
; Project Number:        #2                
; Due Date:              10/20/2019
; Description:           Write a program to calculate Fibonacci numbers.
;                          1. Display the program title and programmer¡¯s name. Then prompt the user for their name and greet them (by name).
;                          2. Prompt the user to enter the number of Fibonacci terms to be displayed. Advise the user to enter an integer in the range [1 .. 46].
;                          3. Get and validate the user input (n).
;                          4. Calculate and display all of the Fibonacci numbers up to and including the nth term. The results should be displayed 4 terms per line with at least 5 spaces between terms.
;                          5. Display a parting message that includes the user¡¯s name, and terminate the program.

INCLUDE Irvine32.inc

UPPER_LIMIT=46
LOWER_LIMIT=1

.data
programTitle		BYTE	"Fibonacci Numbers", 0
programmerName		BYTE	"Programmed by Xiaoying Li", 0
ECDescription		BYTE	"**EC: Display the numbers in aligned columns.", 0
promptUserName		BYTE	"What's your name? ", 0
userName			BYTE	20 DUP(0)
byteCount			DWORD	?
greet				BYTE	"Hello, ", 0
promptNumber		BYTE	"Enter the number of Fibonacci terms to be displayed.", 0
rangeAdvise			BYTE	"Provide the number as an integer in the range [1 .. 46].", 0
getInput			BYTE	"How many Fibonacci terms do you want? ", 0
validateInput		BYTE	"Out of range. Enter a number in [1 .. 46].", 0
inputNumber			DWORD	?
columnNumber		DWORD	?
rowNumber			DWORD	?
currentNumber		DWORD	?
spaces				BYTE	9, 0
partingMessage		BYTE	"Results certified by Xiaoying Li.", 0
terminatingMessage	BYTE	"Goodbye, ", 0

.code
main PROC

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

;Prompt the user for their name.
	mov		edx, OFFSET promptUserName
	call	WriteString

;Get the user's name.
	mov		edx, OFFSET userName
	mov		ecx, SIZEOF userName
	call	ReadString
	mov		byteCount, eax

;Greet the user.
	mov		edx, OFFSET greet
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	Crlf

;Prompt the user to enter the number of Fibonacci terms to be displayed.
	mov		edx, OFFSET promptNumber
	call	WriteString
	call	Crlf

;Advise the user to enter an integer in the range [1 .. 46].
	mov		edx, OFFSET rangeAdvise
	call	WriteString
	call	Crlf

;Get the user input (n).
EnterNumber:
	mov		edx, OFFSET getInput
	call	WriteString
	call	ReadInt
	mov		inputNumber, eax

;Validate the user input (n).
	cmp		eax, UPPER_LIMIT
	jg		InvalidInput
	cmp		eax, LOWER_LIMIT
	jl		InvalidInput

;Calculate and display all of the Fibonacci numbers up to and including the nth term.
	mov		eax, 0
	mov		ebx, 1
	mov		ecx, inputNumber
	mov		columnNumber, 4
	mov		rowNumber, 1

OutputNumber:
	mov		currentNumber, eax
	add		eax, ebx
	call	WriteDec
	dec		columnNumber
	jnz		OutputSpaces

;Display the results 4 terms per line.
OutputNewLine:
	call	Crlf
	mov		columnNumber, 4
	inc		rowNumber
	jmp		LoopOutput

;Use Tabs to display the numbers in aligned columns.
;For the first 9 rows of numbers, use 2 tabs.
;For the last 3 rows of numbers, use 1 tab.
OutputSpaces:
	cmp		rowNumber, 9
	ja		OutputOneTab
	mov		edx, OFFSET spaces
	call	WriteString

OutputOneTab:
	mov		edx, OFFSET spaces
	call	WriteString

LoopOutput:
	mov		ebx, currentNumber
	loop	OutputNumber
	jmp		TerminateProgram

InvalidInput:
	mov		edx, OFFSET validateInput
	call	WriteString
	call	Crlf
	jmp		EnterNumber

TerminateProgram:
;Display a parting message that includes the user¡¯s name.
	call	Crlf
	mov		edx, OFFSET partingMessage
	call	WriteString
	call	Crlf
	mov		edx, OFFSET terminatingMessage
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString

;Terminate the program
	exit

main ENDP

END main