TITLE Program #5 Sorting Random Integers    (program05.asm)

; Author:                Xiaoying Li
; Last Modified:         11/24/2019
; OSU email address:     lixiaoyi@oregonstate.edu
; Course number/section: CS_271_400_F2019
; Project Number:        #5              
; Due Date:              11/24/2019
; Description:           Write and test a MASM program to perform the tasks shown below. The program rejects incorrect input values.
;                            1. Introduce the program.
;                            2. Get a user request in the range [min = 15 .. max = 200].
;                            3. Generate request random integers in the range [lo = 100 .. hi = 999], storing them in consecutive elements of an array.
;                            4. Display the list of integers before sorting, 10 numbers per line.
;                            5. Sort the list in descending order (i.e., largest first).
;                            6. Calculate and display the median value, rounded to the nearest integer.
;                            7. Display the sorted list, 10 numbers per line.

INCLUDE Irvine32.inc

MIN=15
MAX=200
LO=100
HI=999

.data
programTitle	BYTE	"Sorting Random Integers", 0
programmerName	BYTE	"Programmed by Xiaoying Li", 0
instruction1	BYTE	"This program generates random numbers in the range [100 .. 999],", 0
instruction2	BYTE	"displays the original list, sorts the list, and calculates the median value.", 0
instruction3	BYTE	"Finally, it displays the list sorted in descending order.", 0
promptRequest	BYTE	"How many numbers should be generated? [15 .. 200]: ", 0
invalidMessage	BYTE	"Invalid input", 0
request			DWORD	?
array			DWORD	MAX DUP(?)
unsortedTitle	BYTE	"The unsorted random numbers:", 0
sortedTitle		BYTE	"The sorted list:", 0
spaces			BYTE	"    ", 0
medianMessage	BYTE	"The median is ", 0
goodbyeMessage	BYTE	"Thanks for using my program!", 0


.code
;----------------------------------------------------------------------------------------------------------------------------------------------------
; The main procedure consists mostly of procedure calls. It's a list of what the program will do.
;----------------------------------------------------------------------------------------------------------------------------------------------------
main PROC
	call	Randomize
	call	introduction

	push	OFFSET request
	call	getData

	push	request
	push	OFFSET array
	call	fillArray

	push	OFFSET array
	push	request
	push	OFFSET unsortedTitle
	call	displayList

	push	OFFSET array
	push	request
	call	sortList

	push	OFFSET array
	push	request
	call	displayMedian

	push	OFFSET array
	push	request
	push	OFFSET sortedTitle
	call	displayList

	call	Crlf
	mov		edx, OFFSET goodbyeMessage
	call	WriteString

	exit
main ENDP


;----------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The instroduction procedure displays program's title, programmer¡¯s name, and program's brief instructions.
; Pre-conditions: none
; Post-conditions: all introductions displayed
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

	ret
introduction ENDP


;----------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The getData procedure gets a user request in the range [15, 200], and rejects incorrect input values.
;              If user's input is out of range, re-prompts the user until they enter a value in the specified range.
; Pre-conditions: none
; Post-conditions: get valid user input
; Registers changed: eax, ebx, edx
;----------------------------------------------------------------------------------------------------------------------------------------------------
getData PROC
	push	ebp
	mov		ebp, esp
	mov		ebx, [ebp+8]	;request

;Prompt the user to enter an integer in the range [15, 200] and validate the user input.
PromptData:
	mov		edx, OFFSET promptRequest
	call	WriteString
	call	ReadInt
	cmp		eax, MIN
	jb		Invalid
	cmp		eax, MAX
	ja		Invalid
	jmp		Valid

;If user's input is out of range, display an error message and re-prompt the user until they enter a value in the specified range.
Invalid:
	mov		edx, OFFSET invalidMessage
	call	WriteString
	call	Crlf
	jmp		PromptData

;If user's input is valid, store it in the variable 'request'.
Valid:
	mov		[ebx], eax

	pop		ebp
	ret		4
getData ENDP


;----------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The fillArray procedure generates request random integers in the range [100, 999], stores them in consecutive elements of an array.
; Pre-conditions: get valid user input
; Post-conditions: store request random integers in the range [100, 999] in consecutive elements of an array
; Registers changed: eax, ecx, esi
;----------------------------------------------------------------------------------------------------------------------------------------------------
fillArray PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+12]	;request
	mov		esi, [ebp+8]	;array

;Generate random integers in the range [100, 999], stores them in consecutive elements of an array.
;Adapted from lecture 20.
AddElement:
	mov		eax, HI
	sub		eax, LO
	inc		eax
	call	RandomRange
	add		eax, LO
	mov		[esi], eax
	add		esi, 4
	loop	AddElement

	pop		ebp
	ret		8
fillArray ENDP


;----------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The sortList procedure sorts the list in descending order.
; Pre-conditions: the array is filled with request random integers in the range [100, 999]
; Post-conditions: the array is sorted in descending order
; Registers changed: eax, ecx, edx, esi
;----------------------------------------------------------------------------------------------------------------------------------------------------
sortList PROC
	push	ebp
	mov		ebp, esp

;Adapted from the textbook 'Assembly Language for x86 Processors' P374. 9.5.1. Bubble Sort.
	mov		ecx, [ebp+8]	;request
	dec		ecx

L1:
	push	ecx				;save outer loop count
	mov		esi, [ebp+12]	;array

L2:
	mov		eax, [esi]		;get array value
	cmp		[esi+4], eax	;compare a pair of values
	jb		L3				;if next value is less than current value, no exchange
	push	[esi+4]			;exchange the pair of values
	push	[esi]
	call	exchangeElements
	pop		[esi]
	pop		[esi+4]

L3:
	add		esi, 4			;move to next value
	loop	L2				;inner loop
	pop		ecx				;retriveve outer loop count
	loop	L1				;else repeat outer loop

	pop		ebp
	ret		8
sortList ENDP


;----------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The exchangeElements procedure exchanges two elements.
; Pre-conditions: two elements to be exchanged are passed to the procedure by reference
; Post-conditions: two elements are exchanged
; Registers changed: ebx
;----------------------------------------------------------------------------------------------------------------------------------------------------
exchangeElements PROC
	push	ebp
	mov		ebp, esp

	mov		ebx, [ebp+8]
	xchg	ebx, [ebp+12]
	mov		[ebp+8], ebx

	pop		ebp
	ret	
exchangeElements ENDP


;----------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The displayMedian procedure calculates and displays the median value, rounded to the nearest integer.
; Pre-conditions: the array is sorted in descending order
; Post-conditions: the median value of the array is dispalyed
; Registers changed: eax, ebx, edx, esi
;----------------------------------------------------------------------------------------------------------------------------------------------------
displayMedian PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+12]	;array

;Check if the number of elements is even or odd.
	mov		eax, [ebp+8]	;request
	mov		edx, 0
	mov		ebx, 2
	div		ebx
	cmp		edx, 0
	je		IsEven

;If the number of elements is odd, the median is the "middle" element of the sorted list. 
	mov		ebx, 4
	mul		ebx
	mov		eax, [esi+eax]
	jmp		Display

;If the number of elements is even, the median is the average of the middle two elements.
IsEven:
	mov		ebx, 4
	mul		ebx
	mov		ebx, [esi+eax]
	mov		eax, [esi+eax-4]
	add		eax, ebx
	mov		ebx, 2
	div		ebx

;Display the median value.
Display:
	call	Crlf
	mov		edx, OFFSET medianMessage
	call	WriteString
	call	WriteDec
	call	Crlf

	pop		ebp
	ret		8
displayMedian ENDP


;----------------------------------------------------------------------------------------------------------------------------------------------------
; Description: The displayList procedure displays the list of integers before and after sorting, 10 numbers per line.
; Pre-conditions: the array is filled with request random integers in the range [100, 999]
; Post-conditions: the list of integers are displayed in 10 numbers per line
; Registers changed: eax, ebx, ecx, edx, esi
;----------------------------------------------------------------------------------------------------------------------------------------------------
displayList PROC
	push	ebp
	mov		ebp, esp

;Use the title parameter to identify the two lists.
	mov		edx, [ebp+8]		;title
	call	WriteString
	call	Crlf

	mov		esi, [ebp+16]		;array
	mov		ecx, [ebp+12]		;request
	mov		ebx, 10				;column counter for displaying 10 numbers per line

DisplayElement:
	mov		eax, [esi]
	call	WriteDec
	mov		edx, OFFSET spaces
	call	WriteString
	dec		ebx
	jnz		NextElement
	call	Crlf
	mov		ebx, 10

NextElement:
	add		esi, 4
	loop	DisplayElement

	pop		ebp
	ret		12
displayList ENDP

END main