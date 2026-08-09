import 'package:hive/hive.dart';
import '../models/models.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Box<User> get usersBox => Hive.box<User>('users');
  Box<Trip> get tripsBox => Hive.box<Trip>('trips');
  Box<Member> get membersBox => Hive.box<Member>('members');
  Box<Expense> get expensesBox => Hive.box<Expense>('expenses');
  Box<Payment> get paymentsBox => Hive.box<Payment>('payments');

  // Users
  User? getUser(String username, String password) {
    try {
      return usersBox.values.firstWhere(
        (u) => u.username == username && u.password == password,
      );
    } catch (_) { return null; }
  }

  void addUser(User user) => usersBox.put(user.id, user);

  // Trips
  List<Trip> getTripsForUser(String userId) =>
      tripsBox.values.where((t) => t.userId == userId).toList();

  void addTrip(Trip trip) => tripsBox.put(trip.id, trip);
  void deleteTrip(int id) {
    tripsBox.delete(id);
    membersBox.values.where((m) => m.tripId == id).toList().forEach((m) => membersBox.delete(m.id));
    expensesBox.values.where((e) => e.tripId == id).toList().forEach((e) => expensesBox.delete(e.id));
    paymentsBox.values.where((p) => p.tripId == id).toList().forEach((p) => paymentsBox.delete(p.id));
  }

  // Members
  List<Member> getMembersForTrip(int tripId) =>
      membersBox.values.where((m) => m.tripId == tripId).toList();

  void addMember(Member member) => membersBox.put(member.id, member);
  void updateMember(Member member) => membersBox.put(member.id, member);
  void deleteMember(int id) => membersBox.delete(id);

  // Expenses
  List<Expense> getExpensesForTrip(int tripId) =>
      expensesBox.values.where((e) => e.tripId == tripId).toList();

  List<Expense> getExpensesForDay(int tripId, int day) =>
      expensesBox.values.where((e) => e.tripId == tripId && e.dayNumber == day).toList();

  void addExpense(Expense expense) => expensesBox.put(expense.id, expense);
  void updateExpense(Expense expense) => expensesBox.put(expense.id, expense);
  void deleteExpense(int id) => expensesBox.delete(id);

  // Payments
  List<Payment> getPaymentsForTrip(int tripId) =>
      paymentsBox.values.where((p) => p.tripId == tripId).toList();

  void addPayment(Payment payment) => paymentsBox.put(payment.id, payment);

  // Clear all
  void clearAll() {
    tripsBox.clear();
    membersBox.clear();
    expensesBox.clear();
    paymentsBox.clear();
  }

  // Seed default user
  void seedDefaultUser() {
    if (usersBox.isEmpty) {
      usersBox.put(1, User(id: 1, username: 'admin', password: 'admin'));
    }
  }
}
