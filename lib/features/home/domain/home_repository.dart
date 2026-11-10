import 'package:ronditrack_mobile/features/home/domain/home_entry.dart';

/// Defines how Home screen data is retrieved, regardless of its source.
abstract interface class HomeRepository {
  Future<List<HomeEntry>> fetchHome();
}
