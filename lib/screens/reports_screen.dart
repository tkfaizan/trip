import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:csv/csv.dart';
import '../providers/app_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final balances = p.memberBalances;

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Trip Financial Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    _row('Total Members', '\${p.members.length}'),
                    _row('Total Paid', '₹\${p.totalCollected.toStringAsFixed(0)}'),
                    _row('Total Expenses', '₹\${p.totalExpenses.toStringAsFixed(0)}'),
                    _row('Remaining', '₹\${p.remaining.toStringAsFixed(0)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Member-wise Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Member')),
                          DataColumn(label: Text('Paid')),
                          DataColumn(label: Text('Share')),
                          DataColumn(label: Text('Balance')),
                        ],
                        rows: balances.map((b) => DataRow(cells: [
                          DataCell(Text(b.member.name)),
                          DataCell(Text('₹\${b.paid.toStringAsFixed(0)}')),
                          DataCell(Text('₹\${b.share.toStringAsFixed(0)}')),
                          DataCell(Text('\${b.balance >= 0 ? '+' : ''}₹\${b.balance.toStringAsFixed(0)}', style: TextStyle(color: b.balance > 0 ? Colors.green : b.balance < 0 ? Colors.red : null, fontWeight: FontWeight.w500))),
                        ])).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final rows = [
                        ['Member', 'Paid', 'Share', 'Balance'],
                        ...balances.map((b) => [b.member.name, b.paid.toStringAsFixed(0), b.share.toStringAsFixed(0), b.balance.toStringAsFixed(0)]),
                      ];
                      final csv = const ListToCsvConverter().convert(rows);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV ready: \${csv.length} chars')));
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Export CSV'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ]),
    );
  }
}
