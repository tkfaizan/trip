import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _nameCtrl = TextEditingController();
  final _daysCtrl = TextEditingController(text: '3');
  DateTime _start = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Trip')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Trip Name')),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Start Date'),
              subtitle: Text('\${_start.toLocal()}'.split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _start, firstDate: DateTime(2024), lastDate: DateTime(2030));
                if (d != null) setState(() => _start = d);
              },
            ),
            const SizedBox(height: 12),
            TextField(controller: _daysCtrl, decoration: const InputDecoration(labelText: 'Number of Days'), keyboardType: TextInputType.number),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final name = _nameCtrl.text.trim();
                  final days = int.tryParse(_daysCtrl.text) ?? 3;
                  if (name.isEmpty) return;
                  final user = context.read<AppProvider>().currentUser!;
                  final trip = Trip(
                    id: DateTime.now().millisecondsSinceEpoch,
                    userId: user,
                    name: name,
                    startDate: _start.toIso8601String().split('T')[0],
                    numberOfDays: days,
                  );
                  context.read<AppProvider>().addTrip(trip);
                  Navigator.pop(context);
                },
                child: const Text('Create Trip'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
