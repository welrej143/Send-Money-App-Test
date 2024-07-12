import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:send_money_app_test/data/models/transaction_model.dart';
import 'package:send_money_app_test/domain/use_cases/post_transactions.dart';

part 'send_money_event.dart';
part 'send_money_state.dart';

class SendMoneyBloc extends Bloc<SendMoneyEvent, SendMoneyState> {
  final PostTransaction postTransactions;

  SendMoneyBloc({required this.postTransactions}) : super(SendMoneyInitial()) {
    on<SubmitSendMoney>(_onSubmitSendMoney);
  }

  Future<void> _onSubmitSendMoney(
      SubmitSendMoney event, Emitter<SendMoneyState> emit) async {
    emit(SendMoneyLoading());
    try {
      final transaction = TransactionModel(body: event.amount.toString());
      await postTransactions(transaction);

      emit(SendMoneySuccess());
    } catch (_) {
      emit(SendMoneyError());
    }
  }
}
