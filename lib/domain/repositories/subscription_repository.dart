import 'package:harcama_app/domain/entities/subscription.dart';
import 'package:harcama_app/domain/repositories/base_repository.dart';

abstract class SubscriptionRepository extends BaseRepository<Subscription> {
  Future<List<Subscription>> getSubscriptionsByStatus(SubscriptionStatus status);
  Future<List<Subscription>> getActiveSubscriptions();
  Future<List<Subscription>> getUpcomingSubscriptions(DateTime date);
  Future<void> updateSubscriptionStatus(String subscriptionId, SubscriptionStatus status);
}