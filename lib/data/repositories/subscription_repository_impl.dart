import 'package:hive/hive.dart';
import 'package:harcama_app/domain/entities/subscription.dart';
import 'package:harcama_app/domain/repositories/subscription_repository.dart';
import 'package:harcama_app/data/repositories/base_repository_impl.dart';

class SubscriptionRepositoryImpl extends BaseRepositoryImpl<Subscription> implements SubscriptionRepository {
  SubscriptionRepositoryImpl(Box<Subscription> box) : super(box);

  @override
  Future<List<Subscription>> getSubscriptionsByStatus(SubscriptionStatus status) async {
    final allSubscriptions = await getAll();
    return allSubscriptions.where((subscription) => subscription.status == status).toList();
  }

  @override
  Future<List<Subscription>> getActiveSubscriptions() async {
    return await getSubscriptionsByStatus(SubscriptionStatus.active);
  }

  @override
  Future<List<Subscription>> getUpcomingSubscriptions(DateTime date) async {
    final activeSubscriptions = await getActiveSubscriptions();
    return activeSubscriptions.where((subscription) {
      final nextPayment = subscription.nextPaymentDate;
      return nextPayment.isAfter(DateTime.now()) && 
             nextPayment.isBefore(date) || 
             nextPayment.isAtSameMomentAs(date);
    }).toList();
  }

  @override
  Future<void> updateSubscriptionStatus(String subscriptionId, SubscriptionStatus status) async {
    final subscription = await getById(subscriptionId);
    if (subscription != null) {
      final updatedSubscription = subscription.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      await update(updatedSubscription);
    }
  }
}