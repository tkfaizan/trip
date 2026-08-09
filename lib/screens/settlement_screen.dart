import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class SettlementScreen extends StatelessWidget {
  const SettlementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settlements = context.watch<AppProvider>().settlements;

    return Scaffold(
      appBar: AppBar(title: const Text('Settlement')),
      body: settlements.isEmpty
          ? const Center(child: Text('Everyone is settled up!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: settlements.length,
              itemBuilder: (_, i) {
                final s = settlements[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s.from, style: const TextStyle(fontWeight: FontWeight.w500)),
                        const Icon(Icons.arrow_forward, color: Colors.grey),
                        Text(s.to, style: const TextStyle(fontWeight: FontWeight.w500)),
                        Text('₹${s.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
