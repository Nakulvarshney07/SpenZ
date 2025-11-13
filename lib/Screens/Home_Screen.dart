import 'package:flutter/material.dart';
import 'package:spendz/Screens/Balance_Overview.dart';
import '../Data/Expense_data.dart';
import 'Settings.dart';
import 'package:provider/provider.dart';
import 'package:spendz/utils.dart';
import 'package:spendz/Charts/bar_chart.dart' as chart; // alias import
import 'ML_Insights_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 0;

  @override
  void initState() {
    super.initState();
    // schedule prepareData after first frame so notifyListeners() won't run during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ExpenseData>(context, listen: false);
      provider.prepareData();
      setState(() {
        balance = provider.getBalance();
      });
    });
  }

  IconData getCategoryIcon(String name) {
    String lowercaseName = name.toLowerCase();
    if (lowercaseName.contains('food') ||
        lowercaseName.contains('juice') ||
        lowercaseName.contains('grocery')) {
      return Icons.fastfood; // Use the food icon
    } else if (lowercaseName.contains('education') ||
        lowercaseName.contains('school') ||
        lowercaseName.contains('college') ||
        lowercaseName.contains('xerox') ||
        lowercaseName.contains('pen')) {
      return Icons.school_outlined; // Use the education icon
    } else if (lowercaseName.contains('netflix') ||
        lowercaseName.contains('spotify') ||
        lowercaseName.contains('prime') ||
        lowercaseName.contains('hotstar') ||
        lowercaseName.contains('ott')) {
      return Icons.subscriptions_rounded; // Use the subscriptions icon
    } else {
      return Icons.category_outlined; // Use a default icon for other categories
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Consumer<ExpenseData>(
      builder: (context, value, child) {
        // Use the Consumer-provided value directly (listens to changes)
        balance = value.getBalance();
        final expenseList = value.getExpenseList();

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                forceElevated: true,
                leading: IconButton(
                  icon: const Icon(Icons.settings),
                  iconSize: 30,
                  onPressed: () {
                    // Open the Settings dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Settings();
                      },
                    );
                  },
                ),
                flexibleSpace: const FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("SpenZ"),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.psychology),
                    iconSize: 30,
                    tooltip: 'AI Insights',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MLInsightsScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle_rounded),
                    iconSize: 30,
                    onPressed: () {
                      setState(() {});
                    },
                  )
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          16 * fem, 10 * fem, 16 * fem, 16 * fem),
                      width: double.infinity,
                      height: 110 * fem,
                      decoration: BoxDecoration(
                        color: const Color(0xfff2f2f7),
                        borderRadius: BorderRadius.circular(13 * fem),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 343 * fem,
                                height: 110 * fem,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(12 * fem),
                                    color: const Color(0x99007aff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16 * fem,
                            top: 45 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 140 * fem,
                                height: 42 * fem,
                                child: Text(
                                  '$balance',
                                  style: SafeGoogleFont(
                                    'Inter',
                                    fontSize: 34 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2125 * ffem / fem,
                                    letterSpacing: -0.3700000048 * fem,
                                    color: const Color(0xffffffff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16 * fem,
                            top: 24 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 83 * fem,
                                height: 20 * fem,
                                child: Text(
                                  'My Balance',
                                  style: SafeGoogleFont(
                                    'Inter',
                                    fontSize: 15 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.3333333333 * ffem / fem,
                                    color: const Color(0xffffffff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 300 * fem,
                            top: 30 * fem,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BalanceOverview(),
                                    ),
);
                              },
                              child: Align(
                                child: SizedBox(
                                  width: 40 * fem,
                                  height: 50 * fem,
                                  child: Center(
                                    child: Icon(
                                      Icons.navigate_next_rounded,
                                      size: 35 * fem,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ----------------- CHART: show expenses only -----------------
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Builder(builder: (context) {
                        // show expenses only on chart
                        final weekValues = value.weeklyAmounts(typeFilter: 'expense');
                        final maxY = value.computeChartMaxY(weekValues);
                        return Container(
                          height: 220,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                          ),
                          child: chart.myBarGraph(
                            maxY,
                            weekValues[0],
                            weekValues[1],
                            weekValues[2],
                            weekValues[3],
                            weekValues[4],
                            weekValues[5],
                            weekValues[6],
                          ),
                        );
                      }),
                    ),
                    // -------------------------------------------------------------------

                    Text(
                      'Transaction History',
                      style: SafeGoogleFont(
                        'Play',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: expenseList.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final tx = expenseList[index];
                          final isIncome = tx.type == 'income';

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isIncome ? Colors.green : Colors.blue,
                              child: Icon(
                                getCategoryIcon(tx.name),
                                size: 30 * fem,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(tx.name),
                            subtitle: Text(
                              '${tx.dateTime.hour.toString().padLeft(2, '0')}:${tx.dateTime.minute.toString().padLeft(2, '0')} / '
                              '${tx.dateTime.day}.${tx.dateTime.month}.${tx.dateTime.year.toString().substring(2)}\n'
                              '${isIncome ? 'Credited' : 'Debited'}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Text(
                              '${isIncome ? '+' : '-'}₹${tx.amount}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isIncome ? Colors.green : Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
