.section .text
.globl main
main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    sd s1, 40(sp)
    sd s2, 32(sp)
    sd s3, 24(sp)
    sd s4, 16(sp)
    sd s5, 8(sp)

    mv s0, a0
    mv s1, a1
    addi s3, s0, -1
    blez s3, exit

    slli t0, s3, 3
    mv a0, t0
    call malloc
    mv s0, a0

    slli t0, s3, 3
    mv a0, t0
    call malloc
    mv s2, a0

    slli t0, s3, 3
    mv a0, t0
    call malloc
    mv s1, a0

    li s4, 0
parse_loop:
    beq s4, s3, start_algo
    addi t0, s4, 1
    slli t0, t0, 3
    add t0, s1, t0
    ld a0, 0(t0)
    call atoi
    slli t1, s4, 3
    add t1, s0, t1
    sd a0, 0(t1)
    addi s4, s4, 1
    j parse_loop

start_algo:
    addi s4, s3, -1
    li s5, -1
outer_loop:
    bltz s4, print_results
while_loop:
    bltz s5, set_result
    slli t0, s5, 3
    add t0, s2, t0
    ld t1, 0(t0)
    slli t2, t1, 3
    add t2, s0, t2
    ld t2, 0(t2)
    slli t3, s4, 3
    add t3, s0, t3
    ld t3, 0(t3)
    bgt t2, t3, set_result
    addi s5, s5, -1
    j while_loop
set_result:
    slli t0, s4, 3
    add t0, s1, t0
    li t1, -1
    sd t1, 0(t0)
    bltz s5, push_idx
    slli t2, s5, 3
    add t2, s2, t2
    ld t2, 0(t2)
    sd t2, 0(t0)
push_idx:
    addi s5, s5, 1
    slli t0, s5, 3
    add t0, s2, t0
    sd s4, 0(t0)
    addi s4, s4, -1
    j outer_loop

print_results:
    li s4, 0
print_loop:
    beq s4, s3, exit
    slli t0, s4, 3
    add t0, s1, t0
    ld a1, 0(t0)
    la a0, fmt_int
    call printf
    addi s4, s4, 1
    j print_loop

exit:
    la a0, fmt_newline
    call printf
    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    ld s4, 16(sp)
    ld s5, 8(sp)
    addi sp, sp, 64
    li a0, 0
    ret

.section .rodata
fmt_int: .string "%d "
fmt_newline: .string "\n"
