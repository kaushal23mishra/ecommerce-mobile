import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/home/view_model/ho_selection_providers.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class OrganizationTreeWidget extends SalesdocketConsumerStatefulWidget {
  final OrganizationNodeEntity rootNode;

  const OrganizationTreeWidget({
    super.key,
    required this.rootNode,
  });

  @override
  ConsumerState<SalesdocketConsumerStatefulWidget> createState() =>
      _OrganizationTreeWidgetState();
}

class _OrganizationTreeWidgetState
    extends SalesdocketConsumerState<OrganizationTreeWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildTreeNode(context, widget.rootNode, 0),
      ],
    );
  }

  Widget _buildTreeNode(
    BuildContext context,
    OrganizationNodeEntity node,
    int depth,
  ) {
    final expandedNodes = ref.watch(expandedNodesProvider);
    final selectedDesignationId = ref.watch(selectedDesignationIdProvider);
    final isExpanded = expandedNodes.contains(node.id);
    final isSelected = selectedDesignationId == node.id;
    final hasChildren = node.hasChildren;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            // Update selection
            ref.read(selectedDesignationIdProvider.notifier).state = node.id;
            ref.read(selectedDesignationNameProvider.notifier).state =
                node.name;
            ref.read(selectedOutletIdProvider.notifier).state = null;
            ref.read(selectedOutletNameProvider.notifier).state = null;

            // Toggle expansion if has children
            if (hasChildren) {
              final updatedSet = {...expandedNodes};
              if (isExpanded) {
                updatedSet.remove(node.id);
              } else {
                updatedSet.add(node.id);
              }
              ref.read(expandedNodesProvider.notifier).state = updatedSet;
            }
          },
          child: Container(
            color: isSelected
                ? appColors.primary.withOpacity(0.1)
                : Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: 4.w + (depth * 4.w),
              vertical: 1.5.h,
            ),
            child: Row(
              children: [
                if (hasChildren) ...[
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: 5.w,
                    color: appColors.grayDark,
                  ),
                  horizontalSpacing(1.w),
                ] else ...[
                  SizedBox(width: 6.w),
                ],
                Icon(
                  Icons.people,
                  size: 5.w,
                  color: isSelected
                      ? appColors.primary
                      : appColors.grayDark,
                ),
                horizontalSpacing(2.w),
                Expanded(
                  child: Text(
                    node.name.toCamelCase,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected
                              ? appColors.primary
                              : appColors.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (node.outletsCount != null && node.outletsCount! > 0) ...[
                  horizontalSpacing(1.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.3.h,
                    ),
                    decoration: BoxDecoration(
                      color: appColors.primary,
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: Text(
                      '${node.outletsCount}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,

                          ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (isExpanded && hasChildren)
          ...node.children!
              .map((child) => _buildTreeNode(context, child, depth + 1)),
      ],
    );
  }
}
