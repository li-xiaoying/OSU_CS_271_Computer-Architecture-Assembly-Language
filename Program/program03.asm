TITLE Program #3 Accumulator Project    (program03.asm)

; Author:                Xiaoying Li
; Last Modified:         10/30/2019
; OSU email address:     lixiaoyi@oregonstate.edu
; Course number/section: CS_271_400_F2019
; Project Number:        #3                
; Due Date:              11/03/2019
; Description:           Write and test a MASM program to perform the following tasks:
;							1. Display the program title and programmer¡¯s name.
;							2. Get the user¡¯s name, and greet the user.
;							3. Display instructions for the user.
;							4. Repeatedly prompt the user to enter a number. Validate the user input to be in the range [-150, -1] (inclusive).
;                              Count and accumulate the valid user numbers until a non-negative number is entered. (The non-negative number will be discarded.)
;							5. Calculate the (rounded integer) average of the negative numbers. The value should be rounded towards 0 (e.g. -34.8 rounds to -34).
;							6. Display:
;								i.   The number of negative numbers entered (Note: if no negative numbers were entered, display a special message and skip to iv.)
;								ii.  The sum of negative numbers entered.
;								iii. The average (rounded towards 0, as noted in step 5).
;								iv.  A farewell message (which includes the user¡¯s name).

INCLUDE Irvine32.inc

LOWER_LIMIT=-150

.data
programTitleAndMyName	BYTE	"Welcome to the Accumulator Project by Xiaoying Li", 0
EC1Description			BYTE	"**Extra Credit 1: Number the lines during user input.", 0
EC2Description			BYTE	"**Extra Credit 2: Display the range of valid numbers that was entered by the user.", 0
promptUserName			BYTE	"What's your name? ", 0
userName				BYTE	20 DUP(0)
byteCount				DWORD	?
greetUser				BYTE	"Hello, ", 0
instruction1			BYTE	"Please enter numbers in the range [-150, -1].", 0
instruction2			BYTE	"Enter a non-negative number when you are finished to see results.", 0
promptNumber			BYTE	"Enter number: ", 0
leftBracket				BYTE	"(", 0
rightBracket			BYTE	") ", 0
count					DWORD	1
number					DWORD	?
minimum					DWORD	?
maximum					DWORD	?
sum						DWORD	0
average					DWORD	?
invalidMessage			BYTE	"Ignored that number! It needs to be in the range [-150, -1].", 0
noNegativeNumberMessage	BYTE	"No negative number entered!", 0
displayCount1			BYTE	"You entered ", 0
displayCount2			BYTE	" valid numbers.", 0
displaySum				BYTE	"The sum of your valid numbers is ", 0
displayAverage			BYTE	"The rounded average is ", 0
displayRange1			BYTE	"The valid numbers that you entered were in the range [", 0
displayRange2			BYTE	", ", 0
displayRange3			BYTE	"].", 0
farewellMessage			BYTE	"Thank you for testing my code! It's been a pleasure to meet you, ", 0

.code
main PROC

;Display the program title and programmer¡¯s name.
	mov		edx, OFFSET programTitleAndMyName
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

;Prompt the user for their name.
	mov		edx, OFFSET promptUserName
	call	WriteString

;Get the user's name.
	mov		edx, OFFSET userName
	mov		ecx, SIZEOF userName
	call	ReadString
	mov		byteCount, eax

;Greet the user.
	mov		edx, OFFSET greetUser
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	Crlf

;Display instructions for the user.
	mov		edx, OFFSET instruction1
	call	WriteString
	call	Crlf
	mov		edx, OFFSET instruction2
	call	WriteString
	call	Crlf

;Repeatedly prompt the user to enter a number and validate the user input.
EnterNumber:
	mov		edx, OFFSET leftBracket
	call	WriteString
	mov		eax, count
	call	WriteDec
	mov		edx, OFFSET rightBracket
	call	WriteString
	mov		edx, OFFSET promptNumber
	call	WriteString
	call	ReadInt

;Validate the user input to be in the range [-150, -1] (inclusive).
;Utilize a jump which checks status of sign flag to validate input range for terminal input.
	jns		Calculate
	cmp		eax, LOWER_LIMIT
	jl		InvalidInput

;Count and accumulate the valid user numbers until a non-negative number is entered.
	add		sum, eax
	inc		count
	mov		number, eax
	mov		eax, count
	cmp		eax, 2						;Initialize minimum and maximum with the value of the first valid number.
	je		InitializeMinimumMaximum
	mov		eax, number
	cmp		eax, minimum				;Compare the following numbers with the current minimum and maximum numbers.
	jl		NewMinimum
	cmp		eax, maximum
	jg		NewMaximum
	loop	EnterNumber

InitializeMinimumMaximum:
	mov		eax, number
	mov		minimum, eax
	mov		maximum, eax
	jmp		EnterNumber

;If the input number is less than the current minimum number, set the input number as the new minimum number.
NewMinimum:
	mov		minimum, eax
	jmp		EnterNumber

;If the input number is greater than the current maximum number, set the input number as the new maximum number.
NewMaximum:
	mov		maximum, eax
	jmp		EnterNumber

InvalidInput:
	mov		edx, OFFSET invalidMessage
	call	WriteString
	call	Crlf
	jmp		EnterNumber

Calculate:
;If no negative numbers were entered, display a special message and skip to Farewell.
	mov		eax, count
	sub		eax, 1
	jz		NoNegativeNumber

;Display the number of negative numbers entered.
	mov		edx, OFFSET displayCount1
	call	WriteString
	call	WriteDec
	mov		edx, OFFSET displayCount2
	call	WriteString
	call	Crlf

;Display the sum of negative numbers entered.
	mov		edx, OFFSET displaySum
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	Crlf

;Calculate the (rounded integer) average of the negative numbers. Round the value towards 0.
	cdq
	mov		ebx, count
	sub		ebx, 1
	idiv	ebx
	mov		average, eax

;Display the average.
	mov		edx, OFFSET displayAverage
	call	WriteString
	mov		eax, average
	call	WriteInt
	call	Crlf

;Display the range of valid numbers that was entered by the user.
	mov		edx, OFFSET displayRange1
	call	WriteString
	mov		eax, minimum
	call	WriteInt
	mov		edx, OFFSET displayRange2
	call	WriteString
	mov		eax, maximum
	call	WriteInt
	mov		edx, OFFSET displayRange3
	call	WriteString
	call	Crlf
	jmp		Farewell

NoNegativeNumber:
	mov		edx, OFFSET noNegativeNumberMessage
	call	WriteString
	call	Crlf

;Display a farewell message (which includes the user¡¯s name).
Farewell:
	mov		edx, OFFSET farewellMessage
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString

;Exit to operating system.
	exit

main ENDP

END main