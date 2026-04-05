# FinanceFlow - Personal Finance Companion

A beautiful, real-time personal finance tracking app built with Flutter, designed for Indian users. Track your transactions,  monitor savings goals, and understand your spending patterns with an intuitive mobile-first interface.

## 🎯 Features

### ✨ Core Features
- **Real-Time Transaction Tracking**: Add, edit, delete, and view all your financial transactions instantly
- **Live Balance Calculation**: Watch your balance update in real-time as you add transactions
- **Smart Categories**: Organize transactions with predefined categories (Salary, Food, Transport, Entertainment, Shopping, Utilities, Health, Education, Freelance, Investment)
- **Savings Goals**: Set and track multiple savings goals with progress indicators
- **Spending Insights**: View detailed analytics and patterns of your spending habits

### 💰 India-Focused
- **Indian Rupee (₹)**: All transactions displayed in ₹ with proper Indian number formatting (Cr, L, K)
- **Designed for Indian Users**: UI/UX optimized for Indian financial habits and preferences
- **No Data Limits**: Unlimited transaction tracking

### 🎨 Beautiful UI
- **Modern Design**: Clean, intuitive interface with Material 3 principles
- **India-Inspired Colors**: Saffron, White, Green, and Blue color scheme
- **Smooth Animations**: Fluid transitions and loading states
- **Empty States**: Helpful prompts when no data exists
- **Responsive Layout**: Works seamlessly on phones and tablets

### 📊 Analytics & Insights
- **Summary Dashboard**: Quick overview of balance, income, and expenses
- **Recent Transactions**: See latest 5 transactions at a glance
- **Category Breakdown**: Understand spending by category
- **Income vs Expenses**: Visual comparison of earnings and spendings
- **Goal Progress**: Track savings goal achievements with percentage indicators

### 💾 Local Data Storage
- **Persistent Storage**: Uses SharedPreferences for reliable, fast local storage
- **Privacy First**: All data stays on your device - no cloud sync, no tracking
- **Real-Time Sync**: Changes save instantly to local storage
- **Backup Ready**: Easy data export and import

## 🚀 Getting Started

### Prerequisites
- Flutter 3.4.3 or higher
- Dart 3.4.3 or higher
- Android SDK (for Android) or Xcode (for iOS)

### Installation

1. **Clone the Repository**
```bash
git clone <repository-url>
cd app
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Run the App**

**On Android Device/Emulator:**
```bash
flutter run
```

**On iOS Device/Simulator:**
```bash
flutter run -d ios
```

**On Web (Chrome):**
```bash
flutter run -d chrome
```

**On Windows Desktop:**
```bash
flutter run -d windows
```

## 📱 App Structure

```
lib/
├── main.dart                 # App entry point and navigation
├── models/
│   ├── transaction.dart     # Transaction data model
│   └── goal.dart            # Savings goal model
├── providers/
│   └── finance_provider.dart # State management (ChangeNotifier)
├── screens/
│   ├── home_screen.dart           # Dashboard with summary
│   ├── transaction_screen.dart     # Transaction list and management
│   ├── add_transaction_screen.dart # Create/edit transactions
│   ├── goals_screen.dart           # Goals management
│   └── insights_screen.dart        # Analytics and insights
├── services/
│   └── storage_service.dart   # Local data persistence
├── widgets/
│   ├── action_button.dart
│   ├── category_selector.dart
│   ├── custom_text_field.dart
│   ├── dashboard_card.dart
│   ├── goal_card.dart
│   └── transaction_item.dart
├── utils/
│   ├── constants.dart    # App colors, spacing, shadows
│   └── extensions.dart   # Utility extensions for DateTime and Double
```

## 🛠️ Technology Stack

- **Framework**: Flutter 3.4.3
- **State Management**: Provider 6.1.5
- **Local Storage**: SharedPreferences 2.2.3
- **Charts**: fl_chart 0.68.0
- **Date/Time**: intl 0.19.0
- **UUID**: uuid 4.0.0

## 💡 Usage

### Adding a Transaction
1. Open the app and tap "Transactions" tab
2. Click the "+" button to add a new transaction
3. Enter amount, select type (Income/Expense)
4. Choose a category
5. Add optional description and notes
6. Tap "Save" - instantly updates your balance!

### Creating a Savings Goal
1. Go to "Goals" tab
2. Click "Add Goal"
3. Set target amount and deadline
4. Name your goal (e.g., "Holiday Fund", "Emergency Fund")
5. Track progress as you add income transactions

### Viewing Insights
1. Open "Insights" tab
2. See spending by category
3. View income vs expenses comparison
4. Check spending trends

## 🎨 Color Scheme

- **Primary (Saffron)**: #F97316 - Main accent color
- **Secondary (Green)**: #059669 - Success and income
- **Accent (Blue)**: #1E40AF - Information and savings
- **Danger (Red)**: #DC2626 - Expenses
- **Background**: #FAFAFA - Light gray

## 📋 Category List

- 💼 **Salary** - Regular income
- 💻 **Freelance** - Project income
- 💰 **Investment** - Investment returns
- 🍔 **Food** - Groceries and dining
- 🚗 **Transport** - Travel expenses
- 🎬 **Entertainment** - Movies, games
- 🛍️ **Shopping** - Retail purchases
- 💡 **Utilities** - Bill payments
- 🏥 **Health** - Medical expenses
- 📚 **Education** - Learning costs
- 📦 **Other** - Miscellaneous

## 📊 Real-Time Features

✅ **Instant Balance Updates** - See balance change immediately  
✅ **Live Calculation** - All summaries calculated instantaneously  
✅ **Automatic Sorting** - Transactions sorted by date  
✅ **Quick Search** - Find transactions by description  
✅ **Category Filtering** - View spending by category  
✅ **Auto-Save** - Every action saves to local storage  

## 🔒 Privacy & Security

- ✅ All data stored locally on device
- ✅ No internet connection required
- ✅ No tracking or analytics
- ✅ No third-party data sharing
- ✅ Full user control over data

## 🎯 Roadmap

- [ ] Export data as CSV/PDF
- [ ] Monthly budget limits
- [ ] Spending alerts
- [ ] Dark mode
- [ ] Multi-language support
- [ ] Recurring transactions
- [ ] Receipt images
- [ ] Data cloud backup (optional)

## 🐛 Troubleshooting

### App won't compile?
```bash
flutter clean
flutter pub get
flutter run
```

### Data not persisting?
- Ensure SharedPreferences has write permissions
- Check device storage space
- Restart the app

### Performance issues?
- Close other apps
- Clear app cache
- Reinstall the app

## 📞 Support

For issues, feature requests, or questions:
- Create an issue on GitHub
- Check existing documentation
- Review the code comments

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

## 🙏 Acknowledgments

- Built with Flutter and Dart
- Material 3 design principles
- India-focused user experience
- Open source community

---

**Made with ❤️ for managing finances the smart way.**

Last Updated: April 2026
