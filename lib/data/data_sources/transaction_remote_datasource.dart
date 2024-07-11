import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:send_money_app_test/data/models/transaction_model.dart';
import 'package:send_money_app_test/utils/constants.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<void> postTransaction(TransactionModel transaction);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final http.Client client;

  TransactionRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final response =
          await client.get(Uri.parse(ApiConstants.transactionsEndpoint));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<TransactionModel> transactions =
            jsonList.map((json) => TransactionModel.fromJson(json)).toList();
        return transactions;
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      throw Exception('Failed to load transactions');
    }
  }

  @override
  Future<void> postTransaction(TransactionModel transaction) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.transactionsEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transaction.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to post transaction');
      }
    } catch (e) {
      throw Exception('Failed to post transaction');
    }
  }
}
