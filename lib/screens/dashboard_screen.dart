import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import 'create_trip_screen.dart';
import 'trip_home_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final trips = provider.trips;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), actions: [
        IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Active Trips', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8))),
                      const SizedBox(height: 4),
                      Text('\${trips.length}', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onPrimary)),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('My Trips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateTripScreen())), icon: const Icon(Icons.add), label: const Text('New Trip')),
            ]),
            const SizedBox(height: 12),
            Expanded(
              child: trips.isEmpty
                  ? const Center(child: Text('No trips yet. Create your first trip!'))
                  : ListView.builder(
                      itemCount: trips.length,
                      itemBuilder: (_, i) {
                        final t = trips[i];
                        final totalExp = provider.expenses.where((e) => e.tripId == t.id).fold<double>(0, (s, e) => s + e.amount);
                        return Card(
                          child: ListTile(
                            title: Text(t.name),
                            subtitle: Text('\${t.startDate} · \${t.numberOfDays} days · Expenses: ₹\${totalExp.toStringAsFixed(0)}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                showDialog(context: context, builder: (_) => AlertDialog(
                                  title: const Text('Delete trip?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                    TextButton(onPressed: () { provider.deleteTrip(t.id); Navigator.pop(context); }, child: const Text('Delete')),
                                  ],
                                ));
                              },
                            ),
                            onTap: () {
                              provider.setCurrentTrip(t);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const TripHomeScreen()));
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
