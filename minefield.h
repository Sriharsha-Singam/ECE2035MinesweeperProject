#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#ifndef MINE_SWEEPER
#define MINE_SWEEPER


/* open marks a cell as 'safe', and requests the system to reveal its
   neighboring cells (in the global array working_field).
   
   if a 'mine' is opened, the program will fail. 
   otherwise, it returns the number (of bombs in the neighboring cells)

   r:  row number of the cell to be opened (0 is top row).
   c:  column number of the cell to be opened (0 is leftmost column).
*/
int open(int r, int c);

/* flag marks a cell as 'mine'. 

   r:  row number of the cell to be opened (0 is top row).
   c:  column number of the cell to be opened (0 is leftmost column).
*/
void flag(int r, int c);

/* guess tells the system to reveal the contents of a cell. It may cause
   the program to fail if the guess is unnecessary. A guess is necessary only
   when (1) there are still unmarked mines, and (2) there is no way to infer
   where they are.

   For a necessary guess, if the cell actually contains a bomb, the system will
   treat the guess as a flag; if the cell is empty, the system will treat the
   guess as an open.

   return value: -1, the cell is a bomb.
                 0-8, the cell is empty, returning the number (of bombs in its neighbors).
*/
int guess(int r, int c);

/* display_working_field display the field that has been discovered so far.
*/
void display_field_discovered_so_far();

/* solver solves the minesweeper game
*/
void solver(int total_mine_num);

#endif
