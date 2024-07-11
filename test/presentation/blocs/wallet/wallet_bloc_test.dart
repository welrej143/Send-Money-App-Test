import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:send_money_app_test/presentation/blocs/wallet/wallet_bloc.dart';

void main() {
  late WalletBloc walletBloc;

  setUp(() {
    walletBloc = WalletBloc();
  });

  tearDown(() {
    walletBloc.close();
  });

  group('WalletBloc', () {
    blocTest<WalletBloc, WalletState>(
      'emits [WalletBalanceVisible] when ToggleBalanceVisibility is added',
      build: () => walletBloc,
      act: (bloc) => bloc.add(ToggleBalanceVisibility()),
      expect: () {
        return [
          WalletBalanceVisible(),
        ];
      },
    );

    blocTest<WalletBloc, WalletState>(
      'emits [WalletBalanceHidden] when ToggleBalanceVisibility is added and state is not WalletBalanceVisible',
      build: () => walletBloc,
      act: (bloc) async {
        bloc.emit(WalletBalanceVisible());
        bloc.add(ToggleBalanceVisibility());
      },
      expect: () {
        return [
          WalletBalanceVisible(),
          WalletBalanceHidden(),
        ];
      },
    );
  });
}
