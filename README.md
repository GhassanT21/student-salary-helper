Student Salary Helper

A simple Flutter application that helps students calculate their monthly salary, taxes, savings, and free money. The app uses one page only and does not require any database.

Features:

Base monthly salary

Overtime hours

Overtime rate

Extra income

Essentials (rent, food, transport…)

Savings target % (per month)

Optional target free-money goal

Tax band selection (5%, 12%, 20%)

Shows: gross income, tax amount, after-tax income, savings, free money, yearly totals, and a status message.

How to Run (Online)
flutter pub get
flutter run -d chrome

How to Run (Offline)

Run these one time only:

flutter create .
flutter pub get
flutter precache


Then run offline using:

flutter run -d chrome --web-renderer html
