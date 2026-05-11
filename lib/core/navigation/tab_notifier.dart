import 'package:flutter/foundation.dart';

/// Global tab index notifier used to switch [MainLayout] tabs from anywhere
/// without circular imports.
final ValueNotifier<int> appTabNotifier = ValueNotifier<int>(0);
