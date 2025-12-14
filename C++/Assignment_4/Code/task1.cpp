#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Student {
private:
    string name;
    vector<int> marks;

public:
    // Constructor
    Student(string n) : name(n) {}

    // Add a mark
    void add_mark(int mark) {
        marks.push_back(mark);
    }

    // Display method
    void display() const {
        cout << "Name: " << name << endl;
        cout << "Marks: ";
        for (int m : marks) {
            cout << m << " ";
        }
        cout << endl;
    }

    // Friend function to access private members
    friend double calculate_average(const Student& s);
};

// Friend function to calculate average
double calculate_average(const Student& s) {
    if (s.marks.empty()) return 0.0;
    int total = 0;
    for (int mark : s.marks) {
        total += mark;
    }
    return static_cast<double>(total) / s.marks.size();
}

// Custom print function
void print_student(const Student& s) {
    s.display();
    cout << "Average: " << calculate_average(s) << endl << endl;
}

int main() {
    // Step 1: Create vector of students
    vector<Student> students;

    // Step 2: Add 3 students with different marks
    Student s1("Ali");
    s1.add_mark(80);
    s1.add_mark(90);
    s1.add_mark(85);
    students.push_back(s1);

    Student s2("Fatima");
    s2.add_mark(70);
    s2.add_mark(68);
    s2.add_mark(75);
    students.push_back(s2);

    Student s3("Ahmed");
    s3.add_mark(90);
    s3.add_mark(88);
    s3.add_mark(95);
    students.push_back(s3);

    // Step 3: Lambda to filter average > 75 and use function pointer to print
    cout << "Students with average marks > 75:\n";

    auto filter_and_print = [](const vector<Student>& list, void (*print_func)(const Student&)) {
        for (const Student& s : list) {
            if (calculate_average(s) > 75) {
                print_func(s);
            }
        }
    };

    // Step 4: Use function pointer
    filter_and_print(students, print_student);

    return 0;
}
