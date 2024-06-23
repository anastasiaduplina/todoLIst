import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeState extends _$ThemeState {
  @override
  bool build() {
    return false;
  }

  void changeTheme() {
    state = !state;
  }
}
