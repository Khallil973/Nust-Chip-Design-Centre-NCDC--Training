#include <iostream>
using namespace std;


//#1
class Point {
private:
    int x, y;

public:
    Point(int u, int v) : x(u), y(v) {}
    int getX() const { return x; }
    int getY() const { return y; }
    void doubleVal() {
        x *= 2;
        y *= 2;
    }
};

int main() {

    //const Point myPoint(5, 3);
    //myPoint.doubleVal(); 
    
    Point myPoint(5, 3);     
    myPoint.doubleVal();     
    cout << myPoint.getX() << " " << myPoint.getY() << "\n";
    return 0;
}

//2

#include <iostream>
using namespace std;

class Point {
private:
    int x, y;

public:
    Point(int u, int v) : x(u), y(v) {}
    int getX() const { return x; }
    int getY() const { return y; }
 //   void setX(int newX) const { x = newX; }  
    void setX(int newX) { x = newX; }  
};

int main() {
    Point p(5, 3);
    p.setX(9001);  
    cout << p.getX() << ' ' << p.getY();
    return 0;
}


//3
//cout << p.x << " " << p.y << "\n";


#include <iostream>
using namespace std;

class Point {
private:
    int x, y;

public:
    Point(int u, int v) : x(u), y(v) {}
    int getX() { return x; }
    int getY() { return y; }
};

int main() {
    Point p(5, 3);
    cout << p.getX() << " " << p.getY() << "\n";  //Corrected line
    return 0;
}


//4
#include <iostream>
using namespace std;

class Point {
private:
    int x, y;

public:
    Point(int u, int v) : x(u), y(v) {}
    int getX() { return x; }

    void setX(int newX) {  //Move inside class and define once
        x = newX;
    }
};

int main() {
    Point p(5, 3);
    p.setX(0);  // Now allowed
    cout << p.getX() << " " << "\n";
    return 0;
}


//5

int size;
cin >> size;

int* nums = new int[size];
for (int i = 0; i < size; ++i) {
    cin >> nums[i];
}

// ... // Calculations with nums

delete[] nums;  //Correctly deallocates dynamic array


//6
#include <iostream>
using namespace std;

class Point {
private:
    int x, y;

public:
    Point(int u, int v) : x(u), y(v) {}
    int getX() { return x; }
    int getY() { return y; }
};

int main() {
    Point* p = new Point(5, 3);
    cout << p->getX() << ' ' << p->getY() << endl;

    delete p;  //Prevent memory leak
    return 0;
}
