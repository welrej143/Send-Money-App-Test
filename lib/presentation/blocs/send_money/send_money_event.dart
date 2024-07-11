part of 'send_money_bloc.dart';

abstract class SendMoneyEvent extends Equatable {
  const SendMoneyEvent();

  @override
  List<Object> get props => [];
}

class SubmitSendMoney extends SendMoneyEvent {
  final double amount;

  const SubmitSendMoney(this.amount);

  @override
  List<Object> get props => [amount];
}
