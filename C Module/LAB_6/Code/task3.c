#include<stdio.h>
#include<stdlib.h>


struct node{
	int data;
	struct node *next;


};



//For Linked Listing 
struct node *list1(struct node *head, int data){
	struct node *newnode;
	newnode = (struct node*)malloc(sizeof(struct node));
	newnode->data = data;
	newnode->next = NULL;
	
	//If list is empty then new node become head
	if(head == NULL){
		return newnode;
	}
	
	//Traverse to the end of the list and insert the new node
	struct node *temp = head;
	while(temp->next != NULL){
		temp = temp->next;	
	}
	temp->next = newnode;
	return head;
}

//For creating the List throgh user 
struct node *createlist(int n){
	struct node *head = NULL;
	int value;
	
	for(int i =0; i<n; i++){
		printf("Enter Element %d: ", i+1);//to increment index
		scanf("%d", &value);
		head = list1(head, value);
	}
	return head;
	
		
}


//For sorting and merge
struct node *merge_and_sort_list(struct node *list1, struct node *list2){
	//Return alternate list
	if(list1 == NULL){
		return list2;
	}
	else if(list2 == NULL){
		return list1;
	
	}
	
	
	//Merge
	struct node *temp = list1;
	while(temp->next != NULL){
		temp = temp->next;
	}
	
	temp->next = list2;
	
	//Step 2, sort 
	struct node *i, *j;
	int temp_data;
	for(i = list1; i != NULL; i = i->next){
		for(j = i->next; j != NULL; j = j->next){
			if(i->data > j->data){
				temp_data = i->data;
				i->data = j->data;
				j->data = temp_data;
			
			
			}
		
		}
	}
	return list1;
}

void printlist(struct node *head){
	printf("Linked List:\n");
	while(head != NULL){
		printf("%d->", head->data);
		head = head->next;
	}
	printf("\n");
}

int main() {
	int n, m;
	struct node *head = NULL;
	struct node *head2 = NULL;
	struct node *merged = NULL;
	
	printf("How many elements do you want to insert? ");
	scanf("%d", &n);
	head = createlist(n);
	printf("First");
	printlist(head);
	
	printf("How many elements do you want to insert? ");
	scanf("%d", &m);
	head2 = createlist(m);
//	printf("Second");
	//printlist(head2);	
	
	
	merged = merge_and_sort_list(head, head2);
	printf("\nMerge and Sorted List: ");
	printlist(merged);
	
	return 0;
	

}





