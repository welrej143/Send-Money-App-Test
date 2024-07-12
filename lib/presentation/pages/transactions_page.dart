import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:send_money_app_test/data/data_sources/transaction_remote_datasource.dart';
import 'package:send_money_app_test/data/repositories/transaction_repository_impl.dart';
import 'package:send_money_app_test/domain/use_cases/get_transactions.dart';
import 'package:send_money_app_test/presentation/blocs/transactions/transactions_bloc.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final httpClient = http.Client();
    final remoteDataSource =
        TransactionRemoteDataSourceImpl(client: httpClient);
    final repository =
        TransactionRepositoryImpl(remoteDataSource: remoteDataSource);
    final getTransactions = GetTransactions(repository);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: BlocProvider(
        create: (_) => TransactionsBloc(getTransactions: getTransactions)
          ..add(LoadTransactions()),
        child: const TransactionsView(),
      ),
    );
  }
}

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        if (state is TransactionsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TransactionsLoaded) {
          return ListView.builder(
            itemCount: state.transactions.length,
            itemBuilder: (context, index) {
              final transaction = state.transactions[index];
              return ListTile(
                key: const Key('transactions'),
                title: Text('Transaction ${transaction.id}'),
                subtitle: Text('Amount: ${transaction.body}'),
              );
            },
          );
        } else {
          return const Center(child: Text('Failed to load transactions'));
        }
      },
    );
  }
}
