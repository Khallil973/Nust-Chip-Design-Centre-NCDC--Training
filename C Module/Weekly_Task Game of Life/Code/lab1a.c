/*
 * lab1a.c
 *
 *  Created on:
 *      Author:
 */

/* include helper functions for game */
#include "lifegame.h"

/* add whatever other includes here */

/* number of generations to evolve the world */
#define NUM_GENERATIONS 50

/* functions to implement */

/* this function should set the state of all
   the cells in the next generation and call
   finalize_evolution() to update the current
   state of the world to the next generation */
void next_generation(void);

/* this function should return the state of the cell
   at (x,y) in the next generation, according to the
   rules of Conway's Game of Life (see handout) */
int get_next_state(int x, int y);

/* this function should calculate the number of alive
   neighbors of the cell at (x,y) */
int num_neighbors(int x, int y);

int main(void)
{
	int n;

	initialize_world(); 
	/* TODO: initialize the world */


	for (n = 0; n < NUM_GENERATIONS; n++)
		next_generation();

	/* TODO: output final world state */
    output_world();  // Show the final world state

	return 0;
}


void next_generation(void) {
    	/* TODO: for every cell, set the state in the next
	   generation according to the Game of Life rules

	   Hint: use get_next_state(x,y) */
	for (int x = 0; x < get_world_width(); x++) {
        for (int y = 0; y < get_world_height(); y++) {
            int next = get_next_state(x, y);
            set_cell_state(x, y, next);
        }
    }
    finalize_evolution();  // updates the world state
}


int get_next_state(int x, int y) {
  	/* TODO: for the specified cell, compute the state in
	   the next generation using the rules

	   Use num_neighbors(x,y) to compute the number of live
	   neighbors */
	int alive_neighbors = num_neighbors(x, y);
    int current_state = get_cell_state(x, y);

    if (current_state == ALIVE) {
        if (alive_neighbors < 2 || alive_neighbors > 3)
            return DEAD;
        else
            return ALIVE;
    } else {
        if (alive_neighbors == 3)
            return ALIVE;
        else
            return DEAD;
    }
}


int num_neighbors(int x, int y) {
   	/* TODO: for the specified cell, return the number of
	   neighbors that are ALIVE

	   Use get_cell_state(x,y) */
	int count = 0;
    for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
            if (dx == 0 && dy == 0)
                continue;  // skip the cell itself

            int nx = x + dx;
            int ny = y + dy;

            if (nx >= 0 && nx < get_world_width() && ny >= 0 && ny < get_world_height()) {
                if (get_cell_state(nx, ny) == ALIVE)
                    count++;
            }
        }
    }
    return count;
}
