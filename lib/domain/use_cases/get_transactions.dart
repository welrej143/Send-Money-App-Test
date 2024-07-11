import 'package:send_money_app_test/domain/entities/transaction.dart';
import 'package:send_money_app_test/domain/repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Future<List<Transaction>> call() async {
    return await repository.getTransactions();
  }
}
