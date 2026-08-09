import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'members_screen.dart';
import 'expenses_screen.dart';
import 'settlement_screen.dart';
import 'reports_screen.dart';

class TripHomeScreen extends StatelessWidget {
  const TripHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final trip = p.currentTrip!;
    final members = p.members;

    return Scaffold(
      appBar: AppBar(title: Text(trip.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow('Members', '${members.length}'),
                    _infoRow('Total Collected', '₹${p.totalCollected.toStringAsFixed(0)}'),
                    _infoRow('Total Expenses', '₹${p.totalExpenses.toStringAsFixed(0)}'),
                    _infoRow('Remaining', '₹${p.remaining.toStringAsFixed(0)}', isPositive: p.remaining >= 0),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Day-wise Totals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: trip.numberOfDays,
                itemBuilder: (_, i) {
                  final day = i + 1;
                  final total = p.dayTotal(day);
                  return Card(
                    child: ListTile(
                      title: Text('Day $day'),
                      trailing: Text('₹${total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => const MembersScreen()));
          if (i == 2) Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpensesScreen()));
          if (i == 3) Navigator.push(context, MaterialPageRoute(builder: (_) => const SettlementScreen()));
          if (i == 4) Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen()));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Members'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Expenses'),
          BottomNavigationBarItem(icon: Icon(Icons.sync_alt), label: 'Settle'),
          BottomNavigationBarItem(icon: Icon(Icons.assessment), label: 'Reports'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool? isPositive}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w500, color: isPositive == null ? null : (isPositive ? Colors.green : Colors.red))),
      ]),
    );
  }
}
