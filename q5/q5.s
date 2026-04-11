.section .data
filename:   .asciz "input.txt"
yes_msg:    .asciz "Yes\n"
no_msg:     .asciz "No\n"

.section .bss
left_buf:   .space 1      
right_buf:  .space 1      

.section .text
.global main

main:
    li      a0, -100                
    la      a1, filename
    li      a2, 0                   
    li      a3, 0
    li      a7, 56                 
    ecall
    
    mv      s0, a0                  
    mv      a0, s0
    li      a1, 0
    li      a2, 2                
    li      a7, 62                  
    ecall
    
    mv      s1, a0                 

    li      t0, 2
    blt     s1, t0, print_yes
    
    li      s2, 0
    addi    s3, s1, -1

loop:
    # if left >= right, all chars matched → palindrome
    bge     s2, s3, print_yes
    
    mv      a0, s0
    mv      a1, s2
    li      a2, 0                
    li      a7, 62
    ecall
    
    mv      a0, s0
    la      a1, left_buf
    li      a2, 1
    li      a7, 63
    ecall
    
    mv      a0, s0
    mv      a1, s3
    li      a2, 0               
    li      a7, 62
    ecall
    
    mv      a0, s0
    la      a1, right_buf
    li      a2, 1
    li      a7, 63
    ecall

    la      t0, left_buf
    lb      t1, 0(t0)
    la      t0, right_buf
    lb      t2, 0(t0)

    bne     t1, t2, print_no

    addi    s2, s2, 1
    addi    s3, s3, -1
    j       loop
print_yes:
    
    mv      a0, s0
    li      a7, 57
    ecall
    
    li      a0, 1
    la      a1, yes_msg
    li      a2, 4
    li      a7, 64
    ecall

    li      a0, 0
    li      a7, 93
    ecall
print_no:
    
    mv      a0, s0
    li      a7, 57
    ecall

    li      a0, 1
    la      a1, no_msg
    li      a2, 3
    li      a7, 64
    ecall
    
    li      a0, 0
    li      a7, 93
    ecall
