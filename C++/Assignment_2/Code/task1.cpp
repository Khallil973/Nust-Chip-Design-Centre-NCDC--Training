#include <iostream>
#include <vector>
#include <string>

using namespace std;

class Student {
public:
    string name;
    int rollNumber;
    vector<int> marks;
    double averageMarks;

    // Function to enter student data
    void inputStudent() {
        cout << "Enter student name: ";
        cin.ignore(); // Clear newline
        getline(cin, name);

        cout << "Enter roll number: ";
        cin >> rollNumber;

        int subjectCount;
        cout << "Enter number of subjects: ";
        cin >> subjectCount;

        marks.clear();
        int mark;
        int total = 0;

        for (int i = 0; i < subjectCount; i++) {
            cout << "Enter marks for subject " << (i + 1) << ": ";
            cin >> mark;
            marks.push_back(mark);
            total += mark;
        }

        if (subjectCount > 0) {
            averageMarks = (double)total / subjectCount;
        } else {
            averageMarks = 0;
        }
    }

    // Function to show student data
    void displayStudent() {
        cout << "Name: " << name << "\n";
        cout << "Roll Number: " << rollNumber << "\n";
        cout << "Marks: ";
        for (int m : marks) {
            cout << m << " ";
        }
        cout << "\nAverage Marks: " << averageMarks << "\n";
    }
};

// Global vector to store students
vector<Student> studentList;

// Add student
void addStudent() {
    Student s;
    s.inputStudent();
    
    // Check for duplicate roll number
    for (Student existing : studentList) {
        if (existing.rollNumber == s.rollNumber) {
            cout << "Roll number already exists. Cannot add student.\n";
            return;
        }
    }

    studentList.push_back(s);
    cout << "Student added successfully.\n";
}

// Display all students
void displayAllStudents() {
    if (studentList.size() == 0) {
        cout << "No student records found.\n";
        return;
    }

    for (int i = 0; i < studentList.size(); i++) {
        cout << "\n--- Student " << (i + 1) << " ---\n";
        studentList[i].displayStudent();
    }
}

// Search student by roll number
void searchStudent() {
    int roll;
    cout << "Enter roll number to search: ";
    cin >> roll;

    bool found = false;
    for (Student s : studentList) {
        if (s.rollNumber == roll) {
            cout << "\nStudent found:\n";
            s.displayStudent();
            found = true;
            break;
        }
    }

    if (!found) {
        cout << "Student not found.\n";
    }
}

// Update student marks
void updateMarks() {
    int roll;
    cout << "Enter roll number to update marks: ";
    cin >> roll;

    bool updated = false;
    for (int i = 0; i < studentList.size(); i++) {
        if (studentList[i].rollNumber == roll) {
            cout << "Enter new marks:\n";
            studentList[i].inputStudent();
            updated = true;
            cout << "Student marks updated.\n";
            break;
        }
    }

    if (!updated) {
        cout << "Student not found.\n";
    }
}

// Sort students by average marks (descending)
void sortStudentsByAverage() {
    if (studentList.size() == 0) {
        cout << "No students to sort.\n";
        return;
    }

    for (int i = 0; i < studentList.size() - 1; i++) {
        for (int j = i + 1; j < studentList.size(); j++) {
            if (studentList[i].averageMarks < studentList[j].averageMarks) {
                Student temp = studentList[i];
                studentList[i] = studentList[j];
                studentList[j] = temp;
            }
        }
    }

    cout << "Students sorted by average marks.\n";
}

// Menu display
void showMenu() {
    cout << "\nStudent Record Management System\n";
    cout << "1. Add Student\n";
    cout << "2. Display All Students\n";
    cout << "3. Search Student by Roll Number\n";
    cout << "4. Update Marks\n";
    cout << "5. Sort Students by Average Marks\n";
    cout << "6. Exit\n";
    cout << "Enter your choice: ";
}

// Main function
int main() {
    int choice;

    do {
        showMenu();
        cin >> choice;

        switch (choice) {
            case 1:
                addStudent();
                break;
            case 2:
                displayAllStudents();
                break;
            case 3:
                searchStudent();
                break;
            case 4:
                updateMarks();
                break;
            case 5:
                sortStudentsByAverage();
                break;
            case 6:
                cout << "Exiting program.\n";
                break;
            default:
                cout << "Invalid choice. Please try again.\n";
        }

    } while (choice != 6);

    return 0;
}
