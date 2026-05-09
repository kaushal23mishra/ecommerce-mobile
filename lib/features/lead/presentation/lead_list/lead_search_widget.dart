import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/search_by.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadSearchWidget extends SalesdocketConsumerStatefulWidget {
  const LeadSearchWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeadSearchState();
}

class _LeadSearchState extends SalesdocketConsumerState<LeadSearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentSearch = ref.read(getLeadRequestProvider)?.search;
      if (currentSearch != null) {
        _searchController.text = currentSearch;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2.h,
      children: [_searchByWidget, _searchWidget, _actionWidget],
    );
  }

  Widget get _searchWidget {
    return SalesDocketInputWidget(
      controller: _searchController,
      inputType: TextInputType.text,
      label: LocaleKeys.lblKeyword.tr(),
      hint: LocaleKeys.lblKeyword.tr(),
      autoValidate: false,
      onChanged: (value) {
        ref
            .read(getLeadRequestProvider.notifier)
            .update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(search: value.trim()),
            );
      },
    );
  }

  Widget get _searchByWidget {
    final selectedSearchBy = ref.watch(
      getLeadRequestProvider.select((req) => req?.searchBy),
    );

    return SalesDocketDropDownWidget(
      text: LocaleKeys.lblSearchBy.tr(),
      itemList: searchByList.map((item) => item.value).toList(),
      itemValue: selectedSearchBy?.toCamelCase,
      imagePath: Assets.svg.arrowDown.path,
      onChanged: (selected) {
        _searchController.clear();
        ref
            .read(getLeadRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    searchBy: selected?.toLowerCase(),
                    search: null,
                  ),
            );
      },
    );
  }

  Widget get _actionWidget {
    return Row(
      spacing: 4.w,
      children: [
        Expanded(
          child: SalesDocketButtonWidget(
            text: LocaleKeys.lblClear.tr(),
            isOutlined: true,
            onPressed: () {
              _searchController.clear();
              ref
                  .read(getLeadRequestProvider.notifier)
                  .update(
                    (toUpdate) =>
                        toUpdate = toUpdate?.copyWith(
                          search: null,
                          searchBy: null,
                        ),
                  );
              _fetchLeads();
              // context.router.maybePop();
            },
          ),
        ),
        Expanded(
          child: SalesDocketButtonWidget(
            text: LocaleKeys.btnSearch.tr(),
            onPressed: () {
              final request = ref.read(getLeadRequestProvider);
              if (request?.isSearchApplied == true) {
                _fetchLeads();
              } else {
                ref
                    .read(getLeadRequestProvider.notifier)
                    .update(
                      (toUpdate) =>
                          toUpdate = toUpdate?.copyWith(
                            search: null,
                            searchBy: null,
                          ),
                    );
              }
              context.router.maybePop();
            },
          ),
        ),
      ],
    );
  }

  _fetchLeads({int page = 1}) async {
    ref.invalidate(leadsProvider);
    ref.invalidate(selectedLeadsProvider);
    ref.read(leadsProvider(page: page));
  }
}
