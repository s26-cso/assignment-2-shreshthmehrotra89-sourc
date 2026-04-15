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
    li      a0, -100        #current directory        
    la      a1, filename
    li      a2, 0          #readonly         
    li      a3, 0
    li      a7, 56               # sys_openat  
    ecall
    
    mv      s0, a0                  #s0 = fd of input.txt file descriptor knows which file to refer

    mv      a0, s0
    li      a1, 0                 # 0 positions from end
    li      a2, 2                #seek end
    li      a7, 62                 # sys_lseek    ppoints to end of file using lseek 
    ecall
    
    mv      s1, a0                 #s1=size of file

    li      t0, 2
    blt     s1, t0, print_yes
    
    li      s2, 0               #start of file
    addi    s3, s1, -1          #end of file

loop:
    # if left >= right, all chars matched → palindrome
    bge     s2, s3, print_yes
    
    mv      a0, s0
    mv      a1, s2   #offset  s2 positions from start
    li      a2, 0                
    li      a7, 62
    ecall             #moves file ptr to pos s2
    
    mv      a0, s0
    la      a1, left_buf
    li      a2, 1          #read one byte
    li      a7, 63        
    ecall             #read 1 byte from start (left buf)
    
    mv      a0, s0
    mv      a1, s3      #offset s3 positions from end
    li      a2, 0               
    li      a7, 62       
    ecall
    
    mv      a0, s0
    la      a1, right_buf
    li      a2, 1
    li      a7, 63
    ecall                #similarly for other end of file

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
    li      a7, 57    #close file
    ecall
    
    li      a0, 1
    la      a1, yes_msg
    li      a2, 4
    li      a7, 64      #write to file
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
