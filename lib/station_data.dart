/// Data models and helper functions for station (office) data.
///
/// Raw station data comes from the API as a list of JSON objects with
/// `Code` (int) and `NameA` (String) fields. This file provides typed
/// models, a hardcoded region mapping, and grouping/filtering utilities.
library;

/// A single station.
class StationInfo {
  final int code;
  final String nameA;

  const StationInfo({required this.code, required this.nameA});
}

/// A named group of stations belonging to the same region.
class StationGroup {
  final String regionName;
  final List<StationInfo> stations;

  const StationGroup({required this.regionName, required this.stations});
}

/// Hardcoded mapping from station code to region name.
///
/// Covers all ~38 stations returned by the API grouped by geographic region.
const Map<int, String> _stationToRegion = {
  // القاهرة الكبرى (Greater Cairo)
  584: 'القاهرة الكبرى',
  585: 'القاهرة الكبرى',
  2113: 'القاهرة الكبرى',
  2011: 'القاهرة الكبرى',

  // الدلتا (Delta)
  580: 'الدلتا',
  2226: 'الدلتا',
  2021: 'الدلتا',
  10067: 'الدلتا',
  2031: 'الدلتا',
  2041: 'الدلتا',
  2121: 'الدلتا',

  // القناة والشمال (Canal & North Coast)
  9992: 'القناة والشمال',
  2072: 'القناة والشمال',

  // الصعيد (Upper Egypt)
  550: 'الصعيد',
  551: 'الصعيد',
  548: 'الصعيد',
  554: 'الصعيد',
  555: 'الصعيد',
  556: 'الصعيد',
  2020: 'الصعيد',
  553: 'الصعيد',
  552: 'الصعيد',
  33: 'الصعيد',
  395: 'الصعيد',
  2193: 'الصعيد',
  2219: 'الصعيد',
  2060: 'الصعيد',
  2223: 'الصعيد',

  // البحر الأحمر (Red Sea)
  2049: 'البحر الأحمر',
  2218: 'البحر الأحمر',
  2051: 'البحر الأحمر',
  2054: 'البحر الأحمر',
  2052: 'البحر الأحمر',
  2063: 'البحر الأحمر',
  2066: 'البحر الأحمر',
  2061: 'البحر الأحمر',
  2125: 'البحر الأحمر',

  // الإسكندرية (Alexandria)
  2071: 'الإسكندرية',
};

/// Groups raw stations (as returned by the API) by region.
///
/// Each entry in [rawStations] is expected to be a `Map` with keys `"Code"`
/// (int) and `"NameA"` (String). Stations whose code is not found in the
/// region mapping are placed in an "أخرى" (Other) group.
List<StationGroup> groupStationsByRegion(List rawStations) {
  final Map<String, List<StationInfo>> grouped = {};

  for (final raw in rawStations) {
    final code = raw['Code'] as int;
    final nameA = raw['NameA'] as String;
    final region = _stationToRegion[code] ?? 'أخرى';

    grouped.putIfAbsent(region, () => []).add(
      StationInfo(code: code, nameA: nameA),
    );
  }

  return grouped.entries
      .map((e) => StationGroup(regionName: e.key, stations: e.value))
      .toList();
}

/// Filters [groups] to only stations whose name contains [query].
///
/// - An empty query returns all groups unchanged.
/// - Matching is case-insensitive (both query and station name are lowered).
/// - Groups that end up with zero stations are removed.
List<StationGroup> filterStations(List<StationGroup> groups, String query) {
  if (query.isEmpty) return groups;

  final lowerQuery = query.toLowerCase();

  return groups
      .map((group) {
        final filtered = group.stations
            .where((s) => s.nameA.toLowerCase().contains(lowerQuery))
            .toList();
        return StationGroup(regionName: group.regionName, stations: filtered);
      })
      .where((group) => group.stations.isNotEmpty)
      .toList();
}

/// Convenience function: groups raw stations and filters in one call.
///
/// Equivalent to `filterStations(groupStationsByRegion(rawStations), query)`.
List<StationGroup> filterStationsFlat(List rawStations, String query) {
  return filterStations(groupStationsByRegion(rawStations), query);
}
