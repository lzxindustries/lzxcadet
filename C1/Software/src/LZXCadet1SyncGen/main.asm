/***************************************************************************
* Description     : Sync Generator 2.0
* HW-Environment  : AVR MCU ATmega88A
*                   
*                   
* SW-Environment  : Atmega Studio 7.0						
* Author          : Ed Leckie
*				  : Revisions by Lars Larsen
*
* Revision list:
****************************************************************************/
//.include "m168def.inc"
//.include "m328Pdef.inc"
.include "m88Adef.inc"
;*********************************************************
;*	Byte access anywhere in IO or data space
;* 	STORE - Store register in IO or data space
;* 	LOAD  - Load register from IO or data space
;*********************************************************

.MACRO STORE 		;Arguments: Address, Register
	.IF	@0>0x3F
		sts	@0, @1
	.ELSE
		out	@0, @1
	.ENDIF
.ENDMACRO
//
//.MACRO LOAD 		;Arguments: Register, Address
//	#if	@1>0x3F
//		lds	@0, @1
//	#else
//		in	@0, @1
//	#endif
//.ENDMACRO

//#define F_CPU 14318180 //4xNTSC
//#define F_CPU 8000000
//#define F_CPU 16000000
#define F_CPU 13500000

/*Timing*/
//NTSC
#define NTSCLineTime ((F_CPU/15734)-1)
#define NTSCLineTimeH NTSCLineTime>>8
#define NTSCLineTimeL NTSCLineTime&0xFF
#define NTSCHalfLineTime NTSCLineTime/2
#define NTSCHalfLineTimeH NTSCHalfLineTime>>8
#define NTSCHalfLineTimeL NTSCHalfLineTime&0xFF
#define NTSClongsync F_CPU*27/1000000
#define NTSCshortsync F_CPU*2.54/1000000
//#define NTSCshortsync F_CPU*2/1000000
//#define NTSCnormsync F_CPU*4.7/1000000
#define NTSCnormsync F_CPU*5/1000000
#define NTSCF1preeqpulses 6
#define NTSCF1Vertsyncpulses 6
#define NTSCF1posteqpulses 6
//#define NTSCF1preActiveVideolines 16
#define NTSCF1preActiveVideolines 13
//#define NTSCF1ActiveVideolines 237
#define NTSCF1ActiveVideolines 237
#define NTSCF2preeqpulses 7
#define NTSCF2Vertsyncpulses 6
#define NTSCF2posteqpulses 5
//#define NTSCF2preActiveVideolines 16
//#define NTSCF2ActiveVideolines 238
#define NTSCF2preActiveVideolines 14
#define NTSCF2ActiveVideolines 237
#define NTSCBlankTime F_CPU*10/1000000
#define NTSCBlankStart 0x45
#define NTSCLineTimeX8 NTSCLineTime/8
#define NTSCLineTimeX10 4*NTSCLineTime/42

//
// NTSC
//
// Back-porch 1.5us
// Sync 4.7us
// front-porch 4.7us




// Field 1 (63.5us)
// 6 pre-equalizing pulses (0.04H) @ 31.75us
// 6 vert sync pulses (0.07H) @ 31.75us
// 6 post-equalizing pulses (0.04H) @ 31.75us
// 253.5 @ 63.5  
// Field 2 (63.5us)
// 6 pre-equalizing pulses (0.04H) @ 31.75us
// 6 vert sync pulses (0.07H) @ 31.75us
// 5 post-equalizing pulses (0.04H) @ 31.75us
// 254

//PAL
//#define PALLineTime ((F_CPU/15625) - 1)
//#define PALLineTime 511
#define PALLineTime ((F_CPU/15625) - 1)
#define PALLineTimeH PALLineTime>>8
#define PALLineTimeL PALLineTime&0xFF
//#define PALHalfLineTime (((PALLineTime+1)/2)-1)
#define PALHalfLineTime PALLineTime/2
#define PALHalfLineTimeH PALHalfLineTime>>8
#define PALHalfLineTimeL PALHalfLineTime&0xFF
#define PALlongsync F_CPU*27/1000000
#define PALshortsync F_CPU*22/10000000
#define PALnormsync F_CPU*44/10000000
#define PALF1preeqpulses 6
#define PALF1Vertsyncpulses 5
#define PALF1posteqpulses 5
//#define PALF1preActiveVideolines 17
#define PALF1preActiveVideolines 22
//#define PALF1ActiveVideolines 288
#define PALF1ActiveVideolines 280
#define PALF2preeqpulses 5
#define PALF2Vertsyncpulses 5
#define PALF2posteqpulses 4
//#define PALF2preActiveVideolines 17
#define PALF2preActiveVideolines 22
//#define PALF2ActiveVideolines 288
#define PALF2ActiveVideolines 280
#define PALBlankTime F_CPU*12/1000000
#define PALBlankStart 0x45
#define PALLineTimeX8 PALLineTime/8
#define PALLineTimeX10 4*PALLineTime/42

//Atmega8
#define SyncOut             PORTB
#define SyncOutDDR             DDRB
#define SyncC               2    //OCR1B
#define Out_nOdd_Even         0    //
//#define Blank               1    //OCR1A
#define SyncH               1    //OCR1A

//Atmega8
#define SyncInput           PIND
#define SyncInputOut        PORTD
#define SyncInputDDR        DDRD
#define Out_nSyncV			7	 //PD7
#define InSyncV             2    //INT0/PD2
//#define InSyncH             3    //INT1/PD3/OC2B
#define OutBurst            3    //INT1/PD3/OC2B
#define InOdd_Even 			4    //PD4
#define Out_nBlank			5	 //PD5/0C0B
#define EXT_GENLOCK			0	 //PD0
#define EXT_LED				1	 //PD1
#define Out_Odd_nEven		6	 //PD6

#define LinePortIn			PINC
#define LinePortOut			PORTC
#define LinePortDDR			DDRC
#define LineX8				3	//PC3 Blue
#define LineX2				4	//PC4 Green 
#define LineX4				5	//PC5 Red
#define NTSC_PAL_N			0	//PC0

// Burst/Back Porch 4.8us long.

/* Timings */
/* Vertical */
#define F1preeqpulses          r6
#define F1vertsyncpulses       r7
#define F1posteqpulses         r8
#define F1preActiveVideolines  r9
#define F2preeqpulses          r10
#define F2vertsyncpulses       r11
#define F2posteqpulses         r12
#define F2preActiveVideolines  r13
#define F1ActiveVideolines     r24
#define F1ActiveVideolinesL    F1ActiveVideolines
#define F1ActiveVideolinesH    r25

#define F2ActiveVideolines     r16
#define F2ActiveVideolinesL    F2ActiveVideolines
#define F2ActiveVideolinesH    r17
/*Horizontal */
#define BlankTime              r3
#define ShortSyncTime          r14
#define NormSyncTime           r15
#define LongSyncTime           r4
#define LongSyncTimeL          LongSyncTime
#define LongSyncTimeH          r5
#define LineTime               r28
#define LineTimeL              LineTime
#define LineTimeH              r29
#define HalfLineTime     		r30
#define HalfLineTimeL     		HalfLineTime
#define HalfLineTimeH     		r31

/* Counters */
#define syncstate                r19
#define nextframestate           12
#define f1vertsyncstate          11
#define f1posteqpulsestate       10
#define f1preactivevideostate    9
#define f1activevideostate       8
#define f1postactivevideostate   7
#define f2preeqpulsestate        6
#define f2vertsyncstate          5
#define f2posteqpulsestate       4
#define f2preactivevideostate    3
#define f2activevideostate       2
#define f2postactivevideostate   1
#define f1preeqpulsestate        0

/*Misc */

#define acc                    r22
#define accH                   r23
#define NextLineTime           r20
#define NextLineTimeL          NextLineTime
#define NextLineTimeH          r21
#define Counter                r26
#define CounterL               Counter
#define CounterH               r27

#define Genlock                r2

#define VideoMode              r1
#define VideoMode_NTSC_PAL_N   4
//VideoMode bit 2 to 0 colour bar counter during blanking
#define ShortSync              r18
#define NextSyncIsShort		   0x0
#define NextSyncIs2ndShort	   0x1
//#define ShortSyncNotUpdated	   0x2
#define ShortSyncUpdated	   0x2
#define VSyncRisingEdge	   	   0x4

rjmp RESET		; Reset Handler
.org INT0addr
rjmp VSYNC
.org INT1addr
rjmp VSYNC
.org OVF2addr
rjmp TIM2_OVF 	; Timer2 Overflow Handler
.org OC1Aaddr
rjmp TIM1_OCA 	; Timer1 Output compare A Handler
.org OVF1addr
rjmp TIM1_OVF 	; Timer1 Overflow Handler
//.org OC0addr
//rjmp TIM0_OC 	; Timer0 Output compare Handler


TIM2_OVF:
	ldi acc, 0x7
	and acc, VideoMode
	brne TIM2_OVF_RET
	cpi syncstate, f1activevideostate
	breq TIM2_OVF_INC_ADD2
	cpi syncstate, f2activevideostate
	breq TIM2_OVF_INC
	reti
TIM2_OVF_INC_ADD2:
	nop
	nop
TIM2_OVF_INC:
/*
	in acc,LinePortOut
	ldi accH, (1<<LineX8)
	add acc, accH
	andi acc, (1<<LineX8)|(1<<LineX4)|(1<<LineX2)
	out LinePortOut,acc
	reti
*/
	sbis LinePortOut,LineX8
	rjmp TIM2_OVF_INC2
	cbi LinePortOut,LineX8
	nop
	nop
	nop
	nop
	reti
TIM2_OVF_INC2:
	in acc, LinePortOut
	// LineX4 is Red (PC5)
	sbrs acc, LineX4
	rjmp TIM2_OVF_INC3
	ori acc, (1<<LineX8)
	andi acc, ~(1<<LineX4)
	out LinePortOut,acc
	reti
TIM2_OVF_INC3:
	//Line X2 is Green (PC4)
	sbrs acc, LineX2
	rjmp TIM2_OVF_INC4
	ldi acc, (1<<LineX8)|(1<<LineX4) 
	out LinePortOut,acc
	reti
TIM2_OVF_INC4:
	//Line X2 is Green (PC4)
	ldi acc, (1<<LineX8)|(1<<LineX4)|(1<<LineX2)
	out LinePortOut,acc
	reti

TIM2_OVF_RET:
	dec VideoMode
	reti

/*
TIM3_OVF:
  //If genlock == 0 then switch to internal sync
  tst genlock
  brne DEC_GEN
  reti
  //Else decrement genlock
DEC_GEN: 
  mov acc,genlock
  subi acc, 0x1
  mov genlock, acc
  reti
*/

HSYNC:
  //in acc,SyncInput
  //andi acc,(1<<InSyncH)
  //cpi acc, 0x0
  //breq HSYNC_CLR
  //sbi SyncOut, SyncH
  //reti
//HSYNC_CLR:
  //cbi SyncOut, SyncH
  //in LineTimeH,TCNT1H
  //in LineTimeL,TCNT1L
  //out TCNT1H,LineTimeH
  //out TCNT1L,LineTimeL
  ldi accH, 0x0
  ldi acc, 0x0f
  STORE TCNT1H,accH
  STORE TCNT1L,acc
  rjmp TIM1_OVF


VSYNC:
//  in acc,SyncInput
//  andi acc,(1<<InSyncV)
//  cpi acc, 0x0
  sbis SyncInput, InSyncV
  rjmp VSYNC_CLR
  //sbi SyncOut, SyncV
  cbi SyncInputOut, Out_nSyncV
  sbr ShortSync, (1<<VSyncRisingEdge)
  reti
VSYNC_CLR:
  //cbi SyncOut, SyncV
  sbi SyncInputOut, Out_nSyncV
  reti

// ShortSync - Status
// 0x0 - No more Short Syncs
// 0x1 - ShortSync 
// 0x2 - ShortSync 2nd
// 0x4 - ShortSyncUpdated

TIM1_OCA:
  sbrs ShortSync,NextSyncIsShort
  rjmp TIM1A_NORM
  sbrs ShortSync,NextSyncIs2ndShort
  rjmp TIM1A_IGNORESYNC
  //ldi acc,((1<<COM1A1)|(1<<COM1B1)|(1<<COM1B0)|(1<<WGM11)) //mode14, set on compare match clear at TOP
  ldi acc,((1<<COM1A1)|(1<<COM1B1)|(1<<WGM11)) //mode14, clear on compare match set at TOP
  STORE TCCR1A,acc
  cbr ShortSync,(1<<NextSyncIs2ndShort)
  rjmp TIM1A_RET  
TIM1A_IGNORESYNC:
  cbi   SyncOut,SyncH
  //Keep Hsync high for one
  //ldi acc,((1<<COM1B1)|(1<<COM1B0)|(1<<WGM11)) //mode14, set on compare match clear at TOP
  ldi acc,((1<<COM1B1)|(1<<WGM11)) //mode14, clear on compare match set at TOP
  STORE TCCR1A,acc
  sbr ShortSync,(1<<NextSyncIs2ndShort)
  rjmp TIM1A_RET  
TIM1A_NORM:
  //ldi acc,((1<<COM1A1)|(1<<COM1B1)|(1<<COM1B0)|(1<<WGM11)) //mode14, set on compare match clear at TOP
  ldi acc,((1<<COM1A1)|(1<<COM1B1)|(1<<WGM11)) //mode14, clear on compare match set at TOP
  STORE TCCR1A,acc  
TIM1A_RET:  
  cbr  ShortSync,(1<<ShortSyncUpdated)
  reti



//ISR exectued every CSync
TIM1_OVF:
	//cbi  SyncInputOut, EXT_LED
	sbrs VideoMode, VideoMode_NTSC_PAL_N
	rjmp TIM1_PAL_NOPRESCALERCLR
	//NTSC
	ldi	acc, (1<<PSRASY)|(1<<PSRSYNC)
	STORE GTCCR, acc
	ldi acc,((1<<WGM22)) // stop clk 7 Fast PWM
	STORE TCCR2B,acc
	ldi acc,((1<<TOV2)) // stop clk 7 Fast PWM
	STORE TIFR2,acc
	// /NTSC
	// PALBlankStart - 0x40 
	ldi acc, 0x04
	STORE TCNT0, acc
	//Colour bar start
	ldi acc, 0x34
	STORE TCNT2, acc
	ldi acc,((1<<WGM22)|(1<<CS20)) // clk/1 mode 7 Fast PWM
	STORE TCCR2B,acc
//	ldi acc, 0x2
	ldi acc, 0x1
	or  VideoMode, acc
	cbi	LinePortOut, LineX8
	cbi	LinePortOut, LineX4
	cbi	LinePortOut, LineX2
	rjmp TIM1_NEXTLINE

TIM1_PAL_NOPRESCALERCLR:
	// PALBlankStart - 0x40 
	ldi acc, 0x05
	STORE TCNT0, acc
	//Colour bar start
	//Stop Timer2
    //colour bar timer2
	ldi acc,((1<<WGM22)) // stop clk 7 Fast PWM
	STORE TCCR2B,acc
	ldi acc,((1<<TOV2)) // stop clk 7 Fast PWM
	STORE TIFR2,acc
	ldi acc, 0x3C
	STORE TCNT2, acc
    //colour bar timer2
	ldi acc,((1<<WGM22)|(1<<CS20)) // clk/1 mode 7 Fast PWM
	STORE TCCR2B,acc
	//ldi acc, 0x2
	ldi acc, 0x1
	or  VideoMode, acc
	cbi	LinePortOut, LineX8
	cbi	LinePortOut, LineX4
	cbi	LinePortOut, LineX2


TIM1_NEXTLINE:
  //out OCR1BH,NextSyncTimeH
  //out OCR1BL,NextSyncTimeL
  STORE ICR1H,NextLineTimeH
  STORE ICR1L,NextLineTimeL
  //ori  ShortSync,(1<<ShortSyncNotUpdated)
  //Check for Vsync if EXT_GENLOCK enabled
  sbic SyncInput, EXT_GENLOCK
  rjmp TIM1_VSYNCCHECK
  //Clear Ext Sync LED
  cbi  SyncInputOut, EXT_LED
  clr  Genlock
  rjmp TIM1_CNT
//Check for rising edge of Vsync ODD frame
//  sbrs ShortSync, VSyncRisingEdge
TIM1_VSYNCCHECK:
//Alternate Check for rising edge of Vsync ODD frame INTF0 in EIFR
  sbis EIFR, INTF0
  rjmp TIM1_CNT
  sbi  EIFR, INTF0
  //Set Ext Sync LED
  sbi  SyncInputOut, EXT_LED
  clr  Genlock
  //Short Sync
  sbrs ShortSync, NextSyncIsShort
  rjmp TIM1_FIELD
  sbrs ShortSync, NextSyncIs2ndShort
  rjmp TIM1_CNT
TIM1_FIELD:
  cbr ShortSync, (1<<VSyncRisingEdge)
  sbis SyncInput, InOdd_Even
  rjmp TIM1_CNT
//Check for Video Mode
  sbrs VideoMode, VideoMode_NTSC_PAL_N
  rjmp TIM1_PAL
// NTSC
  ldi  CounterH,0x00
  ldi  CounterL,0x03
  ldi  syncstate, f1posteqpulsestate
// /NTSC
  rjmp TIM1_CNT
TIM1_PAL:
//PAL
  ldi  syncstate, f1preactivevideostate
  rjmp F1preactivevideo
// /PAL

TIM1_CNT:  
  sbiw Counter,0x01	
  brne vend
  //Change State
  subi syncstate,0x01
//  breq F1preeq
  cpi  syncstate,f1vertsyncstate
  brne f1poep
  rjmp F1vertsync
  f1poep: 
  cpi  syncstate,f1posteqpulsestate
  brne f1prav
  rjmp F1posteq
  f1prav:
  cpi  syncstate,f1preactivevideostate
  brne f1av
  rjmp F1preactivevideo
  f1av:
  cpi  syncstate,f1activevideostate
  brne f1poav
  rjmp F1activevideo 
  f1poav:
  cpi  syncstate,f1postactivevideostate
  brne f2prep
  rjmp F1postactivevideo 
  f2prep:
  cpi  syncstate,f2preeqpulsestate
  brne f2vs
  rjmp F2preeq 
  f2vs:
  cpi  syncstate,f2vertsyncstate
  brne f2poep
  rjmp F2vertsync
  f2poep:
  cpi  syncstate,f2posteqpulsestate
  brne fprav
  rjmp F2posteq
  fprav:
  cpi  syncstate,f2preactivevideostate
  brne f2av
  rjmp F2preactivevideo
  f2av:
  cpi  syncstate,f2activevideostate
  brne f2poav
  rjmp F2activevideo 
  f2poav:
  cpi  syncstate,f2postactivevideostate
  brne f1prep
  rjmp F2postactivevideo 
  f1prep:
  rjmp F1preeq
  Vend:
  reti



F1vertsync:
  // Clear SyncV 
  //Set vert sync to 30us
  STORE OCR1BH,LongSyncTimeH
  STORE OCR1BL,LongSyncTimeL
  //cbi  SyncOut,SyncV
  sbi  SyncOut,Out_nOdd_Even
  cbi  SyncInputOut,Out_Odd_nEven
  sbi  SyncInputOut,Out_nSyncV
  ldi  CounterH,0x00
  mov  CounterL,F1vertsyncpulses
  inc  Genlock
  ldi  acc, 0xF
  and  Genlock,acc
  //Set LED
  sbi  SyncInputOut, EXT_LED
  sbrc Genlock, 3
  cbi  SyncInputOut, EXT_LED
  //else Clear LED
  rjmp vend

F1posteq:
  // Set SyncV 
  //cbi  SyncOut,SyncV
//  sbi  SyncOut,SyncV
  //Set sync to 2us
  ldi accH,0x0
  STORE OCR1BH,accH
  STORE OCR1BL,ShortSyncTime
  ldi  CounterH,0x00
  mov  CounterL,F1posteqpulses
  rjmp vend

F1preActiveVideo:
  //Set sync to 4us
  ldi accH,0x00
  STORE OCR1BH,accH
  STORE OCR1BL,NormSyncTime
  STORE OCR1AH,accH
  STORE OCR1AL,NormSyncTime  
  // Set SyncV 
  //sbi  SyncOut,SyncV
  cbi  SyncInputOut,Out_nSyncV
  //Set Frequency to be 64us
  movw NextLineTime, LineTime
  //Enable HSYNC
//  clr  ShortSync
  sbr ShortSync,(1<<ShortSyncUpdated)
  cbr ShortSync,(1<<NextSyncIsShort)|(1<<NextSyncIs2ndShort)
  ldi  CounterH,0x00
  mov  CounterL,F1preActiveVideolines
  rjmp vend

F1ActiveVideo:
  //Enable Video
//  ldi accH,0x00
//  STORE OCR1AH,accH
//  STORE OCR1AL,BlankTime  
  STORE OCR0B,BlankTime  
  //Set number of Active Lines
  mov  CounterH,F1ActiveVideolinesH
  mov  CounterL,F1ActiveVideolinesL
  rjmp vend

F1PostActiveVideo:
  //Disable Video
  ldi accH,0xFF
//  STORE OCR1AH,accH
//  STORE OCR1AL,BlankTime  
  STORE OCR0B,accH  
  //Set number of post-Active Lines
  ldi  CounterH,0x00
  ldi  CounterL,0x03
  rjmp vend

F2preeq:
  //Disable blanking timer
  //Setup Short Sync
  //sbi  SyncOut, SyncV
  movw NextLineTime, HalfLineTime
//  ldi  ShortSync, (1<<NextSyncIsShort)
  sbr ShortSync, (1<<ShortSyncUpdated)|(1<<NextSyncIsShort)
  sbr ShortSync, (1<<NextSyncIs2ndShort)
  //Set short sync (2us)
  ldi accH,0x0
  STORE OCR1BH,accH
  STORE OCR1BL,ShortSyncTime
  ldi  CounterH,0x00
  mov  CounterL,F2preeqpulses
  rjmp vend

F2vertsync:
  // Clear SyncV 
  //Set vert sync to 30us
  STORE OCR1BH,LongSyncTimeH
  STORE OCR1BL,LongSyncTimeL
  //cbi  SyncOut,SyncV
  cbi  SyncOut,Out_nOdd_Even
  sbi  SyncInputOut,Out_Odd_nEven
  sbi  SyncInputOut,Out_nSyncV
  ldi  CounterH,0x00
  mov  CounterL,F2vertsyncpulses
  //ldi  syncstate, 0x5
  rjmp vend

F2posteq:
  // Set SyncV 
  //cbi  SyncOut,SyncV
  sbi  SyncInputOut,Out_nSyncV
//  sbi  SyncOut,SyncV
  //Set sync to 2us
  ldi accH,0x0
  STORE OCR1BH,accH
  STORE OCR1BL,ShortSyncTime
  ldi  CounterH,0x00
  mov  CounterL,F2posteqpulses
  rjmp vend

F2preActiveVideo:
  //Set sync to 4us
  ldi accH,0x00
  STORE OCR1BH,accH
  STORE OCR1BL,NormSyncTime
  STORE OCR1AH,accH
  STORE OCR1AL,NormSyncTime  
  // Set SyncV 
  cbi  SyncInputOut,Out_nSyncV
  //Set Frequency to be 64us
  movw NextLineTime, LineTime
  //clr  ShortSync
  sbr ShortSync,(1<<ShortSyncUpdated)
  cbr ShortSync,(1<<NextSyncIsShort)|(1<<NextSyncIs2ndShort)
  ldi  CounterH,0x00
  mov  CounterL,F2preActiveVideolines
  rjmp vend

F2ActiveVideo:
  //Enable Video
//  ldi accH,0x00
//  STORE OCR1AH,accH
//  STORE OCR1AL,BlankTime  
  STORE OCR0B,BlankTime  
  //Set number of Active Lines
  mov  CounterH,F2ActiveVideolinesH
  mov  CounterL,F2ActiveVideolinesL
  rjmp vend

F2PostActiveVideo:
  //Disable Video
  ldi accH,0xFF
//  STORE OCR1AH,accH
//  STORE OCR1AL,BlankTime 
  out OCR0B,accH
  //Set number of post-Active Lines
  ldi  CounterH,0x00
  ldi  CounterL,0x03
  rjmp vend

F1preeq:
  //Disable blanking timer
//  ldi accH,0xFF
//  out OCR1AH,accH
//  out OCR1AL,BlankTime  
//  ldi acc,((1<<COM1B1)|(1<<COM1B0)|(1<<WGM11)) //mode14, set on compare match clear at TOP
//  out TCCR1A,acc
  //Setup Short Sync
  cbi  SyncInputOut, Out_nSyncV
  //Set Frequency to be half (32us)
  movw NextLineTime, HalfLineTime
//  ldi  ShortSync, (1<<NextSyncIsShort)
  sbr ShortSync, (1<<ShortSyncUpdated)|(1<<NextSyncIsShort)
  sbr ShortSync, (1<<NextSyncIs2ndShort)
  //Set short sync (2us)
  ldi accH,0x0
  STORE OCR1BH,accH
  STORE OCR1BL,ShortSyncTime
  ldi  CounterH,0x00
  mov  CounterL,F1preeqpulses
  ldi  syncstate, nextframestate
  rjmp vend


;*************************************




;*************************************
RPALx50Hz: /* For PAL 625 lines @50Hz the synchro signals are negative polarised */
    //PWM for CSYNC and HSYNC
	ldi acc,((1<<WGM13)|(1<<WGM12)|(1<<CS10)) // clk/1
	STORE TCCR1B,acc
	//ldi acc,((1<<COM1A1)|(1<<COM1A0)|(1<<COM1B1)|(1<<COM1B0)|(1<<WGM11)) //mode14, set on compare match clear at TOP
	ldi acc,((1<<COM1A1)|(1<<COM1A0)|(1<<COM1B1)|(1<<WGM11)) //mode14, clear on compare match set at TOP
	STORE TCCR1A,acc
    //PWM for BLANK
	ldi acc,((1<<WGM02)|(1<<CS01)) // clk/8 mode 7 Fast PWM
	STORE TCCR0B,acc
	//ldi acc,((1<<COM0B1)|(1<<COM0B0)|(1<<WGM01)|(1<<WGM00)) //mode7, Fast PWM set on compare match clear at TOP
	ldi acc,((1<<COM0B1)|(1<<WGM01)|(1<<WGM00)) //mode7, Fast PWM clear on compare match set at TOP
	STORE TCCR0A,acc

    //colour bar timer2
	//ldi acc,((1<<WGM22)|(1<<CS21)) // clk/8 mode 7 Fast PWM
	ldi acc,((1<<WGM22)|(1<<CS20)) // clk/1 mode 7 Fast PWM
	STORE TCCR2B,acc
	ldi acc,((1<<WGM21)|(1<<WGM20)) //mode7, Fast PWM OC2A disconnected
	STORE TCCR2A,acc

	//Setup Registers with PAL Settings
	ldi acc,PALF1preeqpulses
	mov F1preeqpulses, acc
	ldi acc,PALF1Vertsyncpulses
	mov F1vertsyncpulses, acc
	ldi acc,PALF1posteqpulses
	mov F1posteqpulses, acc
	ldi acc,PALF1preActiveVideolines
	mov F1preActiveVideolines, acc
	ldi acc,PALF2preeqpulses
	mov F2preeqpulses, acc
	ldi acc,PALF2Vertsyncpulses
	mov F2vertsyncpulses, acc
	ldi acc,PALF2posteqpulses
	mov F2posteqpulses, acc
	ldi acc,PALF2preActiveVideolines
	mov F2preActiveVideolines,acc
	ldi acc,PALnormsync
	mov NormSyncTime, acc
	ldi acc,PALshortsync
	mov ShortSyncTime, acc
	ldi acc,PALlongsync>>8
	mov LongSyncTimeH, acc
	ldi acc,PALlongsync&0xFF
	mov LongSyncTimeL, acc
	ldi F1ActiveVideolinesH,PALF1ActiveVideolines>>8
	ldi F1ActiveVideolinesL,PALF1ActiveVideolines&0xFF
	ldi F2ActiveVideolinesH,PALF2ActiveVideolines>>8
	ldi F2ActiveVideolinesL,PALF2ActiveVideolines&0xFF
	ldi LineTimeH, PALLineTimeH
	ldi LineTimeL, PALLineTimeL
	ldi HalfLineTimeH, PALHalfLineTimeH
	ldi HalfLineTimeL, PALHalfLineTimeL

	ldi acc, (PALLineTime>>3)&0xff
	STORE OCR0A, acc
	ldi acc, (PALBlankTime>>3)&0xff
	mov BlankTime, acc
	STORE OCR0B, acc
	//Colour Bar
	//ldi acc, (PALLineTimeX8>>3)&0xff
	ldi acc, (PALLineTimeX10)&0xff
	STORE OCR2A, acc

	//Set Timer Period (initally to Half line)
	STORE ICR1H,HalfLineTimeH
	STORE ICR1L,HalfLineTimeL
	movw NextLineTime, HalfLineTime
	//Set Sync Time to Long Sync
	STORE OCR1BH,LongSyncTimeH
	STORE OCR1BL,LongSyncTimeL

	//Blank Width (Greater than Timer count to disable)
	ldi accH,0x00 //0xff
	ldi acc,PALBlankTime
	//mov BlankTime,acc
	STORE OCR1AH,accH
	STORE OCR1AL,acc

	//Load F1vertsyncpulses
	ldi  CounterH,0x00
	mov  CounterL,F1vertsyncpulses

	ldi  syncstate, f1vertsyncstate

	ldi acc, 0x0
	STORE TCNT1H, acc
	STORE TCNT1L, acc
	
	ldi acc, PALBlankStart
	STORE TCNT0, acc
	//Colour bar start
	ldi acc, PALBlankStart
	STORE TCNT2, acc

	ret

;*************************************
RNTSC: /* For NTSC 525 lines 29.97 fps*/

    //PWM
    ldi acc,((1<<WGM13)|(1<<WGM12)|(1<<CS10)) // clk/1
    STORE TCCR1B,acc
    //ldi acc,((1<<COM1A1)|(1<<COM1A0)|(1<<COM1B1)|(1<<COM1B0)|(1<<WGM11)) //mode14, set on compare match clear at TOP
    ldi acc,((1<<COM1A1)|(1<<COM1A0)|(1<<COM1B1)|(1<<WGM11)) //mode14, clear on compare match set at TOP
    STORE TCCR1A,acc

    //PWM for BLANK
	ldi acc,((1<<WGM02)|(1<<CS01)) // clk/8 mode 7 Fast PWM
	STORE TCCR0B,acc
	//ldi acc,((1<<COM0B1)|(1<<COM0B0)|(1<<WGM01)|(1<<WGM00)) //mode7, Fast PWM set on compare match clear at TOP
	ldi acc,((1<<COM0B1)|(1<<WGM01)|(1<<WGM00)) //mode7, Fast PWM clear on compare match set at TOP
	STORE TCCR0A,acc
    //colour bar timer2
	//ldi acc,((1<<WGM22)|(1<<CS21)) // clk/8 mode 7 Fast PWM
	ldi acc,((1<<WGM22)|(1<<CS20)) // clk/1 mode 7 Fast PWM
	STORE TCCR2B,acc
	ldi acc,((1<<WGM21)|(1<<WGM20)) //mode7, Fast PWM OC2A disconnected
	STORE TCCR2A,acc

	//Setup Registers with NTSC Settings
	ldi acc,NTSCF1preeqpulses
	mov F1preeqpulses, acc
	ldi acc,NTSCF1Vertsyncpulses
	mov F1vertsyncpulses, acc
	ldi acc,NTSCF1posteqpulses
	mov F1posteqpulses, acc
	ldi acc,NTSCF1preActiveVideolines
	mov F1preActiveVideolines, acc
	ldi acc,NTSCF2preeqpulses
	mov F2preeqpulses, acc
	ldi acc,NTSCF2Vertsyncpulses
	mov F2vertsyncpulses, acc
	ldi acc,NTSCF2posteqpulses
	mov F2posteqpulses, acc
	ldi acc,NTSCF2preActiveVideolines
	mov F2preActiveVideolines,acc
	ldi acc,NTSCnormsync
	mov NormSyncTime, acc
	ldi acc,NTSCshortsync
	mov ShortSyncTime, acc
	ldi acc,NTSClongsync>>8
	mov LongSyncTimeH, acc
	ldi acc,NTSClongsync&0xFF
	mov LongSyncTimeL, acc
	ldi F1ActiveVideolinesH,NTSCF1ActiveVideolines>>8
	ldi F1ActiveVideolinesL,NTSCF1ActiveVideolines&0xFF
	ldi F2ActiveVideolinesH,NTSCF2ActiveVideolines>>8
	ldi F2ActiveVideolinesL,NTSCF2ActiveVideolines&0xFF
	ldi LineTimeH, NTSCLineTimeH
	ldi LineTimeL, NTSCLineTimeL
	ldi HalfLineTimeH, NTSCHalfLineTimeH
	ldi HalfLineTimeL, NTSCHalfLineTimeL

	ldi acc, (NTSCLineTime>>3)&0xff
	//ldi acc, 126
	STORE OCR0A, acc
	ldi acc, (NTSCBlankTime>>3)&0xff
	//ldi acc, 20
	mov BlankTime, acc
	STORE OCR0B, acc
	//Colour Bar
	//ldi acc, (NTSCLineTimeX10>>3)&0xff
	ldi acc, (NTSCLineTimeX10)&0xff
	STORE OCR2A, acc

	//Set Timer Period (initally to Half line)
	STORE ICR1H,HalfLineTimeH
	STORE ICR1L,HalfLineTimeL
	movw NextLineTime, HalfLineTime
	//Set Sync Time to Long Sync
	STORE OCR1BH,LongSyncTimeH
	STORE OCR1BL,LongSyncTimeL

	//Blank Width (Greater than Timer count to disable)
	ldi accH,0xFF
	ldi acc,NTSCBlankTime
	//mov BlankTime,acc
	STORE OCR1AH,accH
	STORE OCR1AL,acc

	//Load F1vertsyncpulses
	ldi  CounterH,0x00
	mov  CounterL,F1vertsyncpulses

	//Set F1vertsyncstate
	ldi  syncstate, f1vertsyncstate


	ldi acc, 0x0
	STORE TCNT1H, acc
	STORE TCNT1L, acc

	ldi acc, NTSCBlankStart
	STORE TCNT0, acc
	//Colour bar start
	ldi acc, NTSCBlankStart
	STORE TCNT2, acc

	ret
               
// Field 1 (63.5us)
// 6 pre-equalizing pulses (0.04H) @ 31.75us
// 6 vert sync pulses (0.07H) @ 31.75us
// 6 post-equalizing pulses (0.04H) @ 31.75us
// 253.5 @ 63.5  
// Field 2 (63.5us)
// 6 pre-equalizing pulses (0.04H) @ 31.75us
// 6 vert sync pulses (0.07H) @ 31.75us
// 5 post-equalizing pulses (0.04H) @ 31.75us
// 254

;*************************************

;*************************************
; Main function: initializations followed by an endless loop

RESET:         
               ldi   acc, low(RAMEND)   ; Main program start
               out   SPL, acc 		; Set Stack Pointer to top of RAM
               ldi   acc, high(RAMEND)   ; Main program start
               out   SPH, acc 		; Set Stack Pointer to top of RAM

               /* Synchro signals as outputs */
               //sbi   SyncOutDDR,SyncV
			   sbi	 SyncInputDDR,Out_nSyncV
			   sbi	 SyncInputDDR,Out_Odd_nEven
			   sbi	 SyncInputDDR,EXT_LED
			   sbi	 SyncInputOut,EXT_LED	//Set LED for test
			   // OC0B Blanking timer
			   sbi	 SyncInputDDR,Out_nBlank
			   // OC2B Burst timer
			   sbi	 SyncInputDDR,OutBurst
               sbi   SyncOutDDR,SyncC
               //sbi   SyncOutDDR,Blank
			   //sbi   SyncOut,Blank
               sbi   SyncOutDDR,SyncH
			   //sbi   SyncOut,SyncH
			   cbi   SyncOut,SyncH
               sbi   SyncOutDDR,Out_nOdd_Even

			   //Set Colour Bar Outputs
			   sbi	 LinePortDDR, LineX8
			   sbi	 LinePortDDR, LineX4
			   sbi	 LinePortDDR, LineX2
			   cbi	 LinePortOut, LineX8
			   cbi	 LinePortOut, LineX4
			   cbi	 LinePortOut, LineX2
			   
			   //External Sync
			   //Set Hsync INT0
			   //Set Vsync INT1
			   ldi	acc, 0x0
			   mov	VideoMode, acc
			   ldi	acc, (1<<VideoMode_NTSC_PAL_N) //Hardwired as PAL
			   sbic LinePortIn, NTSC_PAL_N
			   mov	VideoMode, acc
			   sbrc VideoMode, VideoMode_NTSC_PAL_N
			   rjmp SetupNTSC
			   //Setup Internal Sync
	           rcall RPALx50Hz
			   rjmp SetupGenlockTimer
	           
SetupNTSC:	   rcall RNTSC

SetupGenlockTimer:			  
			   // Clear Genlock register
			   clr Genlock
               // Enable interrupt for RGB disable/enable toggling
               //Interrupt for Internal Sync/blanking
// Genlock timeout interrupt counter cleared every interrupt from Timer1 or INT0 or INT1.
//               ldi   acc,(1<<TOIE2)
//               STORE   TIMSK2,acc
               ldi   acc,(1<<TOIE1)|(1<<OCIE1A)
               STORE   TIMSK1,acc
			   // Colour bar interrupt
               ldi   acc,(1<<TOIE2)
               STORE   TIMSK2,acc
				//Enable Vsync interrupt enable.
//               ldi   acc,(1 << INT1)
//               STORE   EIMSK,acc
				//Enable INT0 interrupt on rising edge
			   ldi   acc, (1<<ISC00) | (1<<ISC01)
			   STORE   EICRA,acc
			   ldi   acc, (1<<SE)
			   STORE   SMCR,acc

               // Global interrupt enable 
               sei

loop1:         sleep
			   //Clear genlock timeout
			   //clr acc
			   //STORE TCNT2,acc
			   rjmp   loop1 //  while (1) 
//			   rjmp PC
