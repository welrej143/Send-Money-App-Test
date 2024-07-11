import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:send_money_app_test/data/data_sources/transaction_remote_datasource.dart';
import 'package:send_money_app_test/data/repositories/transaction_repository_impl.dart';
import 'package:send_money_app_test/domain/use_cases/post_transactions.dart';
import 'package:send_money_app_test/presentation/blocs/send_money/send_money_bloc.dart';

class SendMoneyPage extends StatelessWidget {
  const SendMoneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final httpClient = http.Client();
    final remoteDataSource =
        TransactionRemoteDataSourceImpl(client: httpClient);
    final repository =
        TransactionRepositoryImpl(remoteDataSource: remoteDataSource);
    final postTransaction = PostTransaction(repository);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
      ),
      body: BlocProvider(
        create: (_) => SendMoneyBloc(postTransactions: postTransaction),
        child: SendMoneyView(),
      ),
    );
  }
}

class SendMoneyView extends StatelessWidget {
  final TextEditingController _amountController = TextEditingController();

  SendMoneyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final amount = double.parse(_amountController.text);
                  context.read<SendMoneyBloc>().add(SubmitSendMoney(amount));
                },
                child: const Text('Submit'),
              ),
              BlocListener<SendMoneyBloc, SendMoneyState>(
                listener: (context, state) {
                  if (state is SendMoneySuccess) {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => BottomSheet(
                        onClosing: () {},
                        builder: (_) => const SizedBox(
                          height: 200,
                          child: Center(child: Text('Transaction Successful')),
                        ),
                      ),
                    );
                  } else if (state is SendMoneyError) {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => BottomSheet(
                        onClosing: () {},
                        builder: (_) => const SizedBox(
                          height: 200,
                          child: Center(child: Text('Transaction Failed')),
                        ),
                      ),
                    );
                  }
                },
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
