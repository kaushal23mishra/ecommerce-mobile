import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/features/calculator/presentation/calculator_screen.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/dashboard_screen.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/features/share/presentation/share.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

final MenuItem homeMenuItem = MenuItem(
  title: 'Home',
  icon: Assets.svg.homeNew.path,
  content: const DashboardScreen(),
);

final MenuItem labelMenuItem = MenuItem(
  title: 'Share',
  icon: Assets.svg.share.path,
  content: const Share(),
);

final MenuItem addEprMenuItem = MenuItem(shouldShowFab: true);

final MenuItem calculatorMenuItem = MenuItem(
  title: 'Calculator',
  icon: Assets.svg.calculator.path,
  content: const CalculatorScreen(),
);

final MenuItem brochureMenuItem = MenuItem(
  title: 'Brochure',
  icon: Assets.svg.brochure.path,
  content: const SalesDocketComingSoonScreen(),
);

class MenuItemsStateNotifier extends StateNotifier<List<MenuItem>> {
  MenuItemsStateNotifier()
    : super([
        homeMenuItem,
        labelMenuItem,
        addEprMenuItem,
        calculatorMenuItem,
        brochureMenuItem,
      ]);

  void setupMenuItems() {
    // Placeholder for dynamic updates in the future
    state = state;
  }
}

final menuItemsProvider =
    StateNotifierProvider<MenuItemsStateNotifier, List<MenuItem>>(
      (ref) => MenuItemsStateNotifier(),
    );
