import 'package:send_money_app_test/domain/entities/transaction.dart';
import 'package:send_money_app_test/domain/repositories/transaction_repository.dart';

class PostTransaction {
  final TransactionRepository repository;

  PostTransaction(this.repository);

  Future<void> call(Transaction transaction) async {
    return await repository.postTransaction(transaction);
  }
}
