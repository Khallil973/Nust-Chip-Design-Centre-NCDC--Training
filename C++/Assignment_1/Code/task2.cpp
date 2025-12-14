#include <iostream>
#include <string>
using namespace std;

// Base Class
class CommissionEmployee {
protected:
    string firstName;
    string lastName;
    string socialSecurityNumber;
    double grossSale;
    double commissionRate;

public:
    // Constructor
    CommissionEmployee(string f, string l, string ssn, double gs, double cr)
        : firstName(f), lastName(l), socialSecurityNumber(ssn), grossSale(gs), commissionRate(cr) {

        }

    // Setters
    void setFirstName(string f) { 
        firstName = f; 
    }
    void setLastName(string l) {
         lastName = l; 
    }
    void setSocialSecurityNumber(string ssn) { 
        socialSecurityNumber = ssn; 
    }
    void setGrossSale(double gs) { 
        grossSale = gs; 
    }
    void setCommissionRate(double cr) { 
        commissionRate = cr; 
    }

    // Getters
    string getFirstName() { 
        return firstName; 
    }
    string getLastName() { 
        return lastName; 
    }
    string getSocialSecurityNumber() { 
        return socialSecurityNumber; 
    }
    double getGrossSale() { 
        return grossSale; 
    }
    double getCommissionRate() { 
        return commissionRate; 
    }

    // Virtual function for polymorphism
    virtual double earnings() {
        return grossSale * commissionRate;
    }
    //Print
    void print() {
        cout << "Commission Employee: " << firstName << " " << lastName << endl;
        cout << "SSN: " << socialSecurityNumber << endl;
        cout << "Gross Sales: " << grossSale << endl;
        cout << "Commission Rate: " << commissionRate << endl;
        cout << "Earnings: " << earnings() << endl;
    }
};

// Derived Class
class BasePlusCommissionEmployee : public CommissionEmployee {
protected:
    double baseSalary;

public:
    // Constructor
    BasePlusCommissionEmployee(string f, string l, string ssn, double gs, double cr, double bs)
        : CommissionEmployee(f, l, ssn, gs, cr), baseSalary(bs) {

        }

    void setBase(double bs) { 
        baseSalary = bs; 
    }
    double getBase() { 
        return baseSalary; 
    }

    // Override earnings
    double earnings() override {
        return baseSalary + (grossSale * commissionRate);
    }

    void print() {
        cout << "Base + Commission Employee: " << firstName << " " << lastName << endl;
        cout << "SSN: " << socialSecurityNumber << endl;
        cout << "Gross Sales: " << grossSale << endl;
        cout << "Commission Rate: " << commissionRate << endl;
        cout << "Base Salary: " << baseSalary << endl;
        cout << "Earnings: " << earnings() << endl;
    }
};

int main() {
    // Base class object
    CommissionEmployee CE("Khalil", "Rehman", "123-45-6789", 10000, 0.06);
    CE.print();
    cout << "-----------------------------" << endl;

    // Derived class object
    BasePlusCommissionEmployee BCE("Ali", "Ahmed", "987-65-4321", 8000, 0.05, 2000);
    BCE.print();
    cout << "-----------------------------" << endl;

    // Base class reference pointing to derived class object
    CommissionEmployee &ref = BCE;

    // Call earnings using the base class reference
    cout << "Calling earnings() using base class reference: " << ref.earnings() << endl;

    return 0;
}
