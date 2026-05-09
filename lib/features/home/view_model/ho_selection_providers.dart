import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Selected designation ID provider - stores the currently selected designation node ID
final selectedDesignationIdProvider = StateProvider<int?>((ref) => null);

/// Selected outlet ID provider - stores the currently selected outlet ID
final selectedOutletIdProvider = StateProvider<int?>((ref) => null);

/// Expanded nodes provider - tracks which tree nodes are currently expanded
final expandedNodesProvider = StateProvider<Set<int>>((ref) => {});

/// Selected designation name provider - stores the name for display
final selectedDesignationNameProvider = StateProvider<String?>((ref) => null);

/// Selected outlet name provider - stores the name for display
final selectedOutletNameProvider = StateProvider<String?>((ref) => null);
