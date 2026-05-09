import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/schemes/view_model/schemes_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ActionWidget extends SalesdocketConsumerStatefulWidget {
  const ActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ActionState();
}

class _ActionState extends SalesdocketConsumerState<ActionWidget>
    with ProductEvents {
  @override
  Widget build(BuildContext context) {
    return SalesdocketActionWidget(
      positiveText: LocaleKeys.lblAddSchemes.tr(),
      onPositiveClicked: () {
        _validateAndSubmitRequest();
      },
    );
  }

  void _validateAndSubmitRequest() {
    final broker = ref.read(schemesBrokerProvider);
    if (broker != null) {
      if (_isValidBrokerDetails()) {
        _createOrUpdateBroker();
      }
    } else {
      context.router.back();
    }
  }

  bool _isValidBrokerDetails() {
    final broker = ref.read(schemesBrokerProvider);
    final errors = broker?.brokerDetailsValidationErrors() ?? [];
    if (errors.isNotEmpty) {
      ref.read(brokerFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }

  void _createOrUpdateBroker() {
    final lead = ref.read(getSchemesLeadProvider);
    final broker = ref.read(schemesBrokerProvider);
    if (broker == null) return;

    final request = broker.createBrokerageRequest(lead: lead);
    if (request.id == null) {
      createBroker(request);
    } else {
      updateBroker(brokerId: request.id, broker: request);
    }
  }

  @override
  void onBrokerCreated(Brokerage? data) {
    ref.invalidate(schemesBrokerProvider);
    ref.read(updatedBrokerProvider.notifier).update((state) => state = data);
    context.router.back();
  }

  @override
  void onBrokerUpdated(Brokerage? data) {
    ref.invalidate(schemesBrokerProvider);
    ref.read(updatedBrokerProvider.notifier).update((state) => state = data);
    context.router.back();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
