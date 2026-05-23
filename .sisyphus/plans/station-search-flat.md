# Plan: Convert SearchableGetOffice to Flat List (No Grouping)

## TL;DR
> Remove region grouping from `SearchableGetOffice` widget. Keep the search TextField but render stations as a flat list like the original `GetOffice` dialog. No more `station_data.dart` dependency.

## Task

- [ ] 1. Refactor `SearchableGetOffice` in `lib/_getOfficeList.dart`

  **What to do**:
  - Remove `import 'station_data.dart';` (comment it out or delete)
  - Replace `List<StationGroup> _groups`, `List<StationGroup> _filteredGroups`, `bool isSearching` state with `List _filteredOffices`
  - `initState()`: set `_filteredOffices = List.from(offices)` instead of `groupStationsByRegion(offices)`
  - `onChanged`: filter `offices` directly by `(o['NameA'] as String).toLowerCase().contains(query.toLowerCase())` instead of `filterStations(_groups, query)`
  - Clear button: reset `_filteredOffices = List.from(offices)`
  - Replace `ExpansionTile` + nested station `.stations.map(...)` with `ListView.builder` over `_filteredOffices` (like old `GetOffice` at lines 157-179)
  - Station tile items: reference raw Map entries (`station['Code']`, `station['NameA']`) instead of `StationInfo` objects
  - Keep duplicate disambiguation: `if (code == 585 || code == 2113)`
  - Keep same `onTap` assignment: `codeFrom = code`, `officeNameFrom = nameA` etc.
  - Keep green checkmark for selected station
  - Empty state "لا توجد نتائج" unchanged

  **Must NOT do**:
  - ❌ Don't modify `GetOffLi`, `OfficePnl`, or `GetOffice` classes
  - ❌ Don't delete `station_data.dart` file — just remove the import from `_getOfficeList.dart`
  - ❌ Don't add any new features beyond the scope

  **Recommended Agent Profile**: `quick`

  **Acceptance Criteria**:
  - [ ] `dart analyze lib/_getOfficeList.dart` — 0 errors
  - [ ] No references to `StationGroup`, `StationInfo`, `groupStationsByRegion`, `filterStations` in `_getOfficeList.dart`
  - [ ] Search TextField still filters stations by Arabic name in real-time
  - [ ] List is flat (no ExpansionTile, no region headers)
  - [ ] Station selection still assigns globals correctly
  - [ ] Empty state still shows "لا توجد نتائج"
