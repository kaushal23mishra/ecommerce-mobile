import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/classes/salesdocket_consumer_state.dart';
import '../../../view_model/followup_view_model.dart';
import 'followup_image_wigit.dart';

class DoneDocumentWidget extends SalesdocketConsumerWidget {
  const DoneDocumentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followupImages = ref.watch(followupImagesProvider);

    return SalesdocketFollowupImageWidget(
      followupImages: followupImages,
      onIdentityImagesChanged: (data) {
        ref
            .read(followupImagesProvider.notifier)
            .update((state) => state = data);
      },
    );
  }
}
