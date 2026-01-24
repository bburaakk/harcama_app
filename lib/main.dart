import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:harcama_app/l10n/app_localizations.dart';
import 'package:harcama_app/data/repositories/account_repository_impl.dart';
import 'package:harcama_app/data/repositories/category_repository_impl.dart';
import 'package:harcama_app/data/repositories/ledger_repository_impl.dart';
import 'package:harcama_app/data/repositories/goal_repository_impl.dart';
import 'package:harcama_app/data/repositories/subscription_repository_impl.dart';
import 'package:harcama_app/domain/entities/account.dart';
import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/entities/ledger.dart';
import 'package:harcama_app/domain/entities/goal.dart';
import 'package:harcama_app/domain/entities/subscription.dart';
import 'package:harcama_app/domain/usecases/generic_usecase.dart';
import 'package:harcama_app/presentation/notifiers/account_notifier.dart';
import 'package:harcama_app/presentation/notifiers/category_notifier.dart';
import 'package:harcama_app/presentation/notifiers/ledger_notifier.dart';
import 'package:harcama_app/presentation/notifiers/goal_notifier.dart';
import 'package:harcama_app/presentation/notifiers/subscription_notifier.dart';
import 'package:harcama_app/presentation/notifiers/premium_notifier.dart';
import 'package:harcama_app/presentation/notifiers/language_notifier.dart';
import 'package:harcama_app/presentation/notifiers/navigation_notifier.dart';
import 'package:harcama_app/presentation/notifiers/currency_notifier.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:harcama_app/data/repositories/transaction_repository_impl.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/notifiers/theme_notifier.dart';
import 'package:harcama_app/presentation/pages/main_screen.dart';
import 'package:harcama_app/domain/entities/transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(LedgerAdapter());
  Hive.registerAdapter(GoalStatusAdapter());
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(SubscriptionFrequencyAdapter());
  Hive.registerAdapter(SubscriptionStatusAdapter());
  Hive.registerAdapter(SubscriptionAdapter());

  final transactionBox = await Hive.openBox<Transaction>('transactions');
  final categoryBox = await Hive.openBox<Category>('categories');
  final accountBox = await Hive.openBox<Account>('accounts');
  final ledgerBox = await Hive.openBox<Ledger>('ledgers');
  final goalBox = await Hive.openBox<Goal>('goals');
  final subscriptionBox = await Hive.openBox<Subscription>('subscriptions');
  final settingsBox = await Hive.openBox('settings');

  final transactionRepository = TransactionRepositoryImpl(transactionBox);
  final categoryRepository = CategoryRepositoryImpl(categoryBox);
  final accountRepository = AccountRepositoryImpl(accountBox);
  final ledgerRepository = LedgerRepositoryImpl(ledgerBox);
  final goalRepository = GoalRepositoryImpl(goalBox);
  final subscriptionRepository = SubscriptionRepositoryImpl(subscriptionBox);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(settingsBox),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageNotifier(settingsBox),
        ),
        ChangeNotifierProvider(
          create: (_) => CurrencyNotifier(settingsBox),
        ),
        ChangeNotifierProvider(
          create: (_) => NavigationNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => PremiumNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionNotifier(
            createUseCase: CreateUseCase<Transaction>(transactionRepository),
            deleteUseCase: DeleteUseCase<Transaction>(transactionRepository),
            getAllUseCase: GetAllUseCase<Transaction>(transactionRepository),
            updateUseCase: UpdateUseCase<Transaction>(transactionRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryNotifier(
            createUseCase: CreateUseCase<Category>(categoryRepository),
            deleteUseCase: DeleteUseCase<Category>(categoryRepository),
            getAllUseCase: GetAllUseCase<Category>(categoryRepository),
            updateUseCase: UpdateUseCase<Category>(categoryRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AccountNotifier(
            createUseCase: CreateUseCase<Account>(accountRepository),
            deleteUseCase: DeleteUseCase<Account>(accountRepository),
            getAllUseCase: GetAllUseCase<Account>(accountRepository),
            updateUseCase: UpdateUseCase<Account>(accountRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LedgerNotifier(
            createUseCase: CreateUseCase<Ledger>(ledgerRepository),
            deleteUseCase: DeleteUseCase<Ledger>(ledgerRepository),
            getAllUseCase: GetAllUseCase<Ledger>(ledgerRepository),
            updateUseCase: UpdateUseCase<Ledger>(ledgerRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => GoalNotifier(
            createUseCase: CreateUseCase<Goal>(goalRepository),
            deleteUseCase: DeleteUseCase<Goal>(goalRepository),
            getAllUseCase: GetAllUseCase<Goal>(goalRepository),
            updateUseCase: UpdateUseCase<Goal>(goalRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SubscriptionNotifier(
            createUseCase: CreateUseCase<Subscription>(subscriptionRepository),
            deleteUseCase: DeleteUseCase<Subscription>(subscriptionRepository),
            getAllUseCase: GetAllUseCase<Subscription>(subscriptionRepository),
            updateUseCase: UpdateUseCase<Subscription>(subscriptionRepository),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final languageNotifier = context.watch<LanguageNotifier>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: languageNotifier.currentLocale,
      themeMode: themeNotifier.currentTheme,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: AppColors.scaffoldBackgroundDark,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
