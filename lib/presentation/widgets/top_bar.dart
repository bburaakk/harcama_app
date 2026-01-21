import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/account.dart';
import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/entities/ledger.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/notifiers/account_notifier.dart';
import 'package:harcama_app/presentation/notifiers/category_notifier.dart';
import 'package:harcama_app/presentation/notifiers/ledger_notifier.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:intl/intl.dart';
import 'package:harcama_app/l10n/app_localizations.dart';

class TopBar extends StatelessWidget {
  final bool isSearching;
  final VoidCallback onSearchToggle;
  final VoidCallback? onLedgerTap;
  final VoidCallback? onCalendarTap;
  final String searchHint;
  final Function(String)? onSearchChanged;
  final VoidCallback? onSearchClear;

  const TopBar({
    super.key,
    required this.isSearching,
    required this.onSearchToggle,
    this.onLedgerTap,
    this.onCalendarTap,
    this.searchHint = "Search...",
    this.onSearchChanged,
    this.onSearchClear,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = AppColors.subtitleText(context);
    final l10n = AppLocalizations.of(context)!;
    
    // Default handlers if not provided
    final searchChanged = onSearchChanged ?? (query) {
      final txNotifier = context.read<TransactionNotifier>();
      txNotifier.updateSearchQuery(query);
    };
    
    final searchClear = onSearchClear ?? () {
      final txNotifier = context.read<TransactionNotifier>();
      txNotifier.updateSearchQuery('');
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isSearching
            ? Column(
                key: const ValueKey('search'),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          style: TextStyle(color: AppColors.text(context)),
                          decoration: InputDecoration(
                            hintText: searchHint,
                            hintStyle: TextStyle(color: AppColors.subtitleText(context)),
                            border: InputBorder.none,
                          ),
                          onChanged: searchChanged,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Symbols.close_rounded, color: iconColor),
                        onPressed: () {
                          searchClear();
                          onSearchToggle();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Consumer<TransactionNotifier>(
                    builder: (context, notifier, _) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _DropdownFilter(
                              label: l10n.transactionType,
                              selectedValue: notifier.filterType,
                              onChanged: (type) => notifier.setFilterType(type),
                            ),
                            const SizedBox(width: 8),
                            _CategoryDropdownFilter(
                              label: l10n.category,
                              selectedValue: notifier.filterCategory,
                              onChanged: (category) => notifier.setFilterCategory(category),
                            ),
                            const SizedBox(width: 8),
                            _LedgerDropdownFilter(
                              label: l10n.ledger,
                              selectedValue: notifier.filterLedger,
                              onChanged: (ledger) => notifier.setFilterLedger(ledger),
                            ),
                            const SizedBox(width: 8),
                            _AccountDropdownFilter(
                              label: l10n.account,
                              selectedValue: notifier.filterAccount,
                              onChanged: (account) => notifier.setFilterAccount(account),
                            ),
                            const SizedBox(width: 8),
                            _DateRangeFilter(
                              label: l10n.dateRange,
                              selectedValue: notifier.filterDateRange,
                              onChanged: (range) => notifier.setFilterDateRange(range),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )
            : Row(
                key: const ValueKey('normal'),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Ledger Menu Button (optional)
                  if (onLedgerTap != null)
                    PressableContainer(
                      onPressed: onLedgerTap!,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.primaryDark.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDark.withOpacity(0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Symbols.menu_book_rounded,
                        color: Colors.white,
                        size: 24,
                        weight: 700,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  
                  // Right Side Buttons
                  Row(
                    children: [
                      _buildSquareButton(
                        context,
                        icon: Symbols.search_rounded,
                        onTap: onSearchToggle,
                      ),
                      const SizedBox(width: 10),
                      _buildSquareButton(
                        context,
                        icon: Symbols.calendar_today_rounded,
                        onTap: onCalendarTap ?? () {},
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSquareButton(BuildContext context, {required IconData icon, required VoidCallback onTap}) {
    return PressableContainer(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.cardBorder(context),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardBorder(context),
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: Icon(
            icon,
            color: AppColors.subtitleText(context),
            size: 24,
            weight: 600,
          ),
        ),
      ),
    );
  }
}

class _DropdownFilter extends StatelessWidget {
  final String label;
  final TransactionType? selectedValue;
  final Function(TransactionType?) onChanged;

  const _DropdownFilter({
    required this.label,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue != null;
    final l10n = AppLocalizations.of(context)!;
    
    String getLabel(TransactionType? type) {
      if (type == null) return l10n.all;
      switch (type) {
        case TransactionType.income: return l10n.incomeLabel;
        case TransactionType.expense: return l10n.expensesLabel;
        case TransactionType.transfer: return l10n.transfer;
      }
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.subtitleText(context).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(
                    l10n.all,
                    style: TextStyle(
                      color: selectedValue == null ? AppColors.primary : AppColors.text(context),
                      fontWeight: selectedValue == null ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: selectedValue == null ? Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                  onTap: () {
                    onChanged(null);
                    Navigator.pop(context);
                  },
                ),
                ...TransactionType.values.map((type) => ListTile(
                  title: Text(
                    getLabel(type),
                    style: TextStyle(
                      color: selectedValue == type ? AppColors.primary : AppColors.text(context),
                      fontWeight: selectedValue == type ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: selectedValue == type ? Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                  onTap: () {
                    onChanged(type);
                    Navigator.pop(context);
                  },
                )),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedValue != null 
                  ? getLabel(selectedValue)
                  : label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryDropdownFilter extends StatelessWidget {
  final String label;
  final Category? selectedValue;
  final Function(Category?) onChanged;

  const _CategoryDropdownFilter({
    required this.label,
    required this.selectedValue,
    required this.onChanged,
  });

  String _getCategoryTitle(BuildContext context, Category cat) {
    final l10n = AppLocalizations.of(context)!;
    if (cat.id.startsWith('def_')) {
      switch (cat.title) {
        case 'Supermarket': return l10n.catSupermarket;
        case 'Transport': return l10n.catTransport;
        case 'Food': return l10n.catFood;
        case 'Bills': return l10n.catBills;
        case 'Fun': return l10n.catFun;
        case 'Health': return l10n.catHealth;
        case 'Clothing': return l10n.catClothing;
        case 'Salary': return l10n.catSalary;
        case 'Rent': return l10n.catRent;
        case 'Education': return l10n.catEducation;
        default: return cat.title;
      }
    }
    return cat.title;
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue != null;
    final categoryNotifier = context.watch<CategoryNotifier>();
    final l10n = AppLocalizations.of(context)!;
    
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.subtitleText(context).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Text(
                          l10n.allCategories,
                          style: TextStyle(
                            color: selectedValue == null ? AppColors.primary : AppColors.text(context),
                            fontWeight: selectedValue == null ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: selectedValue == null ? Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                        onTap: () {
                          onChanged(null);
                          Navigator.pop(context);
                        },
                      ),
                      if (categoryNotifier.categories.isEmpty)
                        ListTile(
                          title: Text(l10n.noCategoriesFound),
                          enabled: false,
                        )
                      else
                        ...categoryNotifier.categories.map((category) => ListTile(
                          leading: Text(category.icon, style: const TextStyle(fontSize: 24)),
                          title: Text(
                            _getCategoryTitle(context, category),
                            style: TextStyle(
                              color: selectedValue?.id == category.id ? AppColors.primary : AppColors.text(context),
                              fontWeight: selectedValue?.id == category.id ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          trailing: selectedValue?.id == category.id ? Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                          onTap: () {
                            onChanged(category);
                            Navigator.pop(context);
                          },
                        )),
                      SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedValue != null 
                  ? _getCategoryTitle(context, selectedValue!)
                  : label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _LedgerDropdownFilter extends StatelessWidget {
  final String label;
  final Ledger? selectedValue;
  final Function(Ledger?) onChanged;

  const _LedgerDropdownFilter({
    required this.label,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue != null;
    final ledgerNotifier = context.watch<LedgerNotifier>();
    final l10n = AppLocalizations.of(context)!;
    
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.subtitleText(context).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Text(
                          l10n.allLedgers,
                          style: TextStyle(
                            color: selectedValue == null ? AppColors.primary : AppColors.text(context),
                            fontWeight: selectedValue == null ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: selectedValue == null ? Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                        onTap: () {
                          onChanged(null);
                          Navigator.pop(context);
                        },
                      ),
                      if (ledgerNotifier.ledgers.isEmpty)
                        ListTile(
                          title: Text(l10n.noLedgersFound),
                          enabled: false,
                        )
                      else
                        ...ledgerNotifier.ledgers.map((ledger) => ListTile(
                          title: Text(
                            ledger.name,
                            style: TextStyle(
                              color: selectedValue?.id == ledger.id ? AppColors.primary : AppColors.text(context),
                              fontWeight: selectedValue?.id == ledger.id ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          trailing: selectedValue?.id == ledger.id ? Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                          onTap: () {
                            onChanged(ledger);
                            Navigator.pop(context);
                          },
                        )),
                      SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedValue != null 
                  ? selectedValue!.name
                  : label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountDropdownFilter extends StatelessWidget {
  final String label;
  final Account? selectedValue;
  final Function(Account?) onChanged;

  const _AccountDropdownFilter({
    required this.label,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue != null;
    final accountNotifier = context.watch<AccountNotifier>();
    final l10n = AppLocalizations.of(context)!;
    
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.subtitleText(context).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Text(
                          l10n.allAccounts,
                          style: TextStyle(
                            color: selectedValue == null ? AppColors.primary : AppColors.text(context),
                            fontWeight: selectedValue == null ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: selectedValue == null ? Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                        onTap: () {
                          onChanged(null);
                          Navigator.pop(context);
                        },
                      ),
                      if (accountNotifier.accounts.isEmpty)
                        ListTile(
                          title: Text(l10n.noAccountsFound),
                          enabled: false,
                        )
                      else
                        ...accountNotifier.accounts.map((account) => ListTile(
                          title: Text(
                            account.name,
                            style: TextStyle(
                              color: selectedValue?.id == account.id ? AppColors.primary : AppColors.text(context),
                              fontWeight: selectedValue?.id == account.id ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          trailing: selectedValue?.id == account.id ? Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                          onTap: () {
                            onChanged(account);
                            Navigator.pop(context);
                          },
                        )),
                      SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedValue != null 
                  ? selectedValue!.name
                  : label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateRangeFilter extends StatelessWidget {
  final String label;
  final DateTimeRange? selectedValue;
  final Function(DateTimeRange?) onChanged;

  const _DateRangeFilter({
    required this.label,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue != null;
    final dateFormat = DateFormat('dd MMM');
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          initialDateRange: selectedValue,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  surface: AppColors.card(context),
                  onSurface: AppColors.text(context),
                ),
              ),
              child: child!,
            );
          },
        );
        
        if (picked != null) {
          onChanged(picked);
        }
      },
      onLongPress: () {
        if (isSelected) {
          onChanged(null);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.dateFilterCleared), duration: const Duration(seconds: 1)),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isSelected 
                  ? "${dateFormat.format(selectedValue!.start)} - ${dateFormat.format(selectedValue!.end)}"
                  : label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
            ),
          ],
        ),
      ),
    );
  }
}
