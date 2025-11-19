import 'package:flutter/material.dart';
import 'Data/Expense_data.dart';
import 'Screens/tabs_manager.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';


Future<void> main() async {
  // Ensure binding is initialized before calling any async native code.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open the boxes you use in the app. Adjust names if your provider expects different names.
  await Hive.openBox("expense_database");
  await Hive.openBox("transactions"); // open transactions box too (safe even if unused)

  // Optional: print to verify box keys (debug)
  print('expense_database keys: ${Hive.box('expense_database').keys.toList()}');
  print('transactions keys: ${Hive.box('transactions').keys.toList()}');

  runApp(
    ChangeNotifierProvider(
      create: (context) => ExpenseData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing App',
      home: const tabs_manager(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(useMaterial3: true),
    );
  }
}
