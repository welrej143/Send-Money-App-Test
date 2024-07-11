import 'package:flutter/material.dart';
import 'package:send_money_app_test/presentation/pages/send_money_page.dart';
import 'package:send_money_app_test/presentation/pages/transactions_page.dart';
import 'package:send_money_app_test/presentation/pages/wallet_page.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const WalletPage());
      case '/send_money':
        return MaterialPageRoute(builder: (_) => const SendMoneyPage());
      case '/transactions':
        return MaterialPageRoute(builder: (_) => const TransactionsPage());
      default:
        return MaterialPageRoute(builder: (_) => const WalletPage());
    }
  }
}
