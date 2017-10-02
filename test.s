.text
.global main
.data
welcome: .asciz"Hello! Welcome to Two Integers.\n\n"
instruct1: .asciz"Enter an integer for first number: "
instruct2: .asciz"Enter an integer for second number: "
num1: .word 0
num2: .word 0
sum: .word 0
diff: .word 0
prod: .word 0
main: 
push {lr}
ldr r0, = welcome
ldr r1, = instruct1
bl printf
pop {pc}