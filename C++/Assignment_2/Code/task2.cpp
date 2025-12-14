#include <iostream>
#include <string>
using namespace std;

// BankAccount class definition
class BankAccount {
private:
    string accountHolder;
    double balance;

public:
    // Constructor to initialize name and balance
    BankAccount(string name, double initialBalance) {
        accountHolder = name;
        balance = initialBalance;
    }

    // Deposit function (returns this for method chaining)
    BankAccount* deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            cout << "Depositing $" << amount << "...\n";
        } else {
            cout << "Invalid deposit amount.\n";
        }
        return this;
    }

    // Withdraw function (returns this for method chaining)
    BankAccount* withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            cout << "Withdrawing $" << amount << "...\n";
        } else {
            cout << "Insufficient balance or invalid amount.\n";
        }
        return this;
    }

    // Display function (returns this for method chaining)
    BankAccount* display() {
        cout << "\nAccount Holder: " << accountHolder << endl;
        cout << "Current Balance: $" << balance << endl;
        return this;
    }
};

// Main function
int main() {
    string name;
    double initialAmount;

    cout << "Enter account holder name: ";
    getline(cin, name);

    cout << "Enter initial balance: ";
    cin >> initialAmount;

    // Create bank account object
    BankAccount account(name, initialAmount);

    // Demonstrate method chaining
    account.deposit(500)
           ->withdraw(300)
           ->display();

    return 0;
}
