import 'package:riverpod/riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';

final insuranceCompaniesProvider = StateProvider<List<Insurance>>((ref) => []);
