.global isOdd
isOdd:
	push {lr}

	cmp r0, #0
	beq false
	sub r0, #1
	bl isEven
	bal end2
false:
	mov r0, #0
end2:
	pop {pc}
