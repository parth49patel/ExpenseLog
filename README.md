# Expense Log

A simple and efficient expense tracking app built using SwiftUI and SwiftData.

## Features Implemented

### 📝 Expense Management
- Users can add new expenses with a title, amount, category, payment type, and date.
- Expenses are displayed in a detailed view with relevant information.
- Users can delete an expense from the detail view.

### 🔍 Filtering Options
- Users can filter expenses by **payment type** (e.g., Cash, Credit, Debit).
- Users can filter expenses by **category** (e.g., Food, Travel, Shopping).
- A **Clear Filters** option resets all applied filters.

### 💾 Data Persistence
- Uses **SwiftData** to persist expense records, ensuring they are saved across app sessions.

### 🏗️ SwiftUI Integrations
- `@Environment(\.dismiss)` is used to close views.
- `@Query` is used to fetch expenses from the SwiftData model.
- `modelContext.insert()` is used to save new expenses.
- `modelContext.delete()` allows users to remove an expense.

## 🔧 How It Works
1. Click the ➕ button to open the **Add Expense** screen.
2. Enter expense details (title, amount, category, payment type, and date) and save.
3. Tap on an expense to view its **detailed information**.
4. Use the **Filter** button to filter by **payment type** or **category**.
5. Click **Clear Filters** to reset all applied filters.
6. Click **Delete** to remove an expense permanently.

## 🛠️ Technologies Used
- **SwiftUI** for UI development
- **SwiftData** for local storage and persistence  

## 🚀 Future Enhancements  
- Integrate **CloudKit** for multi-device support.
- Include **charts and insights** for expense tracking.

## 📷 Screenshots
(Coming Soon)

## 📥 Installation

Clone the repository:
```sh
git clone https://github.com/parth49patel/ExpenseLog.git  
```
Open `ExpenseLog.xcodeproj` in Xcode and run the app on a simulator or device.
