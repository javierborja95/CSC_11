.global isEven
isEven:
	push {lr}

	cmp r0, #0
	beq true
	sub r0, #1
	bl isOdd
	bal end1
true:
	mov r0, #1
end1:
	pop {pc}
