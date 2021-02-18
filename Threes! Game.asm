#jahnavi arora

#################### DO NOT CREATE A .data SECTION ####################

#################### DO NOT CREATE A .data SECTION ####################

#################### DO NOT CREATE A .data SECTION ####################

.text

# Part I

load_game_file:
addi $sp, $sp, -4
sw $s0, 0($sp)
addi $sp, $sp, -4
sw $s1, 0($sp)
addi $sp, $sp, -4
sw $s2, 0($sp)

move $s0, $a0 #board
move $s1, $a1 #filename

#opens the file
 li $v0, 13
 move $a0, $s1
 li $a1, 0
 li $a2, 0
 syscall  
 bltz $v0, pt1end #if v0=-1 the file couldnt open
 move $s1, $v0 #stores fd in s1

#read from file
 addi $sp, $sp, -2 #creates space (is the buffer)
 li $v0, 14
 move $a0, $s1 
 move $a1, $sp 
 li $a2, 1 #read one character = 1 byte
 syscall 
 lb $t0, 0($sp) #t0 = rows  
 addi $t0, $t0, -48 

 li $v0, 14
 move $a1, $sp 
 syscall 
 li $v0, 14
 move $a1, $sp 
 syscall 
 lb $t1, 0($sp) #t1 = columns
 addi $t1, $t1, -48
  
 li $v0, 14
 move $a1, $sp 
 syscall  #gets fd to /n
 
#initalize board to all 0s
 li $t5, 0 #val that'll be stored
 sb $t0, 0($s0)  #CHANGEEE
 sb $t1, 1($s0) #CHANGEEE
 
 li $t2, 0 #i, row counter
 row_loop_board_initalize:
  li $t3, 0 #j, column counter
 col_loop_board_initalize:
  mul $t4, $t2, $t1 #i x columns
  add $t4, $t4, $t3 #i x columns + j
  sll $t4, $t4, 1 #2*(1 x columns + j) accounts for half word
  add $t4, $t4, $s0 #addr + 2*(i x columns + j)
  addi $t4, $t4, 2 #CHANGEEE
  
  sh $t5, 0($t4)
  
  addi $t3, $t3, 1 #j++
  blt $t3, $t1, col_loop_board_initalize
 col_loop_done_initalize:
  addi $t2, $t2, 1 #i++
  blt  $t2, $t0, row_loop_board_initalize

 #loop through board to insert values and get values from txt file
  li $s2, 0 #counter of non zero numbers
  li $t2, 0 #i, row counter
  row_loop_board:
   li $t3, 0 #j, column counter
  col_loop_board:
   mul $t4, $t2, $t1 #i x columns
   add $t4, $t4, $t3 #i x columns + j
   sll $t4, $t4, 1 
   add $t4, $t4, $s0 
   addi $t4, $t4, 2 #CHANGEEE
 
   #got to the place of inserting it
    getting_number:
     li $v0, 14
     move $a0, $s1
     move $a1, $sp
     li $a2, 1
     syscall
     lb $t5, 0($sp) #first char

     beqz $v0, done_inserting #if v0 = 0 file is done
     
     li $v0, 14 
     move $a1, $sp
     syscall
     lb $t6, 0($sp) #second char
     
     li $t8, 48
     bge $t6, $t8, check_third
     addi $t5, $t5, -48 #gets int value of t5
     j insert_in_board
     
     check_third:
      li $v0, 14 
      move $a1, $sp
      syscall
      lb $t7, 0($sp) #third char
      bge $t7, $t8, triple_digit
      addi $t5, $t5, -48
      addi $t6, $t6, -48
      li $t8, 10
      mul $t5, $t5, $t8
      add $t5, $t5, $t6 #t5 has the final int value
      j insert_in_board
      
     triple_digit:
      addi $t5, $t5, -48
      addi $t6, $t6, -48
      addi $t7, $t7, -48
      li $t8, 10
      li $t9, 100
      mul $t5, $t5, $t9
      mul $t6, $t6, $t8
      add $t5, $t5, $t6
      add $t5, $t5, $t7 #t5 has final int value
      
      li $v0, 14 
      move $a1, $sp
      syscall #makes the fd at the space
      j insert_in_board
     
     insert_in_board:
      sh $t5, 0($t4)
      beqz $t5, check_done_reading
      addi $s2, $s2, 1
      check_done_reading:
       beqz $v0, done_inserting
     
    addi $t3, $t3, 1
    blt $t3, $t1, col_loop_board
   col_loop_board_done:
    addi $t2, $t2, 1
    blt $t2, $t0, row_loop_board
   
done_inserting:
 addi $sp, $sp, 2 

 #close file
 li $v0, 16
 move $a0, $s1
 syscall

 move $v0, $s2  

pt1end:
lw $s2, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
addi $sp, $sp, 4
lw $s0, 0($sp)
addi $sp, $sp, 4

jr $ra


# Part II

save_game_file:
addi $sp, $sp, -4
sw $s0, 0($sp)
addi $sp, $sp, -4
sw $s1, 0($sp)
addi $sp, $sp, -4
sw $s3, 0($sp)
addi $sp, $sp, -4
sw $s4, 0($sp)
addi $sp, $sp, -2

move $s0, $a0 #board address
move $s1, $a1 #file name

#opens the file
 li $v0, 13
 move $a0, $s1
 li $a1, 1
 li $a2, 0
 syscall  
 bltz $v0, pt2end #if v0=-1 the file couldnt open
 move $s1, $v0 #stores fd in s1
#row
 lbu $t0, 0($s0)
 move $s3, $t0 #NUMBER OF ROWS
 addi $t0, $t0, 48
 sb $t0, 0($sp)

 li $v0, 15
 move $a0, $s1
 move $a1, $sp
 li $a2, 1
 syscall

#space
 li $t0, 32
 sb $t0, 0($sp)
 li $v0, 15
 move $a0, $s1
 move $a1, $sp
 li $a2, 1
 syscall

#col
 lbu $t0, 1($s0)
 move $s4, $t0 #NUMBER OF COLS
 addi $t0, $t0, 48
 sb $t0, 0($sp)

 
 li $v0, 15
 move $a0, $s1
 move $a1, $sp
 li $a2, 1
 syscall

#newline
 li $t0, 10
 sb $t0, 0($sp)
 li $v0, 15
 move $a0, $s1
 move $a1, $sp
 li $a2, 1
 syscall 

li $t8, 0 #i
row_printing_loopp:
	li $t1, 0 #j
col_printing_loopp:
	mul $t2, $t8, $s4
	add $t2, $t2, $t1
	sll $t2, $t2, 1
	add $t2, $t2, $s0
	addi $t2, $t2, 2
	
	lhu $t0, 0($t2)
	li $t6, 10
	blt $t0, $t6, onedigit
	
	div $t0, $t6
	mfhi $t3 #remainder
	mflo $t4 #quotient
	
	blt $t4, $t6, doubledigit
	div $t4, $t6
	
	mfhi $t4
	mflo $t5
	
	addi $t5, $t5, 48
        sb $t5, 0($sp)
        li $v0, 15
        move $a0, $s1
        move $a1, $sp
        li $a2, 1
        syscall
        
        addi $t4, $t4, 48
        sb $t4, 0($sp)
        li $v0, 15
        move $a0, $s1
        move $a1, $sp
        li $a2, 1
        syscall

        addi $t3, $t3, 48
        sb $t3, 0($sp)
        li $v0, 15
        move $a0, $s1
        move $a1, $sp
        li $a2, 1
        syscall
        
        li $t0, 32 #space
        sb $t0, 0($sp)
        li $v0, 15
        move $a0, $s1
        move $a1, $sp
        li $a2, 1
        syscall
        j ending_portion        
       doubledigit:
        addi $t4, $t4, 48
        sb $t4, 0($sp)
        li $v0, 15
        move $a0, $s1
        move $a1, $sp
        li $a2, 1
        syscall
        
        addi $t3, $t3, 48
        sb $t3, 0($sp)
        li $v0, 15
        move $a0, $s1
        move $a1, $sp
        li $a2, 1
        syscall
        
        li $t0, 32 #space
        sb $t0, 0($sp)
        li $v0, 15
        move $a0, $s1
        move $a1, $sp
        li $a2, 1
        syscall
        j ending_portion
       onedigit:
	addi $t0, $t0, 48
	sb $t0, 0($sp)
 
        li $v0, 15
        move $a0, $s1
        move $a1, $sp
        li $a2, 1
        syscall
        
        li $t0, 32 #space
        sb $t0, 0($sp)
        li $v0, 15
        move $a0, $s1
        move $a1, $sp
        li $a2, 1
        syscall
        
       ending_portion: 
	addi $t1, $t1, 1
	blt $t1, $s4, col_printing_loopp
col_loop_donepp:
	addi $t8, $t8, 1 #i_++
	
	li $t0, 10
        sb $t0, 0($sp)
        li $v0, 15
        move $a0, $s1
        move $a1, $sp
        li $a2, 1
        syscall 
        
	blt $t8, $s3, row_printing_loopp

pt2end:
addi $sp, $sp, 2
lw $s4, 0($sp)
addi $sp, $sp, 4
lw $s3, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
addi $sp, $sp, 4
lw $s0, 0($sp)
addi $sp, $sp, 4
jr $ra


# Part III

get_tile:
#storing s registers
addi $sp, $sp, -4
sw $s0, 0($sp)
addi $sp, $sp, -4
sw $s1, 0($sp)
addi $sp, $sp, -4
sw $s2, 0($sp)

move $s0, $a0 #board adress
move $s1, $a1 #ROW
move $s2, $a2 #COL

bltz $s1, invalid_input
bltz $s2, invalid_input

lb $t0, 0($s0) #num of rows
addi $s0, $s0, 1
lb $t1, 0($s0) #num of cols
addi $s0, $s0, 1

bge $s1, $t0, invalid_input
bge $s2, $t1, invalid_input

find_value:

 mul $t2, $s1, $t1
 add $t2, $t2, $s2
 sll $t2, $t2, 1
 add $t2, $t2, $s0
 lhu $v0, 0($t2)
 j pt3end

invalid_input:
 li $v0, -1

pt3end:
lw $s2, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
addi $sp, $sp, 4
lw $s0, 0($sp)
addi $sp, $sp, 4
jr $ra

# Part IV

set_tile:
#storing s registers
addi $sp, $sp, -4
sw $s0, 0($sp)
addi $sp, $sp, -4
sw $s1, 0($sp)
addi $sp, $sp, -4
sw $s2, 0($sp)
addi $sp, $sp, -4
sw $s3, 0($sp)

move $s0, $a0 #board adress
move $s1, $a1 #ROW
move $s2, $a2 #COL
move $s3, $a3 #VALUE

bltz $s1, invalid_input_pt4
bltz $s2, invalid_input_pt4
bltz $s3, invalid_input_pt4
li $t4, 49152
bgt $s3, $t4, invalid_input_pt4

lb $t0, 0($s0) #num of rows
addi $s0, $s0, 1
lb $t1, 0($s0) #num of cols
addi $s0, $s0, 1

bge $s1, $t0, invalid_input_pt4
bge $s2, $t1, invalid_input_pt4

store_value:
 mul $t2, $s1, $t1
 add $t2, $t2, $s2
 sll $t2, $t2, 1
 add $t2, $t2, $s0
 sh $s3, 0($t2)
 move $v0, $s3
 j pt4end
 
invalid_input_pt4:
 li $v0, -1

pt4end:
lw $s3, 0($sp)
addi $sp, $sp, 4
lw $s2, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
addi $sp, $sp, 4
lw $s0, 0($sp)
addi $sp, $sp, 4

jr $ra

# Part V

can_be_merged:
lw $t0, 0($sp)

addi $sp, $sp, -4
sw $s0, 0($sp)
addi $sp, $sp, -4
sw $s1, 0($sp)
addi $sp, $sp, -4
sw $s2, 0($sp)
addi $sp, $sp, -4
sw $s3, 0($sp)
addi $sp, $sp, -4
sw $s4, 0($sp)
addi $sp, $sp, -4
sw $s5, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)

move $s0, $a0 #board adress
move $s1, $a1 #row1
move $s2, $a2 #col2
move $s3, $a3 #row2
move $s4, $t0 #col2 

bltz $s1, invalid_input_pt5
bltz $s2, invalid_input_pt5
bltz $s3, invalid_input_pt5
bltz $s4, invalid_input_pt5

lb $t0, 0($s0) #num of rows
addi $s0, $s0, 1
lb $t1, 0($s0) #num of cols
addi $s0, $s0, 1
bge $s1, $t0, invalid_input_pt5
bge $s2, $t1, invalid_input_pt5
bge $s3, $t0, invalid_input_pt5
bge $s4, $t1, invalid_input_pt5

li $t0, 0
li $t1, 0
beq $s1, $s3, equal_rows
beq $s2, $s4, equal_cols
j check_adjacency
equal_rows:
 addi $t0, $t0, 1
 bne $s2, $s4, check_adjacency
equal_cols:
 addi $t1, $t1, 1
check_adjacency:
 add $t0, $t0, $t1
 li $t1, 1
 bne $t1, $t0, invalid_input_pt5

move $a1, $s3
move $a2, $s4
jal get_tile
move $s5, $v0 #val at r1xc1

move $a1, $s1
move $a2, $s2
jal get_tile
move $t1, $v0 #val at r2xc2

li $t2, 3
bge $s5, $t2, check_if_same
add $s5, $s5, $t1
bne $s5, $t2, invalid_input_pt5
j can_merge

check_if_same:
 bne $s5, $t1, invalid_input_pt5
 add $s5, $s5, $t1
 j can_merge

can_merge:
 move $v0, $s5
 j pt5end

invalid_input_pt5:
li $v0, -1

pt5end:
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s5, 0($sp)
addi $sp, $sp, 4
lw $s4, 0($sp)
addi $sp, $sp, 4
lw $s3, 0($sp)
addi $sp, $sp, 4
lw $s2, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
addi $sp, $sp, 4
lw $s0, 0($sp)
addi $sp, $sp, 4
jr $ra

# Part VI

slide_row:
addi $sp, $sp, -4
sw $s0, 0($sp)
addi $sp, $sp, -4
sw $s1, 0($sp)
addi $sp, $sp, -4
sw $s2, 0($sp)
addi $sp, $sp, -4
sw $s3, 0($sp)
addi $sp, $sp, -4
sw $s4, 0($sp)
addi $sp, $sp, -4
sw $s5, 0($sp)
addi $sp, $sp, -4
sw $s6, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)

addi $sp $sp, -4

move $s0, $a0 #board address
move $s1, $a1 #ROW
move $s2, $a2 #Direcrion

li $t0, -1
beq $s2, $t0, check_rows
li $t0, 1
bne $s2, $t0, invalid_input_pt6
check_rows:
 lb $t0, 0($s0) #num of rows
 addi $s0, $s0, 1 
 lb $t1, 0($s0) #num of columns
 addi $s0, $s0, 1
 move $s3, $t0 #num of rows
 move $s4, $t1 #num of columns
 bltz $s1, invalid_input_pt6
 bge $s1, $t0, invalid_input_pt6
 li $t3, 1
 beq $t0, $t3, no_change
 bltz $s2, shift_left
 
shift_right:
 li $t9, 0
 addi $s5, $s4, -1
 pt6_loop_right:
  move $a2, $s5
  jal get_tile
  beqz $v0, zero_found_right
  addi $s6, $s5, -1
  sw $s6, 0($sp)
  move $a3, $s1
  jal can_be_merged
  bgtz $v0, merge_here_right
  addi $s5, $s5, -1
  bgtz $s5, pt6_loop_right
  j no_change
  
  zero_found_right:
   addi $s6, $s5, -1
   move $a2, $s6
   jal get_tile
   move $a2, $s5
   move $a3, $v0
   jal set_tile
   addi $s5, $s5, -1
   bgtz $s5, zero_found_right
   move $a2, $s5
   li $a3, 0
   jal set_tile
   move $v0, $t9
   j pt6end
  
  merge_here_right:
   move $a2, $s5
   move $a3, $v0
   jal set_tile
   addi $s5, $s5, -1
   li $t9, 1
   j zero_found_right

shift_left:
 li $t9, 0
 li $s5, 0
 addi $s4, $s4, -1
 pt6_loop_left:
  move $a2, $s5
  jal get_tile
  beqz $v0, zero_found_left
  addi $s6, $s5, 1
  sw $s6, 0($sp)
  move $a3, $s1
  jal can_be_merged
  bgtz $v0, merge_here_left
  addi $s5, $s5, 1
  blt $s5, $s4, pt6_loop_left
  j no_change
  
  zero_found_left:
   addi $s6, $s5, 1
   move $a2, $s6
   jal get_tile
   move $a2, $s5
   move $a3, $v0
   jal set_tile 
   addi $s5, $s5, 1
   blt $s5, $s4, zero_found_left
   move $a2, $s5
   li $a3, 0
   jal set_tile
   move $v0, $t9
   j pt6end
   
  merge_here_left:
   move $a2, $s5
   move $a3, $v0
   jal set_tile
   addi $s5, $s5, 1
   li $t9, 1
   j zero_found_left

no_change:
 li $v0, 0
 j pt6end

invalid_input_pt6:
 li $v0, -1

pt6end:

addi $sp, $sp, 4

lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s6, 0($sp)
addi $sp, $sp, 4
lw $s5, 0($sp)
addi $sp, $sp, 4
lw $s4, 0($sp)
addi $sp, $sp, 4
lw $s3, 0($sp)
addi $sp, $sp, 4
lw $s2, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
addi $sp, $sp, 4
lw $s0, 0($sp)
addi $sp, $sp, 4
jr $ra


# Part VII

slide_col:
addi $sp, $sp, -4
sw $s0, 0($sp)
addi $sp, $sp, -4
sw $s1, 0($sp)
addi $sp, $sp, -4
sw $s2, 0($sp)
addi $sp, $sp, -4
sw $s3, 0($sp)
addi $sp, $sp, -4
sw $s4, 0($sp)
addi $sp, $sp, -4
sw $s5, 0($sp)
addi $sp, $sp, -4
sw $s6, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)

addi $sp $sp, -4

move $s0, $a0 #board address
move $s1, $a1 #COL
move $s2, $a2 #Direcrion

li $t0, -1
beq $s2, $t0, check_cols
li $t0, 1
bne $s2, $t0, invalid_input_pt7
check_cols:
 lb $t0, 0($s0) #num of rows
 addi $s0, $s0, 1 
 lb $t1, 0($s0) #num of columns
 addi $s0, $s0, 1
 move $s3, $t0 #num of rows
 move $s4, $t1 #num of columns
 bltz $s1, invalid_input_pt7
 bge $s1, $t1, invalid_input_pt7
 li $t3, 1
 beq $t0, $t3, no_change_pt7
 bltz $s2, shift_up
 
shift_down:
 li $t9, 0
 move $a2, $s1
 addi $s5, $s3, -1
 pt7_loop_down:
  move $a1, $s5
  jal get_tile
  beqz $v0, zero_found_down
  addi $s6, $s5, -1
  sw $s1, 0($sp)
  move $a3, $s6
  jal can_be_merged
  bgtz $v0, merge_here_down
  addi $s5, $s5, -1
  bgtz $s5, pt7_loop_down
  j no_change
  
  zero_found_down:
   addi $s6, $s5, -1
   move $a1, $s6
   jal get_tile 
   move $a1, $s5
   move $a3, $v0
   jal set_tile
   addi $s5, $s5, -1
   bgtz $s5, zero_found_down
   move $a1, $s5
   li $a3, 0
   jal set_tile
   move $v0, $t9
   j pt7end
  
  merge_here_down:
   move $a1, $s5
   move $a3, $v0
   jal set_tile
   addi $s5, $s5, -1
   li $t9, 1
   j zero_found_down

shift_up:
 li $t9, 0
 move $a2, $s1
 li $s5, 0
 addi $s3, $s3, -1
 pt7_loop_up:
  move $a1, $s5
  jal get_tile
  beqz $v0, zero_found_up
  addi $s6, $s5, 1
  move $a3, $s6
  sw $s1, 0($sp)
  jal can_be_merged
  bgtz $v0, merge_here_up
  addi $s5, $s5, 1
  blt $s5, $s3, pt7_loop_up
  j no_change
  
  zero_found_up:
   addi $s6, $s5, 1
   move $a1, $s6
   jal get_tile
   move $a1, $s5
   move $a3, $v0
   jal set_tile
   addi $s5, $s5, 1
   blt $s5, $s3, zero_found_up
   move $a1, $s5
   li $a3, 0
   jal set_tile
   move $v0, $t9
   j pt7end
  
  merge_here_up:
   move $a1, $s5
   move $a3, $v0
   jal set_tile
   addi $s5, $s5, 1
   li $t9, 1
   j zero_found_up
 
no_change_pt7:
 li $v0, 0
 j pt7end

invalid_input_pt7:
 li $v0, -1
 
pt7end:
addi $sp, $sp, 4

lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s6, 0($sp)
addi $sp, $sp, 4
lw $s5, 0($sp)
addi $sp, $sp, 4
lw $s4, 0($sp)
addi $sp, $sp, 4
lw $s3, 0($sp)
addi $sp, $sp, 4
lw $s2, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
addi $sp, $sp, 4
lw $s0, 0($sp)
addi $sp, $sp, 4

jr $ra

# Part VIII

slide_board_left:
addi $sp, $sp, -4
sw $s0, 0($sp)
addi $sp, $sp, -4
sw $s1, 0($sp)
addi $sp, $sp, -4
sw $s2, 0($sp)
addi $sp, $sp, -4
sw $s3, 0($sp)
addi $sp, $sp, -4
sw $s4, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)

move $s0, $a0

lb $t0, 0($s0) #num of rows
addi $s0, $s0, 1 
lb $t1, 0($s0) #num of columns
addi $s0, $s0, 1
move $s1, $t0 #num of rows
move $s2, $t1 #num of columns
li $s3, 0 #v0 counter
li $s4, 0 #row counter
sliding_left:
 li $a2, -1
 move $a1, $s4
 jal slide_row
 addi $s4, $s4, 1
 add $s3, $s3, $v0
 blt $s4, $s1, sliding_left

pt8end:
move $v0, $s3

lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s4, 0($sp)
addi $sp, $sp, 4
lw $s3, 0($sp)
addi $sp, $sp, 4
lw $s2, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
addi $sp, $sp, 4
lw $s0, 0($sp)
addi $sp, $sp, 4

jr $ra

# Part IX

slide_board_right:
addi $sp, $sp, -4
sw $s0, 0($sp)
addi $sp, $sp, -4
sw $s1, 0($sp)
addi $sp, $sp, -4
sw $s2, 0($sp)
addi $sp, $sp, -4
sw $s3, 0($sp)
addi $sp, $sp, -4
sw $s4, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)

move $s0, $a0

lb $t0, 0($s0) #num of rows
addi $s0, $s0, 1 
lb $t1, 0($s0) #num of columns
addi $s0, $s0, 1
move $s1, $t0 #num of rows
move $s2, $t1 #num of columns
li $s3, 0 #v0 counter
li $s4, 0 #row counter
sliding_right:
 li $a2, 1
 move $a1, $s4
 jal slide_row
 addi $s4, $s4, 1
 add $s3, $s3, $v0
 blt $s4, $s1, sliding_right

pt9end:
move $v0, $s3

lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s4, 0($sp)
addi $sp, $sp, 4
lw $s3, 0($sp)
addi $sp, $sp, 4
lw $s2, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
addi $sp, $sp, 4
lw $s0, 0($sp)
addi $sp, $sp, 4

jr $ra

# Part X

slide_board_up:
addi $sp, $sp, -4
sw $s0, 0($sp)
addi $sp, $sp, -4
sw $s1, 0($sp)
addi $sp, $sp, -4
sw $s2, 0($sp)
addi $sp, $sp, -4
sw $s3, 0($sp)
addi $sp, $sp, -4
sw $s4, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)

move $s0, $a0

lb $t0, 0($s0) #num of rows
addi $s0, $s0, 1 
lb $t1, 0($s0) #num of columns
addi $s0, $s0, 1
move $s1, $t0 #num of rows
move $s2, $t1 #num of columns
li $s3, 0 #v0 counter
li $s4, 0 #col counter
sliding_up:
 li $a2, -1
 move $a1, $s4
 jal slide_col
 addi $s4, $s4, 1
 add $s3, $s3, $v0
 blt $s4, $s2, sliding_up

pt10end:
move $v0, $s3

lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s4, 0($sp)
addi $sp, $sp, 4
lw $s3, 0($sp)
addi $sp, $sp, 4
lw $s2, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
addi $sp, $sp, 4
lw $s0, 0($sp)
addi $sp, $sp, 4

jr $ra

# Part XI

slide_board_down:

addi $sp, $sp, -4
sw $s0, 0($sp)
addi $sp, $sp, -4
sw $s1, 0($sp)
addi $sp, $sp, -4
sw $s2, 0($sp)
addi $sp, $sp, -4
sw $s3, 0($sp)
addi $sp, $sp, -4
sw $s4, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)

move $s0, $a0

lb $t0, 0($s0) #num of rows
addi $s0, $s0, 1 
lb $t1, 0($s0) #num of columns
addi $s0, $s0, 1
move $s1, $t0 #num of rows
move $s2, $t1 #num of columns
li $s3, 0 #v0 counter
li $s4, 0 #col counter
sliding_down:
 li $a2, 1
 move $a1, $s4
 jal slide_col
 addi $s4, $s4, 1
 add $s3, $s3, $v0
 blt $s4, $s2, sliding_down

pt11end:
move $v0, $s3

lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s4, 0($sp)
addi $sp, $sp, 4
lw $s3, 0($sp)
addi $sp, $sp, 4
lw $s2, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
addi $sp, $sp, 4
lw $s0, 0($sp)
addi $sp, $sp, 4

jr $ra

# Part XII

game_status:
addi $sp, $sp, -4
sw $s0, 0($sp)
addi $sp, $sp, -4
sw $s1, 0($sp)
addi $sp, $sp, -4
sw $s2, 0($sp)
addi $sp, $sp, -4
sw $s3, 0($sp)
addi $sp, $sp, -4
sw $s4, 0($sp)
addi $sp, $sp, -4
sw $s5, 0($sp)
addi $sp, $sp, -4
sw $s7, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)

addi $sp, $sp, -4

move $s0, $a0
lb $t0, 0($s0) #rows
addi $s0, $s0, 1
lb $t1, 0($s0) #cols
addi $s0, $s0, 1
move $s1, $t0 #rows
move $s2, $t1 #cols

check_win:
 li $s3, 0 #i
 row_loop_win:
  li $s4, 0 #j
 col_loop_win:
  move $a1, $s3
  move $a2, $s4 
  jal get_tile
  li $t0, 49152
  beq $t0, $v0, winner
  addi $s4, $s4, 1
  blt $s4, $s2, col_loop_win
 col_loop_win_done:
  addi $s3, $s3, 1
  blt $s3, $s1, row_loop_win

can_continue:
 li $s3, 0 #row_movement_counter
 li $s4, 0 #row counter
 row_slides:
  addi $s5, $s2, -1 #column
  row_slides_loop:
   
   move $a1, $s4
   move $a2, $s5
   jal get_tile
   beqz $v0, row_is_moveable
   beqz $s5, done_with_row
   addi $s6, $s5, -1
   move $a3, $s4
   sw $s6, 0($sp)
   jal can_be_merged
   bgtz $v0, row_is_moveable
   addi $s5, $s5, -1
   bgez $s5, row_slides_loop
   row_is_moveable:
    addi $s3, $s3, 1
   done_with_row:
    addi $s4, $s4, 1
    blt $s4, $s1, row_slides
  
 li $s7, 0 #col_movement_counter
 li $s4, 0 #col counter
 col_slides:
  addi $s5, $s1, -1 #row
  col_slides_loop:
   move $a1, $s5
   move $a2, $s4
   jal get_tile
   beqz $v0, col_is_moveable
   beqz $s5, done_with_column
   addi $s6, $s5, -1
   move $a3, $s6
   sw $s4, 0($sp)
   jal can_be_merged
   bgtz $v0, col_is_moveable
   addi $s5, $s5, -1
   bgez $s5, col_slides_loop
   col_is_moveable:
    addi $s7, $s7, 1
   done_with_column:
    addi $s4, $s4, 1
    blt $s4, $s2, col_slides
  move $v1, $s7
  move $v0, $s3
 j pt12end
 
lost:
 li $v0, -1
 li $v1, -1
 j pt12end
 
winner:
li $v0, -2
li $v1, -2

pt12end:
beqz $v0, check_v1
 check_v1:
  beqz $v1, lost
addi $sp, $sp, 4

lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s7, 0($sp)
addi $sp, $sp, 4
lw $s5, 0($sp)
addi $sp, $sp, 4
lw $s4, 0($sp)
addi $sp, $sp, 4
lw $s3, 0($sp)
addi $sp, $sp, 4
lw $s2, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
addi $sp, $sp, 4
lw $s0, 0($sp)
addi $sp, $sp, 4
jr $ra



#################### DO NOT CREATE A .data SECTION ####################

#################### DO NOT CREATE A .data SECTION ####################

#################### DO NOT CREATE A .data SECTION ####################
