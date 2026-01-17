import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @searchTransactions.
  ///
  /// In en, this message translates to:
  /// **'Search transactions...'**
  String get searchTransactions;

  /// No description provided for @yourGoals.
  ///
  /// In en, this message translates to:
  /// **'Your Goals'**
  String get yourGoals;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @remainingBalance.
  ///
  /// In en, this message translates to:
  /// **'REMAINING BALANCE'**
  String get remainingBalance;

  /// No description provided for @newGoal.
  ///
  /// In en, this message translates to:
  /// **'New Goal'**
  String get newGoal;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get noTransactionsFound;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'MONTHLY'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'THIS WEEK'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'THIS MONTH'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'THIS YEAR'**
  String get thisYear;

  /// No description provided for @noExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get noExpensesYet;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @localUsage.
  ///
  /// In en, this message translates to:
  /// **'Local usage (no account)'**
  String get localUsage;

  /// No description provided for @goPremium.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get goPremium;

  /// No description provided for @unlockCloudSync.
  ///
  /// In en, this message translates to:
  /// **'Unlock cloud sync, unlimited ledgers, and zero ads.'**
  String get unlockCloudSync;

  /// No description provided for @upgradeNow.
  ///
  /// In en, this message translates to:
  /// **'UPGRADE NOW'**
  String get upgradeNow;

  /// No description provided for @usageLimits.
  ///
  /// In en, this message translates to:
  /// **'Usage Limits'**
  String get usageLimits;

  /// No description provided for @ledgers.
  ///
  /// In en, this message translates to:
  /// **'Ledgers'**
  String get ledgers;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @signInCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in / Create account'**
  String get signInCreateAccount;

  /// No description provided for @premiumOnly.
  ///
  /// In en, this message translates to:
  /// **'Premium only'**
  String get premiumOnly;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @localDataStored.
  ///
  /// In en, this message translates to:
  /// **'Local data stored'**
  String get localDataStored;

  /// No description provided for @everythingStaysOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Everything stays on this device'**
  String get everythingStaysOnDevice;

  /// No description provided for @onlineBackup.
  ///
  /// In en, this message translates to:
  /// **'Online backup'**
  String get onlineBackup;

  /// No description provided for @automaticBackup.
  ///
  /// In en, this message translates to:
  /// **'Automatic backup'**
  String get automaticBackup;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get exportData;

  /// No description provided for @ads.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get ads;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove ads'**
  String get removeAds;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @clearLocalData.
  ///
  /// In en, this message translates to:
  /// **'CLEAR LOCAL DATA'**
  String get clearLocalData;

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'THIS ACTION CANNOT BE UNDONE'**
  String get thisActionCannotBeUndone;

  /// No description provided for @clearLocalDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Local Data?'**
  String get clearLocalDataTitle;

  /// No description provided for @clearLocalDataContent.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your transactions. This action cannot be undone.'**
  String get clearLocalDataContent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteEverything.
  ///
  /// In en, this message translates to:
  /// **'Delete Everything'**
  String get deleteEverything;

  /// No description provided for @allLocalDataCleared.
  ///
  /// In en, this message translates to:
  /// **'All local data cleared.'**
  String get allLocalDataCleared;

  /// No description provided for @howMuchDidYouSpend.
  ///
  /// In en, this message translates to:
  /// **'How much did you spend?'**
  String get howMuchDidYouSpend;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'INCOME'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'EXPENSE'**
  String get expense;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'TRANSFER'**
  String get transfer;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'SELECT CATEGORY'**
  String get selectCategory;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'MORE'**
  String get more;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get save;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @youHaveActiveGoals.
  ///
  /// In en, this message translates to:
  /// **'You have {count} active goals!'**
  String youHaveActiveGoals(int count);

  /// No description provided for @youreDoingGreat.
  ///
  /// In en, this message translates to:
  /// **'You\'re doing great! Keep it up. 🚀'**
  String get youreDoingGreat;

  /// No description provided for @totalProgress.
  ///
  /// In en, this message translates to:
  /// **'Total Progress'**
  String get totalProgress;

  /// No description provided for @thisWeekProgress.
  ///
  /// In en, this message translates to:
  /// **'+5% this week'**
  String get thisWeekProgress;

  /// No description provided for @activeStreak.
  ///
  /// In en, this message translates to:
  /// **'Active Streak'**
  String get activeStreak;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @keepTheFireBurning.
  ///
  /// In en, this message translates to:
  /// **'Keep the fire burning!'**
  String get keepTheFireBurning;

  /// No description provided for @goalTitle.
  ///
  /// In en, this message translates to:
  /// **'GOAL TITLE'**
  String get goalTitle;

  /// No description provided for @goalTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Vacation Trip'**
  String get goalTitleHint;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'DESCRIPTION (OPTIONAL)'**
  String get descriptionOptional;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What are you saving for?'**
  String get descriptionHint;

  /// No description provided for @targetAmount.
  ///
  /// In en, this message translates to:
  /// **'TARGET AMOUNT'**
  String get targetAmount;

  /// No description provided for @targetAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5000'**
  String get targetAmountHint;

  /// No description provided for @currentAmount.
  ///
  /// In en, this message translates to:
  /// **'CURRENT AMOUNT'**
  String get currentAmount;

  /// No description provided for @currentAmountHint.
  ///
  /// In en, this message translates to:
  /// **'How much do you have?'**
  String get currentAmountHint;

  /// No description provided for @deadlineOptional.
  ///
  /// In en, this message translates to:
  /// **'DEADLINE (OPTIONAL)'**
  String get deadlineOptional;

  /// No description provided for @selectDeadline.
  ///
  /// In en, this message translates to:
  /// **'Select a deadline'**
  String get selectDeadline;

  /// No description provided for @chooseIcon.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE ICON'**
  String get chooseIcon;

  /// No description provided for @chooseColor.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE COLOR'**
  String get chooseColor;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'CREATE'**
  String get create;

  /// No description provided for @newLedger.
  ///
  /// In en, this message translates to:
  /// **'New Ledger'**
  String get newLedger;

  /// No description provided for @deleteLedger.
  ///
  /// In en, this message translates to:
  /// **'Delete Ledger?'**
  String get deleteLedger;

  /// No description provided for @deleteLedgerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deleteLedgerConfirm(String name);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @ledgerName.
  ///
  /// In en, this message translates to:
  /// **'LEDGER NAME'**
  String get ledgerName;

  /// No description provided for @ledgerNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Vacation'**
  String get ledgerNameHint;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransaction;

  /// No description provided for @deleteTransaction.
  ///
  /// In en, this message translates to:
  /// **'Delete transaction?'**
  String get deleteTransaction;

  /// No description provided for @deleteTransactionConfirm.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteTransactionConfirm;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @hugeValue.
  ///
  /// In en, this message translates to:
  /// **'HUGE VALUE'**
  String get hugeValue;

  /// No description provided for @unlockTheBest.
  ///
  /// In en, this message translates to:
  /// **'Unlock the Best'**
  String get unlockTheBest;

  /// No description provided for @takeControl.
  ///
  /// In en, this message translates to:
  /// **'Take control of your finances with zero limits.'**
  String get takeControl;

  /// No description provided for @cloudBackupSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud Backup & Sync'**
  String get cloudBackupSync;

  /// No description provided for @neverLoseData.
  ///
  /// In en, this message translates to:
  /// **'Never lose your transaction data.'**
  String get neverLoseData;

  /// No description provided for @advancedAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Advanced Analytics'**
  String get advancedAnalytics;

  /// No description provided for @deepDiveSpending.
  ///
  /// In en, this message translates to:
  /// **'Deep dive into your spending habits.'**
  String get deepDiveSpending;

  /// No description provided for @adFreeExperience.
  ///
  /// In en, this message translates to:
  /// **'Ad-Free Experience'**
  String get adFreeExperience;

  /// No description provided for @noInterruptions.
  ///
  /// In en, this message translates to:
  /// **'No interruptions, just tracking.'**
  String get noInterruptions;

  /// No description provided for @smartFinanceTools.
  ///
  /// In en, this message translates to:
  /// **'Smart Finance Tools'**
  String get smartFinanceTools;

  /// No description provided for @aiBudgeting.
  ///
  /// In en, this message translates to:
  /// **'AI-powered budgeting insights.'**
  String get aiBudgeting;

  /// No description provided for @yearlyAccess.
  ///
  /// In en, this message translates to:
  /// **'YEARLY ACCESS'**
  String get yearlyAccess;

  /// No description provided for @yearlyPrice.
  ///
  /// In en, this message translates to:
  /// **'₺249.99 / year'**
  String get yearlyPrice;

  /// No description provided for @savePercent.
  ///
  /// In en, this message translates to:
  /// **'SAVE 30%'**
  String get savePercent;

  /// No description provided for @monthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'₺20.83 / mo'**
  String get monthlyPrice;

  /// No description provided for @monthlyFullPrice.
  ///
  /// In en, this message translates to:
  /// **'₺29.99 / month'**
  String get monthlyFullPrice;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get continueText;

  /// No description provided for @cancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'CANCEL ANYTIME'**
  String get cancelAnytime;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'TERMS OF SERVICE'**
  String get termsOfService;

  /// No description provided for @premiumWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'WELCOME TO PREMIUM! 🤙'**
  String get premiumWelcomeMessage;

  /// No description provided for @topExpenses.
  ///
  /// In en, this message translates to:
  /// **'Top Expenses'**
  String get topExpenses;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'TOTAL SPENT'**
  String get totalSpent;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'OTHERS'**
  String get others;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @spendingInsights.
  ///
  /// In en, this message translates to:
  /// **'Spending Insights'**
  String get spendingInsights;

  /// No description provided for @weeklySpending.
  ///
  /// In en, this message translates to:
  /// **'Weekly Spending'**
  String get weeklySpending;

  /// No description provided for @usageStatus.
  ///
  /// In en, this message translates to:
  /// **'Usage Status'**
  String get usageStatus;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @loggedIn.
  ///
  /// In en, this message translates to:
  /// **'Logged in'**
  String get loggedIn;

  /// No description provided for @manageCloudAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage your cloud account'**
  String get manageCloudAccount;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @safeInCloud.
  ///
  /// In en, this message translates to:
  /// **'Safe in the cloud'**
  String get safeInCloud;

  /// No description provided for @syncingEveryChange.
  ///
  /// In en, this message translates to:
  /// **'Syncing every change'**
  String get syncingEveryChange;

  /// No description provided for @csvJsonPdf.
  ///
  /// In en, this message translates to:
  /// **'CSV, JSON, PDF'**
  String get csvJsonPdf;

  /// No description provided for @weeklySpendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Spending'**
  String get weeklySpendingTitle;

  /// No description provided for @monthlySpendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Spending'**
  String get monthlySpendingTitle;

  /// No description provided for @yearlySpendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Yearly Spending'**
  String get yearlySpendingTitle;

  /// No description provided for @incomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeLabel;

  /// No description provided for @expensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesLabel;

  /// No description provided for @allLedgers.
  ///
  /// In en, this message translates to:
  /// **'All Ledgers'**
  String get allLedgers;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
