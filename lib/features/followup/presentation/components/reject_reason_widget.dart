import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:salesdocket_ui_component/widget/salesdocket_check_mark_widget.dart';

import '../../../../common/constants/form_fields.dart';
import '../../view_model/followup_view_model.dart';
import 'call_status_mode.dart';

// StateNotifier to manage checkbox selections
class RejectReasonNotifier extends StateNotifier<List<bool>> {
  RejectReasonNotifier(int length) : super(List.generate(length, (_) => false));

  void toggleCheckbox(int index, bool value) {
    state = List.from(state)..[index] = value;
  }

  void reset() {
    state = List.generate(state.length, (_) => false);
  }
}

// Provider for checkbox state
final isCheckedProvider =
    StateNotifierProvider<RejectReasonNotifier, List<bool>>((ref) {
      return RejectReasonNotifier(RejectReasonType.rejectReasonList.length);
    });

class RejectReasonWidget extends SalesdocketConsumerStatefulWidget {
  const RejectReasonWidget({super.key});

  @override
  ConsumerState<RejectReasonWidget> createState() => _RejectReasonWidgetState();
}

class _RejectReasonWidgetState
    extends SalesdocketConsumerState<RejectReasonWidget> {
  final TextEditingController _otherReasonController = TextEditingController();

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reasons = RejectReasonType.rejectReasonList;
    final isCheckedList = ref.watch(isCheckedProvider);
    final followupReasonNotifier = ref.read(followupRequestProvider.notifier);
    final formErrorNotifier = ref.read(
      createFollowUpFormErrorsProvider.notifier,
    );
    final error = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.lostToCompetitionReason);
    final otherError = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.otherCompetitionReason);

    final otherIndex = reasons.indexOf(RejectReasonType.other.value);
    final isOtherChecked = otherIndex != -1 && isCheckedList[otherIndex];

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _clearSelectedReasons(ref);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          ListView.builder(
            padding: EdgeInsets.only(top: 1.h),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reasons.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SalesDocketCheckmarkIconWidget(
                        isChecked: isCheckedList[index],
                        activeColor: appColors.primary,
                        onChanged: (value) {
                          ref
                              .read(isCheckedProvider.notifier)
                              .toggleCheckbox(index, value);

                          final currentState = ref.read(followupRequestProvider);
                          final selectedReasons = List<String>.from(
                            currentState?.lostToCompetitionReason ?? [],
                          );

                          if (value) {
                            selectedReasons.add(reasons[index]);
                          } else {
                            selectedReasons.removeWhere(
                              (r) =>
                                  r == reasons[index] ||
                                  (reasons[index] ==
                                          RejectReasonType.other.value &&
                                      r.startsWith('Other:')),
                            );
                            if (reasons[index] == RejectReasonType.other.value) {
                              _otherReasonController.clear();
                            }
                          }

                          if (selectedReasons.isNotEmpty) {
                            formErrorNotifier.remove(
                              CreateFollowUpFormFields.lostToCompetitionReason,
                            );
                          }

                          followupReasonNotifier.update(
                            (current) => current?.copyWith(
                              lostToCompetitionReason:
                                  selectedReasons.isEmpty
                                      ? null
                                      : selectedReasons,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Text(
                        reasons[index],
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (isOtherChecked)
            Padding(
              padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
              child: SalesDocketInputWidget(
                maxLength: 100,
                inputType: TextInputType.text,
                label: LocaleKeys.pleaseSpecify.tr(),
                controller: _otherReasonController,
                hint: LocaleKeys.enterReason.tr(),
                errorMsg: otherError?.message,
                onChanged: (value) {
                  formErrorNotifier.remove(
                    CreateFollowUpFormFields.otherCompetitionReason,
                  );
                  final currentState = ref.read(followupRequestProvider);
                  final selectedReasons = List<String>.from(
                    currentState?.lostToCompetitionReason ?? [],
                  );
                  selectedReasons.removeWhere(
                    (r) =>
                        r == RejectReasonType.other.value ||
                        r.startsWith('Other:'),
                  );
                  selectedReasons.add(
                    value.trim().isNotEmpty
                        ? 'Other: ${value.trim()}'
                        : RejectReasonType.other.value,
                  );
                  followupReasonNotifier.update(
                    (current) => current?.copyWith(
                      lostToCompetitionReason: selectedReasons,
                    ),
                  );
                },
              ),
            ),
          if (error != null)
            Padding(
              padding: EdgeInsets.only(top: 1.h, left: 4.w),
              child: Text(
                error.message ?? "Please select at least one reason.",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: appColors.error),
              ),
            ),
        ],
        ),
      ),
    );
  }

  void _clearSelectedReasons(WidgetRef ref) {
    ref.read(isCheckedProvider.notifier).reset();
    _otherReasonController.clear();
    ref
        .read(followupRequestProvider.notifier)
        .update((current) => current?.copyWith(lostToCompetitionReason: null));
  }
}
