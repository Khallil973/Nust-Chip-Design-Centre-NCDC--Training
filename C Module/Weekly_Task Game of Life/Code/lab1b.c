/*
 * lab1b.c
 *
 *  Created on:
 *      Author:
 */

/* include helper functions for game */
#include "lifegame.h"
#include <unistd.h> // for sleep()
#include <stdlib.h>  // for system("clear")

/* add whatever other includes here */

/* number of generations to evolve the world */
#define NUM_GENERATIONS 50

/* functions to implement -- can copy from Part A */

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

int main(int argc, char **argv) {
	int n;

	if (argc > 1) {
		initialize_world_from_file(argv[1]);
	} else {
		initialize_world(); // default pattern
	}
	for (n = 0; n < NUM_GENERATIONS; n++) {
		system("clear");          // clear screen (use "cls" on Windows)
		output_world();           // show current generation
		next_generation();        // evolve to next generation
		usleep(200000);           // pause for 0.2 seconds
}

	output_world(); // Show result in console
	save_world_to_file("world.txt"); // Save result to file

	return 0;
}


void next_generation(void) {
	/* TODO: for every cell, set the state in the next
	   generation according to the Game of Life rules

	   Hint: use get_next_state(x,y) */

	int x, y;
	int width = get_world_width();
	int height = get_world_height();

	for (x = 0; x < width; x++) {
		for (y = 0; y < height; y++) {
			int next = get_next_state(x, y);
			set_cell_state(x, y, next);
		}
	}
	finalize_evolution(); // Copy next to current
}

int get_next_state(int x, int y) {
    int neighbors = num_neighbors(x, y);
    int current = get_cell_state(x, y);

    if (current == 1) {
        if (neighbors < 2 || neighbors > 3) return 0;
        else return 1;
    } else {
        if (neighbors == 3) return 1;
        else return 0;
    }
}
int num_neighbors(int x, int y) {
    int count = 0;
    for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
            if (dx == 0 && dy == 0) continue;
            int nx = x + dx;
            int ny = y + dy;

            if (nx >= 0 && nx < get_world_width() &&
                ny >= 0 && ny < get_world_height()) {
                count += get_cell_state(nx, ny);
            }
        }
    }
    return count;
}