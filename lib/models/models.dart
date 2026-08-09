import 'package:hive/hive.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String username;
  @HiveField(2)
  String password;
  @HiveField(3)
  bool rememberMe;

  User({required this.id, required this.username, required this.password, this.rememberMe = false});
}

@HiveType(typeId: 1)
class Trip extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String userId;
  @HiveField(2)
  String name;
  @HiveField(3)
  String startDate;
  @HiveField(4)
  int numberOfDays;

  Trip({required this.id, required this.userId, required this.name, required this.startDate, this.numberOfDays = 3});
}

@HiveType(typeId: 2)
class Member extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  int tripId;
  @HiveField(2)
  String name;
  @HiveField(3)
  String? phone;
  @HiveField(4)
  double totalPaid;

  Member({required this.id, required this.tripId, required this.name, this.phone, this.totalPaid = 0});
}

@HiveType(typeId: 3)
class Expense extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  int tripId;
  @HiveField(2)
  int dayNumber;
  @HiveField(3)
  String category;
  @HiveField(4)
  String? description;
  @HiveField(5)
  double amount;
  @HiveField(6)
  int paidBy;
  @HiveField(7)
  List<String> participants;
  @HiveField(8)
  String? date;

  Expense({
    required this.id, required this.tripId, required this.dayNumber,
    required this.category, this.description, required this.amount,
    required this.paidBy, required this.participants, this.date,
  });
}

@HiveType(typeId: 4)
class Payment extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  int tripId;
  @HiveField(2)
  int memberId;
  @HiveField(3)
  double amount;
  @HiveField(4)
  String? date;
  @HiveField(5)
  String? paymentMethod;
  @HiveField(6)
  String? notes;

  Payment({required this.id, required this.tripId, required this.memberId, required this.amount, this.date, this.paymentMethod, this.notes});
}

class MemberBalance {
  final Member member;
  final double paid;
  final double share;
  final double balance;
  MemberBalance({required this.member, required this.paid, required this.share, required this.balance});
}

class SettlementItem {
  final String from;
  final String to;
  final double amount;
  SettlementItem({required this.from, required this.to, required this.amount});
}
