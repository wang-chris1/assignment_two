# A terminal calculator
#
# Reads a line of input, interprets it as a simple arithmetic expression,
# and prints the result. The input format is
# <long_integer> <operation> <long_integer>

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

main:
  # Function prologue
  enter $0, $0

  # Use scanf to retrieve and process a line of input
  # This block implements the following line of C code: 
  #   scanf("%ld %c %ld", &a, &op, &b);
  # Take a look at the man page for scanf and ask questions. You can also look 
  # at scanf_example.c
  movq $scanf_fmt, %rdi
  movq $a, %rsi
  movq $op, %rdx
  movq $b, %rcx
  xorb %al, %al
  call scanf

  movb op, %r9b 
  movq a, %r8  

  # Figures out which operator we are using, and jumps to a label for each one
  cmpb $'+', %r9b
  je addition

  cmpb $'-', %r9b
  je subtract

  cmpb $'*', %r9b
  je multiply

  cmpb $'/', %r9b
  je divide
  jmp error

# adds both values, puts result in %r8
addition:
  addq b, %r8
  jmp print

# subtracts values, putting result in %r8
subtract:
  subq b, %r8
  jmp print

# multiplies values, putting result in %r8
multiply:
  imulq b, %r8
  jmp print

# divides left value by right value, putting result in %r8 or printing division by zero error
divide:
  cmpq $0, b
  je div_zero_error
  movq %r8, %rax 
  cqo
  idivq b
  movq %rax, %r8
  jmp print

# prints error msg if using invalid operator, returns 1
error:
  movq $error_msg, %rdi
  xorb %al, %al
  call printf
  movq $1, %rax
  jmp epilogue

# prints error msg if dividing by zero, returns 1
div_zero_error:
  movq $div_by_zero, %rdi
  xorb %al, %al
  call printf
  movq $1, %rax
  jmp epilogue

# prints output of calculator, returns 0
print:
  movq $output_fmt, %rdi
  xorb %al, %al
  movq %r8, %rsi
  call printf
  movq $0, %rax
  jmp epilogue

# Function epilogue
epilogue:
  leave
  ret


# Start of the data section
.data

output_fmt: 
  .asciz "%ld\n"
scanf_fmt: 
  .asciz "%ld %c %ld"  # TODO: modify as needed
error_msg:
  .asciz "Unknown operation\n"
div_by_zero:
  .asciz "Cannot divide by zero\n"

# "Slots" for scanf
a:  .quad 0
b:  .quad 0
op: .byte 0

