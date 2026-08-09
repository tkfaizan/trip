import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String _category = 'Lunch';
  int? _paidBy;
  final Set<String> _participants = {};

  void _showExpenseDialog({Expense? expense}) {
    final p = context.read<AppProvider>();
    final members = p.members;
    if (members.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add members first')));
      return;
    }
    if (expense != null) {
      _descCtrl.text = expense.description ?? '';
      _amountCtrl.text = expense.amount.toStringAsFixed(0);
      _category = expense.category;
      _paidBy = expense.paidBy;
      _participants.clear();
      _participants.addAll(expense.participants);
    } else {
      _descCtrl.clear(); _amountCtrl.clear(); _category = 'Lunch'; _paidBy = members.first.id; _participants.clear();
      _participants.addAll(members.map((m) => m.id.toString()));
    }
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (ctx, setDState) {
        return AlertDialog(
          title: Text(expense == null ? 'Add Expense' : 'Edit Expense'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButtonFormField<String>(
                value: _category,
                items: ['Breakfast','Lunch','Dinner','Travel','Hotel','Snacks','Other'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setDState(() => _category = v!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: _amountCtrl, decoration: const InputDecoration(labelText: 'Amount (₹)'), keyboardType: TextInputType.number),
              DropdownButtonFormField<int>(
                value: _paidBy ?? members.first.id,
                items: members.map((m) => DropdownMenuItem(value: m.id, child: Text(m.name))).toList(),
                onChanged: (v) => setDState(() => _paidBy = v),
                decoration: const InputDecoration(labelText: 'Paid By'),
              ),
              const SizedBox(height: 8),
              const Text('Participants', style: TextStyle(fontWeight: FontWeight.w500)),
              ...members.map((m) => CheckboxListTile(
                dense: true,
                title: Text(m.name),
                value: _participants.contains(m.id.toString()),
                onChanged: (v) => setDState(() {
                  if (v == true) _participants.add(m.id.toString());
                  else _participants.remove(m.id.toString());
                }),
              )),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final amt = double.tryParse(_amountCtrl.text) ?? 0;
                if (amt <= 0 || _participants.isEmpty) return;
                if (expense != null) {
                  expense.category = _category;
                  expense.description = _descCtrl.text.trim();
                  expense.amount = amt;
                  expense.paidBy = _paidBy ?? members.first.id;
                  expense.participants = _participants.toList();
                  p.updateExpense(expense);
                } else {
                  p.addExpense(Expense(
                    id: DateTime.now().millisecondsSinceEpoch,
                    tripId: p.currentTrip!.id,
                    dayNumber: p.currentDay,
                    category: _category,
                    description: _descCtrl.text.trim(),
                    amount: amt,
                    paidBy: _paidBy ?? members.first.id,
                    participants: _participants.toList(),
                  ));
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final trip = p.currentTrip!;
    final dayExpenses = p.dayExpenses;

    return Scaffold(
      appBar: AppBar(title: const Text('Expenses'), actions: [
        IconButton(icon: const Icon(Icons.add), onPressed: () => _showExpenseDialog()),
      ]),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: trip.numberOfDays,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemBuilder: (_, i) {
                final day = i + 1;
                final selected = p.currentDay == day;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('Day \$day'),
                    selected: selected,
                    onSelected: (_) => p.setDay(day),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: dayExpenses.isEmpty
                ? const Center(child: Text('No expenses for this day'))
                : ListView.builder(
                    itemCount: dayExpenses.length,
                    itemBuilder: (_, i) {
                      final e = dayExpenses[i];
                      final payer = p.members.firstWhere((m) => m.id == e.paidBy, orElse: () => Member(id: 0, tripId: 0, name: 'Unknown'));
                      return Card(
                        child: ListTile(
                          title: Text('\${e.category}\${e.description != null && e.description!.isNotEmpty ? ' — \${e.description}' : ''}'),
                          subtitle: Text('Paid by \${payer.name} · \${e.participants.length} people'),
                          trailing: Text('₹\${e.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w500)),
                          onTap: () => _showExpenseDialog(expense: e),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
