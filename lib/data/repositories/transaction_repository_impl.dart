import 'package:send_money_app_test/data/data_sources/transaction_remote_datasource.dart';
import 'package:send_money_app_test/data/models/transaction_model.dart';
import 'package:send_money_app_test/domain/entities/transaction.dart';
import 'package:send_money_app_test/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Transaction>> getTransactions() async {
    final List<TransactionModel> transactionModels =
        await remoteDataSource.getTransactions();

    List<Transaction> transactions = transactionModels
        .map((model) => Transaction(
              id: model.id,
              body: model.body,
            ))
        .toList();

    return transactions;
  }

  @override
  Future<void> postTransaction(Transaction transaction) async {
    final transactionModel = TransactionModel(
      id: transaction.id,
      body: transaction.body,
    );

    return remoteDataSource.postTransaction(transactionModel);
  }
}
