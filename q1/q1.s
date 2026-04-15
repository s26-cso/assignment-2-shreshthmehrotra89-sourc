.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    mv s0, a0    #save value 
    li a0, 24   #assign 24 byte size to new node a0
    call malloc
    sw s0, 0(a0)   
    sd zero, 8(a0)  #left ptr=NULL
    sd zero, 16(a0)
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret

insert:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)    #save current node
    sd s1, 8(sp)     #save value
    mv s0, a0
    mv s1, a1
    bne a0, zero, .L_compare   #NULL CHECK
    mv a0, a1
    call make_node   #if NULL MAKE NODE
    j .L_insert_exit
.L_compare:
    lw t0, 0(s0)   
    beq s1, t0, .L_insert_done  #if val already exists exit
    blt s1, t0, .L_insert_left # if val less go left
    ld a0, 16(s0)   #go right
    mv a1, s1       
    call insert    #again call insert
    sd a0, 16(s0)   #assign new node to its right
    j .L_insert_done  #end of insertion
.L_insert_left:
    ld a0, 8(s0)   #lefgt ptr
    mv a1, s1
    call insert
    sd a0, 8(s0)  #assign new node to its left ptr
.L_insert_done:
    mv a0, s0       #return current node
.L_insert_exit:
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    addi sp, sp, 32
    ret

get:
    beq a0, zero, .L_get_null  #null check
    lw t0, 0(a0) #root->val
    beq a1, t0, .L_get_exit
    blt a1, t0, .L_get_left #left
    ld a0, 16(a0)  #right
    j get
.L_get_left:
    ld a0, 8(a0)
    j get   #again call get func
.L_get_null:
    li a0, 0
.L_get_exit:
    ret

getAtMost:
    li t0, -1
.L_gam_loop:
    beq a1, zero, .L_gam_exit
    lw t1, 0(a1)
    beq a0, t1, .L_gam_exact
    blt a0, t1, .L_gam_left
    mv t0, t1
    ld a1, 16(a1)
    j .L_gam_loop
.L_gam_left:
    ld a1, 8(a1)
    j .L_gam_loop
.L_gam_exact:
    mv t0, t1
.L_gam_exit:
    mv a0, t0
    ret
