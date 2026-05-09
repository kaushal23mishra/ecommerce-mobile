import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/entity/media.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_image_container.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketImagesWidget extends SalesdocketStatelessWidget {
  final List<Media> images;
  final Function(int, XFile?)? onImageChanged;

  const SalesdocketImagesWidget({
    super.key,
    this.images = const [],
    this.onImageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 12,
      mainAxisSpacing: 2.w,
      crossAxisSpacing: 2.w,
      children: List.generate(images.length, (index) {
        final media = images[index];
        return StaggeredGridTile.count(
          crossAxisCellCount: media.gridSize,
          mainAxisCellCount: 6,
          child: SalesdocketImageContainer(
            title: media.name ?? "",
            path: media.path,
            height:
                media.gridSize == 12
                    ? 46.w
                    : (92.w - ((12 / media.gridSize) - 1) * 2.w) /
                        ((12 / media.gridSize)),
            onImageChanged: (imageFile) {
              if (onImageChanged != null) {
                onImageChanged!(index, imageFile);
              }
            },
          ),
        );
      }),
    );
  }
}
