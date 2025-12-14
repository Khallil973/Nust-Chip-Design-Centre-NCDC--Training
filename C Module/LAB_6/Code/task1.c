#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Task {
    char desc[100];
    int prior;
    char due_date[11]; // YYYY-MM-DD
    struct Task *next;
};

void displayTasks(struct Task *head) {
    if (head == NULL) {
        printf("\nNo tasks available.\n");
        return;
    }

    struct Task *temp = head;
    while (temp != NULL) {
        printf("\nDescription: %s\n", temp->desc);
        printf("Priority   : %d\n", temp->prior);
        printf("Due Date   : %s\n", temp->due_date);
        temp = temp->next;
    }
}

void addtask(struct Task **head) {
    struct Task *task2 = (struct Task *)malloc(sizeof(struct Task));

    printf("\nEnter Description: ");
    scanf(" %[^\n]", task2->desc);  // Accepts spaces

    printf("Enter Priority (1=High, 2=Medium, 3=Low): ");
    scanf("%d", &task2->prior);

    printf("Enter Due Date (YYYY-MM-DD): ");
    scanf("%s", task2->due_date);

    task2->next = NULL;

    // Insert at beginning if list is empty or due_date is earlier than head
    if (*head == NULL || strcmp(task2->due_date, (*head)->due_date) < 0) {
        task2->next = *head;
        *head = task2;
        return;
    }

    // Traverse to find the correct insertion point
    struct Task *current = *head;
    while (current->next != NULL && strcmp(task2->due_date, current->next->due_date) >= 0) {
        current = current->next;
    }

    // Insert the new task
    task2->next = current->next;
    current->next = task2;
}


void removeTask(struct Task **head){
	if(*head == NULL){
		printf("\nNo task to remove.\n");
		return;
	
	}
	
	char targetdesc[100];
	printf("Enter the Description of the Task to remove: ");
	scanf(" %[^\n]", targetdesc);
	
	struct Task *temp = *head;
	struct Task *prev = NULL;
	
    	// If head node itself holds the task to be deleted	
	if(strcmp(temp->desc, targetdesc) == 0){
		*head = temp->next;
		free(temp);
		printf("Task Removed Successfully \n");
		return;
	}

	//Search for the task
	while (temp != NULL && strcmp(temp->desc, targetdesc) != 0) {
	prev = temp;
	temp = temp->next;

	}
	
	if(temp == NULL){
		printf("Task not found\n");
		return;
	
	}
	
	prev->next = temp->next;
	free(temp);
	printf("Task Removed Successfully\n");

}

void updateTask(struct Task **head) {
    if (*head == NULL) {
        printf("\nNo tasks available to update.\n");
        return;
    }

    char targetdesc[100];
    printf("Enter the Description of the Task to update: ");
    scanf(" %[^\n]", targetdesc);

    struct Task *current = *head;
    struct Task *prev = NULL;

    while (current != NULL && strcmp(current->desc, targetdesc) != 0) {
        prev = current;
        current = current->next;
    }

    if (current == NULL) {
        printf("Task not found.\n");
        return;
    }

    printf("\nTask found: \nDescription: %s\nPriority: %d\nDue Date: %s\n",
           current->desc, current->prior, current->due_date);

    int newPriority;
    char newDueDate[11];

    printf("Enter new priority (1=High, 2=Medium, 3=Low): ");
    scanf("%d", &newPriority);

    printf("Enter new due date (YYYY-MM-DD): ");
    scanf("%s", newDueDate);

    // Remove current node from list
    if (prev == NULL) {
        *head = current->next;
    } else {
        prev->next = current->next;
    }

    // Update values
    current->prior = newPriority;
    strcpy(current->due_date, newDueDate);
    current->next = NULL;

    // Reinsert at correct position based on new due date
    if (*head == NULL || strcmp(current->due_date, (*head)->due_date) < 0) {
        current->next = *head;
        *head = current;
        printf("Task updated and reinserted successfully.\n");
        return;
    }

    struct Task *temp = *head;
    while (temp->next != NULL && strcmp(current->due_date, temp->next->due_date) >= 0) {
        temp = temp->next;
    }

    current->next = temp->next;
    temp->next = current;

    printf("Task updated and reinserted successfully.\n");
}





int main() {
    struct Task *head = NULL;  

    int choice;
    while (1) {
        printf("\n--- Task Management System ---\n");
        printf("1. Add Task\n");
        printf("2. Remove Task\n");
        printf("3. Display Tasks\n");
        printf("4. Update Tasks\n");
        printf("5. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);

        switch (choice) {
            case 1:
                addtask(&head);
                break;
            case 2:
                removeTask(&head);
                break;
            case 3:
                displayTasks(head);
                break;
            case 4:
                updateTask(&head);
                break;               
            case 5:
                printf("Exiting...\n");
                return 0;
            default:
                printf("Invalid choice. Try again.\n");
        }
    }

    return 0;
}




