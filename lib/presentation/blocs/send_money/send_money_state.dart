part of 'send_money_bloc.dart';

abstract class SendMoneyState extends Equatable {
  const SendMoneyState();

  @override
  List<Object> get props => [];
}

class SendMoneyInitial extends SendMoneyState {}

class SendMoneyLoading extends SendMoneyState {}

class SendMoneySuccess extends SendMoneyState {}

class SendMoneyError extends SendMoneyState {}
