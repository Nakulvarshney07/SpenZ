import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Data/Expense_data.dart';
import '../ML/ml_service.dart';

class MLInsightsScreen extends StatefulWidget {
  const MLInsightsScreen({super.key});

  @override
  State<MLInsightsScreen> createState() => _MLInsightsScreenState();
}

class _MLInsightsScreenState extends State<MLInsightsScreen> {
  bool _loading = false;
  Map<String, dynamic>? _data;

  Future<void> _loadData() async {
    setState(() => _loading = true);

    final expenseData = Provider.of<ExpenseData>(context, listen: false);
    final transactions = expenseData.getExpenseList();
    final balance = expenseData.getBalance();

    final result = await MLService.getAllInsights(transactions, balance);
    
    setState(() {
      _data = result;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Insights'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _data == null || _data!['success'] != true
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 50, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_data?['error'] ?? 'Failed to load insights'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildExpenseCard(_data!['expenses']),
                      const SizedBox(height: 16),
                      _buildStockCard(_data!['stocks']),
                    ],
                  ),
                ),
    );
  }

  Widget _buildExpenseCard(Map<String, dynamic> expenses) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Expense Analysis',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildRow('Total Expenses', '₹${(expenses['total'] as num?)?.toStringAsFixed(2) ?? '0.00'}'),
            _buildRow('Average', '₹${(expenses['avg'] as num?)?.toStringAsFixed(2) ?? '0.00'}'),
            _buildRow('Transactions', '${expenses['count'] ?? 0}'),
            if (expenses['potential_savings'] != null)
              _buildRow('Potential Savings', '₹${(expenses['potential_savings'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                  color: Colors.green),
            if (expenses['recommendations'] != null) ...[
              const SizedBox(height: 16),
              const Text('Recommendations', style: TextStyle(fontWeight: FontWeight.bold)),
              ...(expenses['recommendations'] as List).map((rec) => Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(rec)),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStockCard(Map<String, dynamic> stocks) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Stock Recommendations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildRow('Risk Profile', stocks['risk'] ?? 'moderate'),
            _buildRow('Recommended Investment', '₹${(stocks['investment'] as num?)?.toStringAsFixed(2) ?? '0.00'}'),
            const SizedBox(height: 16),
            if (stocks['stocks'] != null)
              ...(stocks['stocks'] as List).map((stock) => ListTile(
                    leading: const Icon(Icons.trending_up, color: Colors.green),
                    title: Text(stock['name'] ?? ''),
                    subtitle: Text('${stock['symbol'] ?? ''} • ${stock['risk'] ?? ''}'),
                    trailing: Text(stock['return'] ?? '', style: const TextStyle(color: Colors.green)),
                  )),
            if (stocks['advice'] != null) ...[
              const SizedBox(height: 16),
              const Text('Advice', style: TextStyle(fontWeight: FontWeight.bold)),
              ...(stocks['advice'] as List).map((advice) => Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(advice)),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color ?? Colors.black)),
        ],
      ),
    );
  }
}

