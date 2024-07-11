import 'package:send_money_app_test/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions();
  Future<void> postTransaction(Transaction transaction);
}
