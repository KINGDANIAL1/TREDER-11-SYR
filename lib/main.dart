import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart'; // دعم WebView للموبايل
import 'firebase_options.dart'; // تحميل إعدادات Firebase
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/user/dashboard_screen.dart';
import 'screens/user/deposit_screen.dart';
import 'screens/user/withdraw_screen.dart';
import 'screens/user/trading_screen.dart';
import 'screens/user/transaction_history_screen.dart';
import 'screens/user/settings_screen.dart';
import 'screens/admin/admin_panel_screen.dart';
import 'screens/admin/admin_address_management_screen.dart';
import 'providers/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // الطريقة الصحيحة لتحميل Firebase
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: CryptoTradingApp(),
    ),
  );
}

class CryptoTradingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Trading Platform',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.black87,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
          bodyMedium: TextStyle(color: Colors.white70, fontFamily: 'Roboto'),
          headlineSmall: TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[700],
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.yellowAccent, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: '/Login',
      routes: {
        '/Login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/deposit': (context) => DepositScreen(),
        '/withdraw': (context) => WithdrawScreen(),
        '/trading': (context) => TradingScreen(),
        '/transactions': (context) => TransactionHistoryScreen(),
        '/settings': (context) => SettingsScreen(),
        '/admin': (context) => AdminPanelScreen(),
        '/admin/addresses': (context) => AdminAddressManagementScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
