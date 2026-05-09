import 'package:flutter_riverpod/flutter_riverpod.dart';

final localAmountProvider = StateProvider<double>((ref) => 1);
final tenureProvider = StateProvider<double>((ref) => 12);
final interestProvider = StateProvider<double>((ref) => 8);
