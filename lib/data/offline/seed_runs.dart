import '../../models/run_entry.dart';

/// Sample demo rows shown when the app runs without a Supabase configuration.
///
/// The first row has `runPerson = วิ่งคนเดียว`, matching the Edit screen in
/// the design. Photos are bundled local assets, and the logo is the fallback
/// for row 1.
const String kSeedWhere1 = 'วิ่งที่ ม.เอเชีย';
const String kSeedWhere2 = 'จตุจักร';
const String kSeedWhere3 = 'วิ่งที่คู่เมืองเชียงใหม่';
const String kSeedWhere4 = 'วิ่งที่ชายหาดพัทยา';

const String kSeedPerson1 = 'วิ่งคนเดียว';

/// Bundled placeholder photo paths, readable by [Image.asset].
const String kPhotoPark = 'assets/images/photo_park.png';
const String kPhotoBeach = 'assets/images/photo_beach.png';

List<RunEntry> buildSeedRuns() {
  // Fixed timestamps keep the demo data stable across launches.
  final base = DateTime.utc(2026, 1, 1, 9);
  return <RunEntry>[
    RunEntry(
      id: 'seed-1',
      createdAt: base,
      runWhere: kSeedWhere1,
      runPerson: kSeedPerson1,
      runDistance: 2,
      runImageUrl: null, // logo fallback
    ),
    RunEntry(
      id: 'seed-2',
      createdAt: base.add(const Duration(hours: 1)),
      runWhere: kSeedWhere2,
      runPerson: 'เพื่อน 3 คน',
      runDistance: 7,
      runImageUrl: kPhotoPark,
    ),
    RunEntry(
      id: 'seed-3',
      createdAt: base.add(const Duration(hours: 2)),
      runWhere: kSeedWhere3,
      runPerson: 'แฟน',
      runDistance: 50,
      runImageUrl: kPhotoBeach,
    ),
    RunEntry(
      id: 'seed-4',
      createdAt: base.add(const Duration(hours: 3)),
      runWhere: kSeedWhere4,
      runPerson: 'ครอบครัว',
      runDistance: 2000,
      runImageUrl: kPhotoPark,
    ),
  ];
}
