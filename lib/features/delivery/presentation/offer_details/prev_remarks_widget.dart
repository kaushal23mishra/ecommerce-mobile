import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_previous_remarks_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';

class PrevRemarksWidget extends SalesdocketConsumerWidget {
  const PrevRemarksWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remarks =
        ref.watch(deliveryLeadRequestProvider)?.previousQuotationRemarks ?? [];
    
    return SalesdocketPreviousRemarksWidget(remarks: remarks);
  }
}
