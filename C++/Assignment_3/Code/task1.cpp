#include<iostream>
using namespace std;

class Rectangle{
private:
    int *width;
    int *height;


public:
    //Parameter Constructor
    Rectangle(int w, int h){
        width = new int(w);
        height = new int(h);
        cout<< "Constructor called. Rectangle created" << endl;
    }

    //Destructor
    ~Rectangle(){
        cout<< "Destructor called. Deleting Rectangle "<< endl;
        delete width;
        delete height; 
    }

    //Member function to calculate aera
    int area() const {
        return (*width) * (*height); 
    }

    //Member function to calculate parameter
    int parameter() const {
        return 2 * ((*width) + (*height));
    }

    //Member function to display details
    void display() const{
       cout<< "Width: " << *width << ", Height "<< *height << endl;
       cout<< "Area " <<area() << ", Parameter: "<< parameter() << endl;
       cout<< "-------------------------" << endl;
    }
};

int main(){

    Rectangle r1(4, 6);
    Rectangle r2(7,3);
 
    r1.display();
    r2.display();

    return 0;
}