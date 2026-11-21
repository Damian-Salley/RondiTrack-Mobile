import 'package:ronditrack_mobile/core/money.dart';

/// The version is opaque. A close request must return it exactly as received.
typedef CycleClosePreview = ({String version, String date, Cents total});
