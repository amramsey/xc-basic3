	PROCESSOR 6502
	
	MAC cmpfloateq
	plfloattofac
	tsx
	inx
	stx DEST
	ldy #$01
	import I_FPLIB
	jsr FCOMP2
	beq .true
	discardfloat
	pfalse
	IF !FPUSH
	beq * + 11
	ELSE
	beq * + 10
	ENDIF
.true
	discardfloat
	ptrue
	ENDM
	
	MAC cmpfloatneq
	plfloattofac
	tsx
	inx
	stx DEST
	ldy #$01
	import I_FPLIB
	jsr FCOMP2
	bne .true
	discardfloat
	pfalse
	IF !FPUSH
	beq * + 11
	ELSE
	beq * + 10
	ENDIF
.true
	discardfloat
	ptrue
	ENDM
	
	; Compare top 2 floats on stack for greater than
	MAC cmpfloatgt
	plfloattofac
	tsx
	inx
	stx DEST
	ldy #$01
	import I_FPLIB
	jsr FCOMP2
	bmi .true
	discardfloat
	pfalse
	IF !FPUSH
	beq * + 11
	ELSE
	beq * + 10
	ENDIF
.true
	discardfloat
	ptrue
	ENDM
	
	; Compare top 2 floats on stack for less than
	MAC cmpfloatlt
	plfloattofac
	tsx
	inx
	stx DEST
	ldy #$01
	import I_FPLIB
	jsr FCOMP2
	cmp #$01
	beq .true
	discardfloat
	pfalse
	IF !FPUSH
	beq * + 11
	ELSE
	beq * + 10
	ENDIF
.true
	discardfloat
	ptrue
	ENDM
	
	; Compare top 2 floats on stack for less than or equal
	MAC cmpfloatlte
	plfloattofac
	tsx
	inx
	stx DEST
	ldy #$01
	import I_FPLIB
	jsr FCOMP2
	bmi .false
	discardfloat
	ptrue
	IF !FPUSH
	bne * + 11
	ELSE
	bne * + 10
	ENDIF
.false
	discardfloat
	pfalse
	ENDM
	
	; Compare top 2 floats on stack for greater than or equal
	MAC cmpfloatgte
	plfloattofac
	tsx
	inx
	stx DEST
	ldy #$01
	import I_FPLIB
	jsr FCOMP2
	cmp #$01
	beq .false
	discardfloat
	ptrue
	IF !FPUSH
	bne * + 11
	ELSE
	bne * + 10
	ENDIF
.false
	discardfloat
	pfalse
	ENDM