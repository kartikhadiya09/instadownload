import 'package:get_it/get_it.dart';
import 'package:instadownload/features/reel_finder/view_models/reel_finder_view_model.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerSingleton<ReelFinderViewModel>(ReelFinderViewModel());
}