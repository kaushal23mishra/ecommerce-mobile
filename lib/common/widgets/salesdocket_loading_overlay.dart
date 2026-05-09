import 'package:flutter/material.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';

class SalesdocketLoadingOverlay extends SalesdocketStatelessWidget {
  final bool isLoading;
  final Color? barrierColor;

  const SalesdocketLoadingOverlay({
    super.key,
    required this.isLoading,
    this.barrierColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: ModalBarrier(
            dismissible: false,
            color: barrierColor ?? Colors.black,
          ),
        ),
        const Center(child: LoadingWidget()),
      ],
    );
  }
}

class LoadingWidget extends SalesdocketStatelessWidget {
  final double? size;

  const LoadingWidget({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(color: appColors.primary);
  }
}
