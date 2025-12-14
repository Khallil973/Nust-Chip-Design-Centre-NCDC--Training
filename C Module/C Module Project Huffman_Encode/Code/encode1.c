#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LEN 64
#define MAX_ASCII 256
#define MAX_SYMBOLS 255


struct tnode {
    struct tnode* left;
    struct tnode* right;
    struct tnode* parent;
    struct tnode* next;
    float freq;
    int isleaf;
    char symbol;
};

void encode_text(FILE *fin, FILE *fout);
void free_tree(struct tnode* node);



/*global variables*/
char code[MAX_SYMBOLS][MAX_LEN];
struct tnode* root=NULL; /*tree of symbols*/
struct tnode* qhead=NULL; /*list of current symbols*/
struct cnode* chead=NULL;/*list of code*/

/*
    @function   talloc
    @desc       allocates new node 
*/
struct tnode* talloc(int symbol,float freq)
{
    struct tnode* p=(struct tnode*)malloc(sizeof(struct tnode));
    if(p!=NULL)
    {
        p->left=p->right=p->parent=p->next=NULL;
        p->symbol=symbol;
        p->freq=freq;
		p->isleaf=1;
    }
    return p;
}

/*
    @function display_tnode_list
    @desc     displays the list of tnodes during code construction
*/
void pq_display(struct tnode* head)
{
    struct tnode* p=NULL;
    printf("list:");
    for(p=head;p!=NULL;p=p->next)
    {
        printf("(%c,%f) ",p->symbol,p->freq);
    }
    printf("\n");
}

/*
    @function pq_insert
    @desc     inserts an element into the priority queue
    NOTE:     makes use of global variable qhead
*/
void pq_insert(struct tnode* p)
{
    struct tnode* curr = qhead;
    struct tnode* prev = NULL;

    printf("inserting:%c,%f\n", p->symbol, p->freq);

    if (qhead == NULL) { // Empty queue
        qhead = p;
        return;
    }

    // Find the position to insert
    while (curr != NULL && curr->freq <= p->freq) {
        prev = curr;
        curr = curr->next;
    }

    if (prev == NULL) { // Insert before head
        p->next = qhead;
        qhead = p;
    } else { // Insert between prev and curr
        prev->next = p;
        p->next = curr;
    }
}


/*
    @function pq_pop
    @desc     removes the first element
    NOTE:     makes use of global variable qhead
*/

struct tnode* pq_pop()
{
    struct tnode* p = qhead;
    if (qhead != NULL) {
        qhead = qhead->next;
        p->next = NULL; // Clean up link
        printf("popped:%c,%f\n", p->symbol, p->freq);
    }
    return p;
}

/*
	@function build_code
	@desc     generates the string codes given the tree
	NOTE: makes use of the global variable root
*/
void generate_code(struct tnode* root,int depth)
{
	int symbol;
	int len; /*length of code*/
	if(root->isleaf)
	{
		symbol=root->symbol;
		len   =depth;
		/*start backwards*/
		code[symbol][len]=0;
		
        int i = depth - 1;
        struct tnode* current = root;
        while (current->parent != NULL) {
            if (current->parent->left == current)
                code[symbol][i--] = '0';
            else
                code[symbol][i--] = '1';
            current = current->parent;  
        }
		printf("built code:%c,%s\n",symbol,code[symbol]);
	}
	else
	{
		generate_code(root->left,depth+1);
		generate_code(root->right,depth+1);
	}
	
}

/*
	@func	dump_code
	@desc	output code file
*/
void dump_code(FILE* fp)
{
	int i=0;
	for(i=0;i<MAX_SYMBOLS;i++)
	{
		if(code[i][0]) /*non empty*/
			fprintf(fp,"%c %s\n",i,code[i]);
	}
}

/*
	@func	encode
	@desc	outputs compressed stream
*/
void encode(char* str,FILE* fout)
{
	while(*str)
	{
		fprintf(fout,"%s",code[*str]);
		str++;
	}
}
/*
    @function main
*/
int main() {
    FILE *fp = fopen("book.txt", "r");
    if (!fp) {
        perror("Failed to open book.txt");
        return 1;
    }

    int freq[MAX_ASCII] = {0};
    char ch;

    // Count character frequencies
    while ((ch = fgetc(fp)) != EOF) {
        if (ch >= 0 && ch < MAX_ASCII)
            freq[(int)ch]++;
    }
    fclose(fp);

    // Initialize priority queue with frequency data
    for (int i = 0; i < MAX_ASCII; i++) {
        if (freq[i] > 0) {
            pq_insert(talloc((char)i, freq[i]));
        }
    }

    // Build Huffman tree
    struct tnode *lc, *rc, *p;
    while (qhead && qhead->parent) {
        lc = pq_pop();
        rc = pq_pop();
        p = talloc(0, lc->freq + rc->freq);
        p->isleaf = 0;
        p->left = lc;
        p->right = rc;
        lc->parent = rc->parent = NULL;
        pq_insert(p);
    }
    root = pq_pop();

    // Generate binary codes
    generate_code(root, 0);

    // Write code map to code.txt
    FILE *fcode = fopen("code.txt", "w");
    dump_code(stdout);   // also print to terminal
    dump_code(fcode);
    fclose(fcode);

    // Encode book.txt into encoded.txt
    FILE *fbook = fopen("book.txt", "r");
    FILE *fenc = fopen("encoded.txt", "w");
    encode_text(fbook, fenc);
    fclose(fbook);
    fclose(fenc);

    printf("Encoding complete. Files generated:\n");
    printf("  -> code.txt (symbol-to-code map)\n");
    printf("  -> encoded.txt (Huffman-encoded binary stream)\n");

    free_tree(root);

    return 0;
}
void encode_text(FILE *fin, FILE *fout) {
    char ch;
    while ((ch = fgetc(fin)) != EOF) {
        if (code[(unsigned char)ch][0]) {
            fputs(code[(unsigned char)ch], fout);
        }
    }
}

void free_tree(struct tnode* node) {
    if (!node) return;
    free_tree(node->left);
    free_tree(node->right);
    free(node);
}
