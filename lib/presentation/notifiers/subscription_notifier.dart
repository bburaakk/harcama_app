import 'package:harcama_app/domain/entities/subscription.dart';
import 'package:harcama_app/domain/usecases/generic_usecase.dart';
import 'package:harcama_app/presentation/notifiers/base_notifier.dart';

class SubscriptionNotifier extends BaseNotifier<Subscription> {
  SubscriptionNotifier({
    required CreateUseCase<Subscription> createUseCase,
    required UpdateUseCase<Subscription> updateUseCase,
    required DeleteUseCase<Subscription> deleteUseCase,
    required GetAllUseCase<Subscription> getAllUseCase,
  }) : super(
         createUseCase: createUseCase,
         updateUseCase: updateUseCase,
         deleteUseCase: deleteUseCase,
         getAllUseCase: getAllUseCase,
       );

  List<Subscription> get subscriptions => items;

  List<Subscription> get activeSubscriptions => subscriptions
      .where((s) => s.status == SubscriptionStatus.active)
      .toList();

  double get totalMonthlyAmount => activeSubscriptions.fold(
    0.0,
    (sum, subscription) => sum + subscription.monthlyAmount,
  );

  double get totalYearlyAmount => totalMonthlyAmount * 12;

  int get activeSubscriptionsCount => activeSubscriptions.length;

  List<Subscription> get upcomingPayments {
    final now = DateTime.now();
    final upcoming = activeSubscriptions.where((subscription) {
      final nextPayment = subscription.nextPaymentDate;
      final daysDifference = nextPayment.difference(now).inDays;
      return daysDifference <= 7 && daysDifference >= 0;
    }).toList();

    upcoming.sort((a, b) => a.nextPaymentDate.compareTo(b.nextPaymentDate));
    return upcoming;
  }

  Map<SubscriptionFrequency, List<Subscription>> get subscriptionsByFrequency {
    final Map<SubscriptionFrequency, List<Subscription>> grouped = {};

    for (final subscription in activeSubscriptions) {
      if (grouped[subscription.frequency] == null) {
        grouped[subscription.frequency] = [];
      }
      grouped[subscription.frequency]!.add(subscription);
    }

    return grouped;
  }

  Future<void> toggleSubscriptionStatus(String id) async {
    final subscription = subscriptions.firstWhere((s) => s.id == id);
    final newStatus = subscription.status == SubscriptionStatus.active
        ? SubscriptionStatus.paused
        : SubscriptionStatus.active;

    final updatedSubscription = subscription.copyWith(status: newStatus);
    await updateItem(updatedSubscription);
  }

  Future<void> deleteSubscription(String id) async {
    await deleteItem(id);
  }

  Future<void> clearAllSubscriptions() async {
    final allSubscriptions = List<Subscription>.from(items);
    for (var sub in allSubscriptions) {
      await deleteItem(sub.id);
    }
  }
}
