.text
.global main
.set SEVENSEG_BASEADDR, 0x4BB03000
.set BUTTON_BASEADDR, 0x4BB02004
.set TTC0, 0xF8001000

TTC0_Configure:
	LDR r1, =TTC0
	MOVw r2, #0x13
	STR r2, [r1]
	MOVw r2, #0x21
	STR r2, [r1, #0x0C]
	MOVw r2, #1080
	STR r2, [r1, #0x24]
	MOVw r2, #1
	STR r2, [r1, #0x60]
	MOVw r2, #0x22
	STR r2, [r1,#0x0C]

main:
	LDR r0, =SEVENSEG_BASEADDR
	LDR r1, =BUTTON_BASEADDR
	MOV r10, #0

Setup_SVD:
	MOVw r8, #1
	STR r8, [r0] // enable the default mode
	MOVw r8, #2
	STR r8, [r0, #0x14]// enable the decimal point after the second digit
	MOVw r7, #0 // Digit #1 On the left
	STR r7, [r0,#0x4]
	MOVw r6, #0 // Digit #2
	STR r6, [r0,#0x8]
	MOVw r5, #0 // Digit #3
	STR r5, [r0,#0xC]
	MOVw r4, #0 // Digit #4 on the right.
	STR r4, [r0,#0x10]

Wait_on_Btn0:
	LDR r8, [r1]
	MOV r9, #0x1
	CMP r8, r9
	MOV r10, #1
	BNE Wait_on_Btn0

Delay_TTC:
	LDR r1, =TTC0
	LDR r2,[r1,#0x54]
	LDR r1, =BUTTON_BASEADDR
	CMP r2, #1
	BEQ Digit_4
	B Delay_TTC

Digit_4:
	Bl Check_BTN1
	Bl Check_Btn3
	ADD r4, r4, #1
	CMP r4, #0xA
	//STR #0, [r0, #0x10]
	BEQ Digit_3
	STR r4, [r0, #0x10]
	BL Delay_TTC
	B Digit_4

Digit_3:
	MOVw r4, #0
	STR r4, [r0, #0x10]
	ADD r5, r5, #1
	CMP r5, #10
	BEQ Digit_2
	STR r5, [r0, #0xC]
	BL Delay_TTC
	B Digit_4

Digit_2: //this is one that I edited, should I change the names of the registers?
//r4 = digit 4, r5 = digit 3, r6 = digit 2, r7 = digit 1
	MOVw r4, #0 //copied value of 0 into register four, i.e. digit 4
	MOVw r5, #0 //copied value of 0 into register five, i.e. digit 3
	STR r4, [r0, #0x10] //storing the value of 0 into the digit 4 for real this time
	STR r5, [r0, #0x0C] //storing the value of 0 into the digit 3 for real this time
	ADD r6, r6, #1 //doing the same routine as digit 3
	CMP r6, #10
	BEQ Digit_1
	STR r6, [r0, #0x08] //storing value of r6 into the real register
	BL Delay_TTC
	B Digit_4
	// enter your code here

Digit_1:
	MOVw r4, #0
	MOVw r5, #0
	MOVw r6, #0
	STR r4, [r0, #0x10]
	STR r5, [r0, #0x0C]
	STR r6, [r0, #0x08]
	ADD r7, r7, #1
	CMP r7, #10
	BEQ Digit_4
	//what to branch to after this?,
	//SOMETHING HERE, BEQ Command
	STR r7, [r0, #0x04]
	BL Delay_TTC
	B Digit_4
	// enter your code here

Loop1: //this is for something to wait on button zero?
	b Loop1
	// Enter your code here.
Wait_on_Btn2:
	Bl Check_Btn3
	LDR r10, [r1]
	MOV r11, #0x4
	CMP r10, r11
	BEQ Digit_4
	b Wait_on_Btn2
	//reg10 //act as our flag
	// enter code here
Check_Btn3:
	LDR r10, [r1]
	MOV r11, #0x08
	CMP r10, r11
	BEQ reset
	bx lr
	//enter your code here
reset:
	b Setup_SVD

Check_BTN1:
	LDR r10, [r1]
	MOV r11, #0x2
	CMP r10, r11
	BEQ Wait_on_Btn2
	bx lr
	//MOV r10, #1
//enter code
endless:
	B Setup_SVD // move to the initial of the stopwatch.
.end
