// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get helloWorld => 'Merhaba Dünya!';

  @override
  String get searchTransactions => 'İşlemlerde ara...';

  @override
  String get yourGoals => 'Hedeflerin';

  @override
  String get seeAll => 'Tümünü Gör';

  @override
  String get recentActivity => 'Son Hareketler';

  @override
  String get remainingBalance => 'KALAN BAKİYE';

  @override
  String get newGoal => 'Yeni Hedef';

  @override
  String get noTransactionsFound => 'İşlem bulunamadı';

  @override
  String get weekly => 'Haftalık';

  @override
  String get monthly => 'AYLIK';

  @override
  String get yearly => 'Yıllık';

  @override
  String get thisWeek => 'BU HAFTA';

  @override
  String get thisMonth => 'BU AY';

  @override
  String get thisYear => 'BU YIL';

  @override
  String get noExpensesYet => 'Henüz harcama yok';

  @override
  String get profile => 'Profil';

  @override
  String get guestUser => 'Misafir Kullanıcı';

  @override
  String get localUsage => 'Yerel kullanım (hesap yok)';

  @override
  String get goPremium => 'Premium\'a Geç';

  @override
  String get unlockCloudSync =>
      'Bulut senkronizasyonu, sınırsız defter ve reklamsız deneyim.';

  @override
  String get upgradeNow => 'ŞİMDİ YÜKSELT';

  @override
  String get usageLimits => 'Kullanım Limitleri';

  @override
  String get ledgers => 'Defterler';

  @override
  String get accounts => 'Hesaplar';

  @override
  String get account => 'Hesap';

  @override
  String get signInCreateAccount => 'Giriş yap / Hesap oluştur';

  @override
  String get premiumOnly => 'Sadece Premium';

  @override
  String get data => 'Veri';

  @override
  String get localDataStored => 'Yerel veri saklanıyor';

  @override
  String get everythingStaysOnDevice => 'Her şey bu cihazda kalır';

  @override
  String get onlineBackup => 'Çevrimiçi yedekleme';

  @override
  String get automaticBackup => 'Otomatik yedekleme';

  @override
  String get exportData => 'Veriyi dışa aktar';

  @override
  String get ads => 'Reklamlar';

  @override
  String get removeAds => 'Reklamları kaldır';

  @override
  String get upgradeToPremium => 'Premium\'a Yükselt';

  @override
  String get about => 'Hakkında';

  @override
  String get appVersion => 'Uygulama sürümü';

  @override
  String get privacyPolicy => 'Gizlilik politikası';

  @override
  String get clearLocalData => 'YEREL VERİYİ SİL';

  @override
  String get thisActionCannotBeUndone => 'BU İŞLEM GERİ ALINAMAZ';

  @override
  String get clearLocalDataTitle => 'Yerel Veriyi Sil?';

  @override
  String get clearLocalDataContent =>
      'Bu işlem tüm işlemlerinizi kalıcı olarak silecektir. Bu işlem geri alınamaz.';

  @override
  String get cancel => 'İptal';

  @override
  String get deleteEverything => 'Her Şeyi Sil';

  @override
  String get allLocalDataCleared => 'Tüm yerel veri silindi.';

  @override
  String get howMuchDidYouSpend => 'Ne kadar harcadın?';

  @override
  String get description => 'Açıklama';

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String get income => 'GELİR';

  @override
  String get expense => 'GİDER';

  @override
  String get transfer => 'TRANSFER';

  @override
  String get selectCategory => 'KATEGORİ SEÇ';

  @override
  String get more => 'DAHA FAZLA';

  @override
  String get save => 'KAYDET';

  @override
  String get transaction => 'İşlem';

  @override
  String youHaveActiveGoals(int count) {
    return '$count aktif hedefin var!';
  }

  @override
  String get youreDoingGreat => 'Harika gidiyorsun! Aynen devam. 🚀';

  @override
  String get totalProgress => 'Toplam İlerleme';

  @override
  String get thisWeekProgress => 'Bu hafta +%5';

  @override
  String get activeStreak => 'Aktif Seri';

  @override
  String get days => 'Gün';

  @override
  String get keepTheFireBurning => 'Ateşi canlı tut!';

  @override
  String get goalTitle => 'HEDEF BAŞLIĞI';

  @override
  String get goalTitleHint => 'örn. Tatil Gezisi';

  @override
  String get descriptionOptional => 'AÇIKLAMA (İSTEĞE BAĞLI)';

  @override
  String get descriptionHint => 'Ne için biriktiriyorsun?';

  @override
  String get targetAmount => 'HEDEF TUTAR';

  @override
  String get targetAmountHint => 'örn. 5000';

  @override
  String get currentAmount => 'MEVCUT TUTAR';

  @override
  String get currentAmountHint => 'Ne kadarın var?';

  @override
  String get deadlineOptional => 'SON TARİH (İSTEĞE BAĞLI)';

  @override
  String get selectDeadline => 'Bir tarih seç';

  @override
  String get chooseIcon => 'İKON SEÇ';

  @override
  String get chooseColor => 'RENK SEÇ';

  @override
  String get create => 'OLUŞTUR';

  @override
  String get newLedger => 'Yeni Defter';

  @override
  String get deleteLedger => 'Defteri Sil?';

  @override
  String deleteLedgerConfirm(String name) {
    return '\"$name\" defterini silmek istediğinize emin misiniz?';
  }

  @override
  String get delete => 'Sil';

  @override
  String get ledgerName => 'DEFTER ADI';

  @override
  String get ledgerNameHint => 'örn. Tatil';

  @override
  String get editTransaction => 'İşlemi Düzenle';

  @override
  String get deleteTransaction => 'İşlemi sil?';

  @override
  String get deleteTransactionConfirm => 'Bu işlem geri alınamaz.';

  @override
  String get premium => 'Premium';

  @override
  String get hugeValue => 'BÜYÜK DEĞER';

  @override
  String get unlockTheBest => 'En İyisini Aç';

  @override
  String get takeControl => 'Sıfır limit ile finansal kontrolü ele al.';

  @override
  String get cloudBackupSync => 'Bulut Yedekleme & Senkronizasyon';

  @override
  String get neverLoseData => 'İşlem verilerini asla kaybetme.';

  @override
  String get advancedAnalytics => 'Gelişmiş Analizler';

  @override
  String get deepDiveSpending =>
      'Harcama alışkanlıklarını derinlemesine incele.';

  @override
  String get adFreeExperience => 'Reklamsız Deneyim';

  @override
  String get noInterruptions => 'Kesinti yok, sadece takip var.';

  @override
  String get smartFinanceTools => 'Akıllı Finans Araçları';

  @override
  String get aiBudgeting => 'Yapay zeka destekli bütçe önerileri.';

  @override
  String get yearlyAccess => 'YILLIK ERİŞİM';

  @override
  String get yearlyPrice => '₺249.99 / yıl';

  @override
  String get savePercent => '%30 TASARRUF';

  @override
  String get monthlyPrice => '₺20.83 / ay';

  @override
  String get monthlyFullPrice => '₺29.99 / ay';

  @override
  String get continueText => 'DEVAM ET';

  @override
  String get cancelAnytime => 'İSTEDİĞİN ZAMAN İPTAL ET';

  @override
  String get termsOfService => 'HİZMET ŞARTLARI';

  @override
  String get premiumWelcomeMessage =>
      'DOSTUM ARTIK SEN DE PREMİUMSUN HOŞGELDİN ARAMIZA 🤙';

  @override
  String get topExpenses => 'En Çok Harcananlar';

  @override
  String get totalSpent => 'TOPLAM HARCAMA';

  @override
  String get others => 'DİĞERLERİ';

  @override
  String get other => 'Diğer';

  @override
  String get totalBalance => 'Toplam Bakiye';

  @override
  String get expenses => 'Harcamalar';

  @override
  String get spendingInsights => 'Harcama Analizleri';

  @override
  String get weeklySpending => 'Haftalık Harcama';

  @override
  String get usageStatus => 'Kullanım Durumu';

  @override
  String get unlimited => 'Sınırsız';

  @override
  String get loggedIn => 'Giriş yapıldı';

  @override
  String get manageCloudAccount => 'Bulut hesabını yönet';

  @override
  String get dataManagement => 'Veri Yönetimi';

  @override
  String get safeInCloud => 'Bulutta güvende';

  @override
  String get syncingEveryChange => 'Her değişiklik senkronize ediliyor';

  @override
  String get csvJsonPdf => 'CSV, JSON, PDF';

  @override
  String get weeklySpendingTitle => 'Haftalık Harcama';

  @override
  String get monthlySpendingTitle => 'Aylık Harcama';

  @override
  String get yearlySpendingTitle => 'Yıllık Harcama';

  @override
  String get incomeLabel => 'Gelir';

  @override
  String get expensesLabel => 'Giderler';

  @override
  String get allLedgers => 'Tüm Defterler';

  @override
  String get subscriptions => 'Abonelikler';

  @override
  String get yourSubscriptions => 'Aboneliklerin';

  @override
  String get newSubscription => 'Yeni Abonelik';

  @override
  String get totalMonthlySubscriptions => 'Aylık Toplam';

  @override
  String activeSubscriptionsCount(int count) {
    return '$count aktif abonelik';
  }

  @override
  String get nextPayment => 'Next Payment';

  @override
  String get upcomingPayments => 'Upcoming Payments';

  @override
  String get subscriptionFrequencyDaily => 'Daily';

  @override
  String get subscriptionFrequencyWeekly => 'Weekly';

  @override
  String get subscriptionFrequencyMonthly => 'Monthly';

  @override
  String get subscriptionFrequencyYearly => 'Yearly';

  @override
  String get noSubscriptionsYet => 'Henüz abonelik yok';

  @override
  String get addYourFirstSubscription => 'İlk aboneliğini ekle';

  @override
  String get addCategory => 'Add Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get categoryName => 'Category Name';

  @override
  String get iconEmoji => 'Icon (Emoji)';

  @override
  String get deleteCategory => 'Delete Category?';

  @override
  String get deleteCategoryConfirm =>
      'Are you sure you want to delete this category?';

  @override
  String get defaultCategoryError => 'Default categories cannot be edited';

  @override
  String get manageSubscriptions => 'Aboneliklerinizi kolayca yönetin';

  @override
  String get active => 'AKTİF';

  @override
  String get paused => 'DURAKLATILDI';

  @override
  String get catSupermarket => 'Market';

  @override
  String get catTransport => 'Ulaşım';

  @override
  String get catFood => 'Yemek';

  @override
  String get catBills => 'Faturalar';

  @override
  String get catFun => 'Eğlence';

  @override
  String get catHealth => 'Sağlık';

  @override
  String get catClothing => 'Giyim';

  @override
  String get catSalary => 'Maaş';

  @override
  String get catRent => 'Kira';

  @override
  String get catEducation => 'Eğitim';

  @override
  String get transactionType => 'İşlem Tipi';

  @override
  String get category => 'Kategori';

  @override
  String get ledger => 'Defter';

  @override
  String get dateRange => 'Tarih Aralığı';

  @override
  String get all => 'Tümü';

  @override
  String get allCategories => 'Tüm Kategoriler';

  @override
  String get allAccounts => 'Tüm Hesaplar';

  @override
  String get noLedgersFound => 'Defter bulunamadı';

  @override
  String get noAccountsFound => 'Hesap bulunamadı';

  @override
  String get dateFilterCleared => 'Tarih filtresi temizlendi';

  @override
  String get noCategoriesFound => 'Kategori bulunamadı';

  @override
  String get applySelection => 'SEÇİMİ UYGULA';

  @override
  String get overview => 'Genel Bakış';
}
