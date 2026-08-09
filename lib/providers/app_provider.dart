import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  String? currentUser;
  Trip? currentTrip;
  int currentDay = 1;

  AppProvider() {
    _storage.seedDefaultUser();
  }

  bool login(String username, String password) {
    final user = _storage.getUser(username, password);
    if (user != null) { currentUser = username; notifyListeners(); return true; }
    return false;
  }

  void logout() { currentUser = null; currentTrip = null; notifyListeners(); }

  List<Trip> get trips => currentUser != null ? _storage.getTripsForUser(currentUser!) : [];
  void addTrip(Trip trip) { _storage.addTrip(trip); notifyListeners(); }
  void deleteTrip(int id) { _storage.deleteTrip(id); notifyListeners(); }

  void setCurrentTrip(Trip trip) { currentTrip = trip; currentDay = 1; notifyListeners(); }

  List<Member> get members => currentTrip != null ? _storage.getMembersForTrip(currentTrip!.id) : [];
  void addMember(Member member) { _storage.addMember(member); notifyListeners(); }
  void updateMember(Member member) { _storage.updateMember(member); notifyListeners(); }
  void deleteMember(int id) { _storage.deleteMember(id); notifyListeners(); }

  List<Expense> get expenses => currentTrip != null ? _storage.getExpensesForTrip(currentTrip!.id) : [];
  List<Expense> get dayExpenses => currentTrip != null ? _storage.getExpensesForDay(currentTrip!.id, currentDay) : [];
  void addExpense(Expense expense) { _storage.addExpense(expense); notifyListeners(); }
  void updateExpense(Expense expense) { _storage.updateExpense(expense); notifyListeners(); }
  void deleteExpense(int id) { _storage.deleteExpense(id); notifyListeners(); }

  void setDay(int day) { currentDay = day; notifyListeners(); }

  double get totalCollected => members.fold(0, (sum, m) => sum + m.totalPaid);
  double get totalExpenses => expenses.fold(0, (sum, e) => sum + e.amount);
  double get remaining => totalCollected - totalExpenses;

  double dayTotal(int day) => expenses.where((e) => e.dayNumber == day).fold(0, (s, e) => s + e.amount);

  double memberShare(int memberId) {
    double share = 0;
    for (final e in expenses) {
      if (e.participants.contains(memberId.toString())) {
        share += e.amount / e.participants.length;
      }
    }
    return share;
  }

  List<MemberBalance> get memberBalances {
    return members.map((m) {
      final share = memberShare(m.id);
      return MemberBalance(member: m, paid: m.totalPaid, share: share, balance: m.totalPaid - share);
    }).toList();
  }

  List<SettlementItem> get settlements {
    final balances = memberBalances.map((b) => {
      'name': b.member.name,
      'balance': b.balance,
    }).toList();

    final creditors = balances.where((b) => (b['balance'] as double) > 0).toList()
      ..sort((a, b) => (b['balance'] as double).compareTo(a['balance'] as double));
    final debtors = balances.where((b) => (b['balance'] as double) < 0).toList()
      ..sort((a, b) => (a['balance'] as double).compareTo(b['balance'] as double));

    final List<SettlementItem> result = [];
    int i = 0, j = 0;
    while (i < debtors.length && j < creditors.length) {
      final amt = (debtors[i]['balance'] as double).abs() < (creditors[j]['balance'] as double)
          ? (debtors[i]['balance'] as double).abs()
          : (creditors[j]['balance'] as double);
      if (amt > 0.5) {
        result.add(SettlementItem(
          from: debtors[i]['name'] as String,
          to: creditors[j]['name'] as String,
          amount: amt,
        ));
      }
      debtors[i]['balance'] = (debtors[i]['balance'] as double) + amt;
      creditors[j]['balance'] = (creditors[j]['balance'] as double) - amt;
      if ((debtors[i]['balance'] as double).abs() < 0.5) i++;
      if ((creditors[j]['balance'] as double).abs() < 0.5) j++;
    }
    return result;
  }

  void clearAllData() { _storage.clearAll(); currentTrip = null; notifyListeners(); }
}
