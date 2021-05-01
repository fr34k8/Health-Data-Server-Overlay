import 'package:hds_overlay/utils/colors.dart';
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 1)
class Settings extends HiveObject {
  static final defaultPort = 3476;
  static final defaultOverlayBackgroundColor = AppColors.chromaGreen.value;
  static final defaultDarkMode = false;

  @HiveField(0)
  int port = defaultPort;

  @HiveField(1)
  int overlayBackgroundColor = defaultOverlayBackgroundColor;

  @HiveField(2)
  bool darkMode = defaultDarkMode;

  @HiveField(3)
  double? _overlayWidth;

  // This should prevent crashes when users update since the old objects will have null
  double get overlayWidth {
    return _overlayWidth ?? 1280;
  }

  set overlayWidth(double value) {
    _overlayWidth = value;
  }

  @HiveField(4)
  double? _overlayHeight;

  double get overlayHeight {
    return _overlayHeight ?? 720;
  }

  set overlayHeight(double value) {
    _overlayHeight = value;
  }
}