#     Minesweeper
#
#  Your Name:	Sriharsha Singam
#  Date: October 7, 2018

.data

# your data allocation/initialization goes here

### arr -- 10 by 10 mine holder --
arr: .word -33686019,-33686019, -16908803, -16843010, -33620226, -16843011, -16843010, -16908802, -16843010, -33620226, -16843011, -16843010, -16908802, -16843010, -33620226, -16843011, -16843010, -16908802, -16843010, -33620226, -16843011, -16843010, -33686018, -33686019, -33686019
#           -3-3-3-3,-3-3-3-3,   -3-3-3-2, -2-2-2-2 , -2-2-2-3 , -3-2-2-2 , -2-2-2-2 , -2-3-3-2 , -2-2-2-2 , -2-2-2-3 , -3-2-2-2 , -2-2-2-2 , -2-3-3-2 , -2-2-2-2 , -2-2-2-3 , -3-2-2-2 , -2-2-2-2 , -2-3-3-2 , -2-2-2-2 , -2-2-2-3 , -3-2-2-2 , -2-2-2-2 , -2-3-3-3 , -3-3-3-3 , -3-3-3-3

### -2 is an unopened 8 by 8 square
### -3 is not touchable outer square

#   -3, -3, -3, -3, -3, -3, -3, -3, -3, -3
#   -3, -2, -2, -2, -2, -2, -2, -2, -2, -3
#   -3, -2, -2, -2, -2, -2, -2, -2, -2, -3
#   -3, -2, -2, -2, -2, -2, -2, -2, -2, -3
#   -3, -2, -2, -2, -2, -2, -2, -2, -2, -3
#   -3, -2, -2, -2, -2, -2, -2, -2, -2, -3
#   -3, -2, -2, -2, -2, -2, -2, -2, -2, -3
#   -3, -2, -2, -2, -2, -2, -2, -2, -2, -3
#   -3, -2, -2, -2, -2, -2, -2, -2, -2, -3
#   -3, -3, -3, -3, -3, -3, -3, -3, -3, -3


### check -- hold values: {1,11,10,9,-1,-11,-10,-9} -- meant to be added to get surrounding 8 squares of the current index
check: .word 151653121, -134810113


.text
MineSweep: swi   567	   	   # Bury mines (returns # buried in $1)


### Using a 10 by 10 array to solve minesweeper. The four edges of the ten by ten array
### have an initial value of -3 and the inner 8 by 8 array has an initial value of -2.
### The program checks if the value is -3 and skips over the index, and there by only
### going over the indices of the inner 8 by 8 square.


### $2 is the index value for Guessing, Openning, and Flagging
### $7 is used for Accepting Current $2 value to be changed
### $8 is the Number of Open or Flagged Squares
### $9 is the Number to be checked for Open or Flagged Squares

Initial:    add $28, $0, $31           # For Exit to OS (DONT CHANGE)
            addi $5, $0, -2            # Unopened Square Value (DONT CHANGE)
            addi $10, $0, 10           # Value for edge cases (DONT CHANGE)
            addi $26, $0, 9            # Value for edge cases (DONT CHANGE)
            addi $12, $0, 89           # Value for edge cases (DONT CHANGE)
            addi $13, $0, 8            # Value for edge cases (DONT CHANGE) -- mod
            addi $16, $0, -3           # Holds value: -3 for untouchable squares (DONT CHANGE)
            addi $23, $0, 0            # Flagged/Mine Counter (DONT CHANGE)
            addi $21, $0, -1           # To Check for mines (DONT CHANGE)
            j Main1                    # Originally start with guessing

############ START SOLVER: ################
Main:       addi $2, $0, 10            # Start checking each square of the 8 by 8 inner square -- skipping over the unnecessary top side

MainLoop:   addi $2, $2, 1             # $2 will act a counter as well as
            beq $2, $12, Main1         # End Main Loop at index 89
            lb $6, arr($2)             # Load value at index
            bne $6, $16, Next          # Check if the value is NOT -3 (Out of Bounds index)
            j MainLoop                 # ELSE restart Main Loop
Next:       bne $6, $10, Next1         # Check if the value is NOT 10 (Already Checked on all Sides)
            j MainLoop                 # ELSE restart Main Loop
Next1:      bne $6, $5, Next2          # Check if the value is NOT -2 (unopened)
            j MainLoop                 # ELSE restart Main Loop
Next2:      bne $6, $26, CheckSides    # Check if the value is NOT 9 (Flagged)
            j MainLoop                 # ELSE restart Main Loop


Main1:      addi $2, $0, 11            # Start checking each square of the 8 by 8 inner square -- skipping over the unnecessary top side
Main1Loop:  beq $2, $12, End           # End Main1Loop at index 89
            lb $6, arr($2)             # Load value at index
            beq $6, $5, GuessNext      # Check if the value is NOT -2 (unopened)
            addi $2, $2, 1             # $2 will act a counter as well as
            j Main1Loop                # Restart Main1Loop

End:    jr $28                         # Ending Program For Good When All Mines are Flagged

############ END SOLVER: ################

########## START GUESS: ###############

GuessNext:  addi  $3, $0, -1           # Initializing $3 to -1 for Guessing
            jal GetEightByEight        # Convert the 10 by 10 coordinates index to an 8 by 8 coordinate
            swi   568                  # Guess
            add $2, $2,$11             # Convert the $2 to an 8 by 8 coordinate instead of 10 by 10 coordinate
            sb $4, arr($2)             # Store Guess value in Array: arr at the current index
            beq $4, $21, FlagMine      # Checks if the Guess value is a mine then calls FlagMine
            j Main                     # ELSE go back to Main to Check all Squares all over again

FlagMine:   sb $26, arr($2)            # Store 9 in the index of Array if Guess is a Mine
            addi $23, $23, 1           # Counting all number of Flags or Mines
            beq $23, $1, End           # If flags or Mines equal to the Final number of Mines then it ENDS THE PROGRAM
            j Main                     # Going back to Main to Check all Squares all over again

########## END GUESS: ###############


########## START OPEN: ###############
Open:       add $18, $0, $31           # Adds the JAL value from $31 to register $18
            addi $2, $14, 0            # Make $2 equal to the Index that is being checked in CHECKSIDES LABEL
            addi  $3, $0, 0            # Initializing $3 to 0 for Openning
            jal GetEightByEight        # Convert the 10 by 10 coordinates index to an 8 by 8 coordinate
            swi   568                  # Open
            add $2, $2, $11            # Convert the $2 to an 8 by 8 coordinate instead of 10 by 10 coordinate
            sb $4, arr($2)             # Store Open value in Array: arr at the current index
            jr $18                     # Return to CHECKSIDES LABEL
########## END OPEN: ###############


########## START FLAG: ###############
Flag:       add $18, $0, $31           # Adds the JAL value from $31 to register $18
            addi  $3, $0, 1            # Initializing $3 to 1 for Flagging
            addi $2, $14, 0            # Make $2 equal to the Index that is being checked in CHECKSIDES LABEL
            jal GetEightByEight        # Convert the 10 by 10 coordinates index to an 8 by 8 coordinate
            swi   568                  # Flag
            add $2, $2, $11            # Convert the $2 to an 8 by 8 coordinate instead of 10 by 10 coordinate
            sb $26, arr($2)            # Store Flag value of 9 in Array: arr at the current index
            addi $23, $23, 1           # Counting all number of Flags or Mines
            beq $23, $1, End           # If flags or Mines equal to the Final number of Mines then it ENDS THE PROGRAM
            jr $18                     # Return to CHECKSIDES LABEL
########## END FLAG: ###############

GetEightByEight:  div $2, $10          # Getting mod(index,10)
                  mfhi $11             # Get mod value to $11
                  sub $11, $2, $11     # Getting Row Value of index in an 8 by 8 square
                  div $11, $10         # Divide Row value by 10
                  mflo $11             # Get the divided value
                  add $11, $11, $11    # Add the divided value by itself
                  addi $11, $11, 9     # Adding 9 to $11
                  sub $2, $2, $11      # Subtracting the Change Value ($11) from $2 -- the index
                  jr $31               # Returning to Flag, Guess, or Open

########### START CHECK SIDES: #################

CheckSides: addi $9, $0, -2            # Initialize $9 to -2 (-2 is the value to check if an index is unopened)
            addi $22, $0, 0            # Initialize $22 to tell CHECK LABEL to check surrounding values for unopened or flagged
            addi $24, $0, 0            # Initialize $24 to 0 -- Checks when if the CHECKSIDES opens or flags the index
            jal Check                  # Checking for unopened surrounding squares (value: -2)
NextOne:    add $17, $0, $8            # Record the number of unopened squares around the current index
            addi $9, $0, 9             # Initialize $9 to 9 (9 is the value to check if an index is flagged)
            jal Check                  # Checking for flagged or mined surrounding squares (value: 9)
NextTwo:    add $15, $0, $8            # Record the number of flagged squares around the current index
            addi $22, $0, -1           # Initialize $22 to tell CHECK LABEL to Open all the surrounding squares in the index
            lb $6, arr($2)             # Get value of current index
            beq $15, $6, OpenAll       # Checks if Value == Number of Flagged Squares -- Then Opens all the remaining squares
            j FlagNext                 # ELSE Check if all the squares around the index need to be flagged

OpenAll:    addi $24, $24, 1           # Addes 1 to $24 to show that all the squares have been opened
            jal Check                  # Open all surrounding squares that are not already opened or flagged
            j EndCheckSides            # Go back to Main Loop if no squares were opened or closed or to go back to Main to check all the squares all over again

FlagNext:   lb $6, arr($2)             # Load Current index value
            sub $15, $6, $8            # Get the number of neeed flags = value - already flagged
            addi $22, $0, -2           # Flag all surrounding squares that are not already opened or flagged
            beq $17, $15, FlagAll      # Checks if Not-Open Squares == needed Number of Flagged Squares -- Then Flags all the remaining squares
            j EndCheckSides            # Go back to Main Loop if no squares were opened or closed or to go back to Main to check all the squares all over again

FlagAll:    addi $24, $24, 1           # Addes 1 to $24 to show that all the squares have been flagged
            jal Check                  # Flag all surrounding squares that are not already opened or flagged

EndCheckSides:  bne $24, $0, EndCheckSides1  # Go back to Main to check all the squares all over again
                j MainLoop                   # Go back to Main Loop if no squares were opened or closed

EndCheckSides1:   sb $10, arr($7)      # Put 10 in the current index to show that it has already been checked
                  j Main               # Go back to Main Loop if no squares were opened or closed


########### END CHECK SIDES: ###################


########### START CHECK NOT OPEN OR FLAG: #################

Check:      add $25,$0, $31            # Adds the JAL value from $31 to register $25
            addi $8, $0, 0             # Initialize $8 to 0 -- Counts number of unopened or flagged squares surrounding the current index
            addi $27, $0, 0            # Counter for the Check Loop to check when to end
            add $7, $0, $2             # Transfer current index value to $7 to prevent $2 from changing

CheckLoop:  beq $27, $13, EndCheck     # Counter to 8 to end Loop
            lb $14, check($27)         # Get number of indices to add or subtract from the current index to get the surrounding squares
            addi $27, $27, 1           # Add Counter
            add $14, $14, $7           # Add the number of indices to add or subtract from the current index to get the surrounding squares
            lb $6, arr($14)            # Get value of the surrounding squares to check whether to open or flag all
            bne $6, $16, CheckNext0    # Check if the value is NOT -3 (Out of Bounds index)
            j CheckLoop                # Restart then Loop
CheckNext0: beq $22, $0, CheckNow      # Check if $22 is 0, then the Loop must Check the values of all the surrouding squares to check if they are unopened or flagged
            beq $22, $21, OpenNow      # Check if $22 is -1, then the Loop must open all the surrouding squares
            beq $22, $5, FlagNow       # Check if $22 is -2, then the Loop must flag all the surrouding squares
            j CheckLoop                # Restart then Loop
CheckNow:   beq $6, $9, CheckNow1      # Check if the current index value is either unopened or flagged
            j CheckLoop                # Restart then Loop
CheckNow1:  addi $8, $8, 1             # Add number of unopened or flagged indices surrounding the current index
            j CheckLoop                # Restart then Loop
OpenNow:    beq $6, $5, OpenNow1       # Check if the value is unopened, then open the current index
            j CheckLoop                # Restart then Loop
OpenNow1:   jal Open                   # Open current index
            j CheckLoop                # Restart then Loop
FlagNow:    beq $6, $5, FlagNow1       # Check if the value is unopened, then flag the current index
            j CheckLoop                # Restart then Loop
FlagNow1:   jal Flag                   # Flag current index
            j CheckLoop                # Restart then Loop

EndCheck:   add $2, $0, $7             # Restore $2 to its original index value
            jr $25                     # Return to place where it came from in the Main Loop


########### END CHECK NOT OPEN OR FLAG: ###################
