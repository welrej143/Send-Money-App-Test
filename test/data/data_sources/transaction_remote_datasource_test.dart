import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money_app_test/data/data_sources/transaction_remote_datasource.dart';
import 'package:send_money_app_test/data/models/transaction_model.dart';
import 'package:send_money_app_test/utils/constants.dart';

import 'transaction_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('TransactionRemoteDataSourceImpl', () {
    late TransactionRemoteDataSourceImpl dataSource;
    late MockClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockClient();
      dataSource = TransactionRemoteDataSourceImpl(client: mockHttpClient);
    });

    group('getTransactions', () {
      test(
          'returns a list of TransactionModel if the http call completes successfully',
          () async {
        final mockTransactions = [
          {'id': '1', 'body': 'Transaction 1'},
          {'id': '2', 'body': 'Transaction 2'},
        ];
        final responseJson = json.encode(mockTransactions);

        when(mockHttpClient.get(Uri.parse(ApiConstants.transactionsEndpoint)))
            .thenAnswer((_) async => http.Response(responseJson, 200));

        final result = await dataSource.getTransactions();

        expect(result.length, equals(mockTransactions.length));
        expect(result[0].id, equals(mockTransactions[0]['id']));
        expect(result[1].body, equals(mockTransactions[1]['body']));
      });

      test('throws an exception if the http call completes with an error',
          () async {
        when(mockHttpClient.get(Uri.parse(ApiConstants.transactionsEndpoint)))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        expect(() => dataSource.getTransactions(), throwsException);
      });
    });

    group('postTransaction', () {
      test('sends a transaction model to the API', () async {
        final transaction = TransactionModel(id: '1', body: 'New Transaction');
        final responseJson =
            json.encode({'id': '1', 'body': 'New Transaction'});

        when(mockHttpClient.post(
          Uri.parse(ApiConstants.transactionsEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(transaction.toJson()),
        )).thenAnswer((_) async => http.Response(responseJson, 201));

        await dataSource.postTransaction(transaction);

        verify(mockHttpClient.post(
          Uri.parse(ApiConstants.transactionsEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(transaction.toJson()),
        ));
      });

      test('throws an exception if the http call completes with an error',
          () async {
        final transaction = TransactionModel(id: '1', body: 'New Transaction');

        when(mockHttpClient.post(
          Uri.parse(ApiConstants.transactionsEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(transaction.toJson()),
        )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

        expect(() => dataSource.postTransaction(transaction), throwsException);
      });
    });
  });
}
