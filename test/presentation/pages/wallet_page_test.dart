import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:send_money_app_test/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:send_money_app_test/presentation/pages/wallet_page.dart';

void main() {
  group('WalletPage and WalletView Widgets', () {
    testWidgets('Initial Widget Build', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: WalletPage(),
      ));

      expect(find.text('Wallet'), findsOneWidget);
      expect(find.text('******'), findsOneWidget); // Hidden balance initially
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.text('Send Money'), findsOneWidget);
      expect(find.text('View Transactions'), findsOneWidget);
    });

    testWidgets('Toggle Balance Visibility', (WidgetTester tester) async {
      final bloc = WalletBloc();

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: const WalletView(),
        ),
      ));

      expect(find.text('******'), findsOneWidget); // Hidden balance initially

      bloc.add(ToggleBalanceVisibility());
      await tester.pumpAndSettle();

      expect(find.text('500.00 PHP'), findsOneWidget); // Visible balance

      bloc.add(ToggleBalanceVisibility());
      await tester.pumpAndSettle();

      expect(find.text('******'), findsOneWidget); // Hidden balance
    });
  });
}
