.section .text
.globl main
main:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    sd s1, 56(sp)
    sd s2, 48(sp)
    sd s3, 40(sp)
    sd s4, 32(sp)
    sd s5, 24(sp)
    sd s6, 16(sp)

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
    addi t0, s4, 1       
    slli t0, t0, 3       
    add t0, s6, t0       
    ld a0, 0(t0)         
    call atoi
    slli t1, s4, 3
    add t1, s0, t1       
    sd a0, 0(t1)         
    addi s4, s4, 1
    j parse_loop

algo_start:
    addi s4, s3, -1      
    li s5, -1            
outer_loop:
    bltz s4, print_start
while_loop:
    bltz s5, finalize_step
    slli t0, s5, 3
    add t0, s2, t0
    ld t1, 0(t0)         
    slli t1, t1, 3
    add t1, s0, t1
    ld t1, 0(t1)         
    slli t2, t4, 3 # Dummy
    slli t2, s4, 3
    add t2, s0, t2
    ld t2, 0(t2)         
    bgt t1, t2, finalize_step
    addi s5, s5, -1      
    j while_loop
finalize_step:
    slli t0, s4, 3
    add t0, s1, t0       
    li t1, -1
    bltz s5, store_res
    slli t1, s5, 3
    add t1, s2, t1
    ld t1, 0(t1)         
store_res:
    sd t1, 0(t0)
    addi s5, s5, 1
    slli t0, s5, 3
    add t0, s2, t0
    sd s4, 0(t0)
    addi s4, s4, -1
    j outer_loop

print_start:
    li s4, 0
print_loop:
    beq s4, s3, exit_program
    slli t0, s4, 3
    add t0, s1, t0
    ld a1, 0(t0)
    la a0, fmt_int
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
fmt_int: .string "%d "
fmt_nl: .string "\n"
