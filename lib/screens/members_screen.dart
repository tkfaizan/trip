import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _paidCtrl = TextEditingController(text: '0');

  void _showMemberDialog({Member? member}) {
    if (member != null) {
      _nameCtrl.text = member.name;
      _phoneCtrl.text = member.phone ?? '';
      _paidCtrl.text = member.totalPaid.toStringAsFixed(0);
    } else {
      _nameCtrl.clear(); _phoneCtrl.clear(); _paidCtrl.text = '0';
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(member == null ? 'Add Member' : 'Edit Member'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Mobile (optional)')),
          TextField(controller: _paidCtrl, decoration: const InputDecoration(labelText: 'Amount Paid (₹)'), keyboardType: TextInputType.number),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final p = context.read<AppProvider>();
              final name = _nameCtrl.text.trim();
              final paid = double.tryParse(_paidCtrl.text) ?? 0;
              if (name.isEmpty) return;
              if (member != null) {
                member.name = name;
                member.phone = _phoneCtrl.text.trim();
                member.totalPaid = paid;
                p.updateMember(member);
              } else {
                p.addMember(Member(
                  id: DateTime.now().millisecondsSinceEpoch,
                  tripId: p.currentTrip!.id,
                  name: name,
                  phone: _phoneCtrl.text.trim(),
                  totalPaid: paid,
                ));
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final members = p.members;

    return Scaffold(
      appBar: AppBar(title: const Text('Members'), actions: [
        IconButton(icon: const Icon(Icons.add), onPressed: () => _showMemberDialog()),
      ]),
      body: members.isEmpty
          ? const Center(child: Text('No members yet'))
          : ListView.builder(
              itemCount: members.length,
              itemBuilder: (_, i) {
                final m = members[i];
                final share = p.memberShare(m.id);
                final balance = m.totalPaid - share;
                return Card(
                  child: ListTile(
                    title: Text(m.name),
                    subtitle: Text('Paid: ₹\${m.totalPaid.toStringAsFixed(0)} · Share: ₹\${share.toStringAsFixed(0)}'),
                    trailing: Chip(
                      label: Text('\${balance >= 0 ? '+' : ''}₹\${balance.toStringAsFixed(0)}'),
                      backgroundColor: balance > 0 ? Colors.green.shade100 : balance < 0 ? Colors.red.shade100 : Colors.grey.shade200,
                    ),
                    onTap: () => _showMemberDialog(member: m),
                  ),
                );
              },
            ),
    );
  }
}
