import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/features/home/view_model/nav_items_provider.dart';

class NavViewModel extends StateNotifier<MenuItem> {
  NavViewModel(List<MenuItem> menuItems) : super(menuItems.first);

  void selectMenuItem(MenuItem menuItem, BuildContext context) {
    if (menuItem.action != null) {
      menuItem.action!(context);
    }
    state = menuItem;
  }
}

final navViewModelProvider = StateNotifierProvider<NavViewModel, MenuItem>((
  ref,
) {
  final menuItems = ref.read(menuItemsProvider);
  return NavViewModel(menuItems);
});

final canPopProvider = StateProvider<bool>((ref) => false);
final isExitPopupShownProvider = StateProvider<bool>((ref) => false);
