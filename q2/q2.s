.section .text
.globl main
main:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)  #for arr
    sd s1, 56(sp)   #for nge arr
    sd s2, 48(sp)  #stack
    sd s3, 40(sp)  #n
    sd s4, 32(sp)  #i
    sd s5, 24(sp)  #stack top ptr
    sd s6, 16(sp)  #argv base pointer

    mv s3, a0            
    mv s6, a1            
    addi s3, s3, -1      
    blez s3, exit_program

    slli a0, s3, 3
    call malloc
    mv s0, a0            

    slli a0, s3, 3
    call malloc
    mv s1, a0            

    slli a0, s3, 3
    call malloc
    mv s2, a0            

    li s4, 0             
parse_loop:
    beq s4, s3, algo_start
    addi t0, s4, 1       #i+1
    slli t0, t0, 3       
    add t0, s6, t0       
    ld a0, 0(t0)          #load number(input)
    call atoi    #convert to integer
    slli t1, s4, 3
    add t1, s0, t1       
    sd a0, 0(t1)         #arr[i]=input
    addi s4, s4, 1         #i++
    j parse_loop

algo_start:
    addi s4, s3, -1      
    li s5, -1            #stack top 
outer_loop:
    bltz s4, print_start
while_loop:
    bltz s5, finalize_step
    slli t0, s5, 3
    add t0, s2, t0  #stack address
    ld t1, 0(t0)         #st.top()
    slli t1, t1, 3   
    add t1, s0, t1       
    ld t1, 0(t1)         #arr[st.top()]
    #slli t2, t4, 3 
    slli t2, s4, 3         
    add t2, s0, t2        
    ld t2, 0(t2)         #arr[i]
    bgt t1, t2, finalize_step  #arr[i]<arr[st.top()]
    addi s5, s5, -1      #st.pop()
    j while_loop          #while(arr[i]>arr[st.top()]) st.pop()
finalize_step:
    slli t0, s4, 3
    add t0, s1, t0    #nge[i]    
    li t1, -1         #if st.empty() nge[i]=-1
    bltz s5, store_res
    slli t1, s5, 3       
    add t1, s2, t1
    ld t1, 0(t1)         #st.top()  (res=nge index)
store_res:
    sd t1, 0(t0)  #nge[i]=res
    addi s5, s5, 1  #top++
    slli t0, s5, 3
    add t0, s2, t0 
    sd s4, 0(t0)   #st.push(i)
    addi s4, s4, -1  #i--
    j outer_loop

print_start:
    li s4, 0
print_loop:
    beq s4, s3, exit_program  #i==n exit
    slli t0, s4, 3
    add t0, s1, t0
    ld a1, 0(t0)   #nge[i]
    addi t0, s4, 1
    beq t0, s3, print_last  #if last element, no space
    la a0, fmt_int
    call printf
    addi s4, s4, 1
    j print_loop
print_last:
    la a0, fmt_int_nl
    call printf
    addi s4, s4, 1
    j print_loop

exit_program:
    la a0, fmt_nl
    call printf
    ld ra, 72(sp)
    ld s0, 64(sp)
    ld s1, 56(sp)
    ld s2, 48(sp)
    ld s3, 40(sp)
    ld s4, 32(sp)
    ld s5, 24(sp)
    ld s6, 16(sp)
    addi sp, sp, 80
    li a0, 0
    ret

.section .rodata
fmt_int: .string "%ld "
fmt_nl: .string "\n"
fmt_int_nl: .string "%ld"
