import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletInitial()) {
    on<ToggleBalanceVisibility>(_onToggleBalanceVisibility);
  }

  void _onToggleBalanceVisibility(
      ToggleBalanceVisibility event, Emitter<WalletState> emit) {
    if (state is WalletBalanceVisible) {
      emit(WalletBalanceHidden());
    } else {
      emit(WalletBalanceVisible());
    }
  }
}
