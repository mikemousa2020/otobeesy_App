# Plan: Station Search with Region Grouping

## TL;DR

> **Quick Summary**: Replace the current flat station selection dialog (`GetOffice`) with a searchable, region-grouped station selection screen — matching the gobus-mobile `cityList_screen` UX pattern. Uses a hardcoded station→region mapping since the API doesn't provide region data.
>
> **Deliverables**:
> - `lib/station_data.dart` — Station models + hardcoded region mapping + grouping logic
> - Modified `lib/_getOfficeList.dart` — Search TextField + grouped ExpansionTile list
> - Modified `lib/myClasses.dart` — Clean up unused `off` class
>
> **Estimated Effort**: Short (3 files, ~200 lines total)
> **Parallel Execution**: YES — 2 waves
> **Critical Path**: Task 1 → Task 2 → Task 3

---

## Context

### Original Request
User wants to add station search with city/region grouping (like gobus-mobile `cityList_screen` module) to the Otobeesy bus booking app.

### Key Decisions from Interview
- **Approach**: Option B — Hardcoded Station→Region mapping (38 stations, manageable)
- **No state management**: Keep `setState` + global vars (match existing codebase)
- **Search**: Arabic-only (`NameA`), since API has no `NameE`
- **Duplicates**: Show both entries (أحمد حلمى Code 585 & 2113) with distinguishing info
- **Testing**: No automated tests (matches project), agent-executed QA only

### Reference Implementation
gobus-mobile `cityList_screen` module:
- `cityList_screen.dart` — Search TextField + ExpansionTile per city + station list items
- `cityList_cubit.dart` — `searchStations(String query)` with name-based filtering
- `cityItem_view.dart` / `stationItem_view.dart` — City and station tile widgets

### Metis Review
**Critical discovery**: The Otobeesy `/Stations` API returns flat data with only `Code` and `NameA` (no `TripRegion_Code`, no `NameE`). Client-side grouping via hardcoded mapping was chosen as the solution.

---

## Work Objectives

### Core Objective
Replace the flat `GetOffice` station dialog with a searchable, region-grouped station selection dialog using hardcoded station→region mapping, matching the gobus cityList_screen UX pattern.

### Concrete Deliverables
- `lib/station_data.dart` — Contains `StationGroup`, `StationInfo` models + hardcoded `stationToRegion` map + `groupStationsByRegion()` function
- Modified `lib/_getOfficeList.dart` — New `SearchableGetOffice` widget replacing `GetOffice` with search TextField + ExpansionTile list grouped by region
- Modified `lib/myClasses.dart` — Remove unused `off` class (cleanup)

### Definition of Done
- [ ] Typing in search field filters stations by Arabic name in real-time
- [ ] Stations are grouped by region under expandable headers
- [ ] Tapping a station assigns `codeFrom`/`codeTo` + `officeNameFrom`/`officeNameTo` correctly (same as current behavior)
- [ ] All existing app flows (trips, confirm, booking) continue to work unchanged
- [ ] No backend changes required

### Must Have
- [ ] Real-time text search filtering by Arabic station name
- [ ] Stations grouped by region under ExpansionTile headers
- [ ] Station selection assigns global variables (same pattern as current code)
- [ ] Search field with clear button when text is present
- [ ] Hardcoded station→region mapping for all ~38 stations

### Must NOT Have (Guardrails)
- ❌ No state management libraries (no Bloc/Cubit/Provider/Riverpod)
- ❌ No refactoring of `callApi.dart` or API layer
- ❌ No localization framework — keep Arabic hardcoded strings
- ❌ No changes to `homePage.dart`, `trips.dart`, `confirm.dart`, or `booking.dart`
- ❌ No backend or API changes
- ❌ No caching or persistence of station list
- ❌ No pull-to-refresh, animations, or sorting

---

## Verification Strategy

> **ZERO HUMAN INTERVENTION** — ALL verification is agent-executed.

### Test Decision
- **Infrastructure exists**: NO
- **Automated tests**: None (matches current project)
- **Agent-Executed QA**: YES — mandatory for all tasks

### QA Policy
Every task includes agent-executed QA scenarios. Since this is a Flutter UI change, QA will use:
- **Dart analysis**: `dart analyze lib/station_data.dart` — verify no errors
- **Code review**: Read modified files to verify structure matches plan
- **Simulated verification**: Review search logic, grouping logic, and widget structure for correctness

---

## Execution Strategy

### Parallel Execution Waves

```
Wave 1 (Foundation - data layer, can run in parallel):
├── Task 1: Create station_data.dart — models + hardcoded mapping + grouping logic
├── Task 2: Clean up unused `off` class in myClasses.dart
└── Task 3: Populate station→region mapping for all stations

Wave 2 (UI layer — after Wave 1):
├── Task 4: Build SearchableGetOffice widget with search + grouped ExpansionTile list
├── Task 5: Wire SearchableGetOffice into homePage.dart (replace GetOffice call)
└── Task 6: End-to-end verification

Critical Path: Task 1 → Task 4 → Task 5 → Task 6
Parallel Speedup: ~40% faster than sequential
Max Concurrent: 2
```

### Dependency Matrix
- **Task 1**: — — 4
- **Task 2**: — — (independent cleanup)
- **Task 3**: 1 — 4
- **Task 4**: 1, 3 — 5
- **Task 5**: 4 — 6
- **Task 6**: 5 — final

---

## TODOs

- [x] 1. Create `station_data.dart` — Models + Hardcoded Mapping + Grouping Logic

  **What to do**:
  - Create new file `lib/station_data.dart`
  - Define `StationInfo` class with: `int code`, `String nameA`
  - Define `StationGroup` class with: `String regionName`, `List<StationInfo> stations`
  - Create `Map<int, String> _stationToRegion` — hardcoded mapping of station Code → region Arabic name
  - Create `List<StationGroup> groupStationsByRegion(List rawStations)` function that:
    1. Takes the raw JSON-decoded station list (same as current `offices`)
    2. Groups by region using the hardcoded map
    3. Returns sorted list of `StationGroup` objects
  - Create `List<StationGroup> filterStations(List<StationGroup> groups, String query)` function:
    1. If query is empty → return all groups with all stations
    2. If query has text → for each group, only include stations where `nameA.contains(query)`
    3. Remove groups that have zero matching stations
    4. Case-insensitive search (Arabic characters are already lowercase-equivalent)
  - Create `List<StationGroup> filterStationsFlat(List rawStations, String query)` as a convenience if grouping isn't needed later

  **Must NOT do**:
  - ❌ Don't import anything from `callApi.dart` (keep data layer separate)
  - ❌ Don't add any state management
  - ❌ Don't add English name search (NameE not available)
  - ❌ Don't sort or reorder stations beyond what the API returns

  **Recommended Agent Profile**:
  - **Category**: `quick` — Single file, clear data structures, no UI complexity
  - **Skills**: `[]` — Straightforward Dart, no Flutter UI here
  - Reason: Pure data modeling + logic, no widgets, no state

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Task 2)
  - **Parallel Group**: Wave 1 (with Tasks 2, 3)
  - **Blocks**: Task 3, Task 4
  - **Blocked By**: None (can start immediately)

  **References**:
  - `lib/myClasses.dart:5-8` — Current `off` class (unused, will be removed in Task 2)
  - `gobus-mobile:lib/modules/main_core/home_module/cityList_screen/cubit/cityList_cubit.dart:49-84` — Reference `searchStations()` algorithm
  - `gobus-mobile:lib/data/response/city_list_response.dart` — Reference `CityListResponse` and `Station` model structure

  **Acceptance Criteria**:
  - [ ] `dart analyze lib/station_data.dart` — 0 errors, 0 warnings
  - [ ] `StationInfo` has: `int code`, `String nameA`
  - [ ] `StationGroup` has: `String regionName`, `List<StationInfo> stations`
  - [ ] `groupStationsByRegion()` correctly groups sample test data by region
  - [ ] `filterStations()` with empty query returns all stations
  - [ ] `filterStations()` with query filters correctly — e.g., searching "سوهاج" only shows stations matching that name
  - [ ] `filterStations()` with non-matching query returns empty groups list

  **QA Scenarios**:

  ```
  Scenario: StationInfo model creation
    Tool: Bash (dart)
    Preconditions: station_data.dart exists
    Steps:
      1. Read file and verify StationInfo class has `code` (int) and `nameA` (String) fields
      2. Read file and verify StationGroup class has `regionName` (String) and `stations` (List<StationInfo>)
    Expected Result: Both classes defined with correct field types
    Evidence: .sisyphus/evidence/task-1-model-structure.md

  Scenario: Grouping logic works
    Tool: Bash (dart)
    Preconditions: station_data.dart exists
    Steps:
      1. Read file and verify `groupStationsByRegion()` function exists
      2. Verify it takes `List` (raw stations) and returns `List<StationGroup>`
      3. Verify the hardcoded `_stationToRegion` map contains entries
    Expected Result: Grouping function correctly structured
    Evidence: .sisyphus/evidence/task-1-grouping-logic.md

  Scenario: Filter logic exists
    Tool: Bash (dart)
    Preconditions: station_data.dart exists
    Steps:
      1. Read file and verify `filterStations()` function exists
      2. Verify it takes `List<StationGroup>` and `String query`
      3. Verify empty query returns all groups unchanged
    Expected Result: Filter function correctly handles empty query
    Evidence: .sisyphus/evidence/task-1-filter-logic.md
  ```

  **Commit**: YES
  - Message: `feat(stations): add station data models, hardcoded region mapping, and grouping logic`
  - Files: `lib/station_data.dart`
  - Pre-commit: `dart analyze lib/station_data.dart`


- [x] 2. Clean up unused `off` class in `myClasses.dart`

  **What to do**:
  - In `lib/myClasses.dart`, remove the `off` class (lines 5-8)
  - Scan the entire codebase to confirm `off` is not used anywhere else
  - The `off` class defines: `int Code=0; String NameA='';` — this was probably meant to be the station model but was never used

  **Must NOT do**:
  - ❌ Don't change any other code in `myClasses.dart`
  - ❌ Don't touch any other files

  **Recommended Agent Profile**:
  - **Category**: `quick` — Trivial removal, 1 file, 4 lines
  - **Skills**: `[]` — Simple Dart edit
  - Reason: Dead code cleanup, no logic change

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Task 1)
  - **Parallel Group**: Wave 1 (with Tasks 1, 3)
  - **Blocks**: Nothing
  - **Blocked By**: None (can start immediately)

  **References**:
  - `lib/myClasses.dart:5-8` — The `off` class to remove
  - `grep "class off"` or `grep "off("` — Verify no usages

  **Acceptance Criteria**:
  - [ ] `off` class removed from `myClasses.dart`
  - [ ] No compile errors after removal
  - [ ] `grep -r "class off" lib/` returns no results (confirm class is gone)
  - [ ] `grep -r "off(" lib/` returns no references to this type

  **QA Scenarios**:

  ```
  Scenario: Confirm off class removed
    Tool: Bash (grep)
    Preconditions: myClasses.dart exists
    Steps:
      1. Search for "class off" in lib/myClasses.dart
      2. Confirm the class is no longer present
    Expected Result: No "class off" found
    Evidence: .sisyphus/evidence/task-2-class-removed.md

  Scenario: No compile errors
    Tool: Bash (dart)
    Preconditions: myClasses.dart modified
    Steps:
      1. Run `dart analyze lib/myClasses.dart`
      2. Confirm 0 errors
    Expected Result: Clean analysis
    Evidence: .sisyphus/evidence/task-2-analyze-clean.md
  ```

  **Commit**: YES (can group with Task 1)
  - Message: `clean(myClasses): remove unused off class`
  - Files: `lib/myClasses.dart`
  - Pre-commit: `dart analyze lib/myClasses.dart`


- [x] 3. Populate station→region mapping for all ~38 stations

  **What to do**:
  - This task must be done AFTER Task 1 (it populates the `_stationToRegion` map)
  - For EACH station in the API response (call `/Stations?companyID=10` to get the full list), assign a region
  - The mapping is `Map<int, String>` where:
    - Key = station `Code` (e.g., 585)
    - Value = region Arabic name (e.g., "القاهرة")
  - To determine regions, analyze each station name and match to known Egyptian regions:
    - **القاهرة الكبرى**: القاهرة, أحمد حلمى, صقر قريش, رمسيس, العتبة, etc.
    - **الجيزة**: الجيزة, المنيرة, المنيب, etc.
    - **الدلتا**: طنطا, المحلة, المنصورة, etc.
    - **القناة والشمال**: الإسماعيلية, بورسعيد, etc.
    - **الصعيد**: سوهاج, أسيوط, الأقصر, قنا, أسوان, etc.
    - **الإسكندرية**: الإسكندرية, كفر الدوار, etc.
    - **البحر الأحمر**: الغردقة, شرم الشيخ, etc.

  **Must NOT do**:
  - ❌ Don't modify any other file — this task ONLY populates data in `station_data.dart`
  - ❌ Don't add regions for stations not in the API response

  **Recommended Agent Profile**:
  - **Category**: `quick` — Data entry task, repetitive but straightforward
  - **Skills**: `[]` — Just adding map entries
  - Reason: Mechanical data population, no decision logic

  **Parallelization**:
  - **Can Run In Parallel**: NO (depends on Task 1 for file structure)
  - **Parallel Group**: Sequential (after Task 1)
  - **Blocks**: Task 4
  - **Blocked By**: Task 1

  **References**:
  - `lib/station_data.dart` — The map to populate (created in Task 1)
  - Actual API response: call `https://otobeesy.com/api/V2/Stations?companyID=10` to list all stations

  **Acceptance Criteria**:
  - [ ] Every station code from the API response has a region mapping entry
  - [ ] No station code appears twice in the map
  - [ ] Region names are consistent (same spelling for same region)
  - [ ] `dart analyze lib/station_data.dart` — 0 errors

  **QA Scenarios**:

  ```
  Scenario: All stations mapped
    Tool: Bash (dart)
    Preconditions: station_data.dart with populated mapping
    Steps:
      1. Read the `_stationToRegion` map in station_data.dart
      2. Count the entries
      3. Verify entry count matches expected station count (~38)
    Expected Result: All stations have region mapping
    Evidence: .sisyphus/evidence/task-3-mapping-complete.md
  ```

  **Commit**: YES (group with Task 1 commit or separate)
  - Message: `feat(stations): populate station-to-region mapping for all stations`
  - Files: `lib/station_data.dart`
  - Pre-commit: `dart analyze lib/station_data.dart`


- [x] 4. Build `SearchableGetOffice` widget — Search + Grouped ExpansionTile Station List

  **What to do**:
  - In `lib/_getOfficeList.dart`, add a new widget `SearchableGetOffice` that replaces the old `GetOffice` dialog
  - The widget structure:
    ```
    Scaffold
      AppBar: "اختار المحطة" (same title)
      Body:
        Column
          Padding
            TextField (search box with search icon + clear button)
          Expanded
            ListView
              ExpansionTile (per region)
                title: region name (Arabic)
                children: StationInfo items
                  InkWell → onTap: assign globals + pop
      ```
  - **Search TextField**:
    - `TextEditingController` with `onChanged` callback
    - Prefix icon: search icon (Icons.search)
    - Suffix icon: clear button (Icons.close) — only shown when text is not empty
    - Hint: "ابحث عن محطة"
    - On each keystroke → call `filterStations()` and `setState()`
  - **ExpansionTile per region**:
    - Title shows region name
    - Initially: ALL expanded (like gobus during search)
    - Actually, let's keep them collapsed by default, expand on tap — better UX for 38 stations
  - **Station item in each ExpansionTile**:
    - Shows station `nameA` (Arabic)
    - If it's a known duplicate (أحمد حلمى), append `(Code: XXX)` for distinction
    - `InkWell` with `onTap` assigning:
      ```dart
      if (widget.direction == 1) {
        codeFrom = station.code;
        officeNameFrom = station.nameA;
      } else {
        codeTo = station.code;
        officeNameTo = station.nameA;
      }
      widget.notifyParent();
      Navigator.of(context).pop();
      ```
  - **Empty state**: When search returns no results, show a centered "لا توجد نتائج" text
  - **Import** `station_data.dart` for the models and filter functions
  - **Get raw station data**: Read from global `offices` list (same as current code)
  - **On init**: Call `groupStationsByRegion(offices)` to build the grouped list
  - **Search**: Call `filterStations(groups, query)` and rebuild

  **Must NOT do**:
  - ❌ Don't change how stations are fetched (keep using `offices` global list)
  - ❌ Don't change how selection updates globals (keep `codeFrom`/`codeTo` pattern)
  - ❌ Don't remove the old `GetOffice` class yet (might be needed as backup) — but do replace the entry point
  - ❌ Don't add any animations, transitions, or complex styling
  - ❌ Don't use any packages that aren't already in pubspec.yaml

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering` — UI with search field, ExpansionTile, list
  - **Skills**: `[]` — Standard Flutter widgets, no special skills needed
  - Reason: Core UI work — search field, ExpansionTile list, RTL layout

  **Parallelization**:
  - **Can Run In Parallel**: NO (depends on Tasks 1, 3)
  - **Parallel Group**: Sequential (Wave 2)
  - **Blocks**: Task 5, Task 6
  - **Blocked By**: Task 1, Task 3

  **References**:
  - `lib/_getOfficeList.dart:133-179` — Current `GetOffice` widget (the one being replaced)
  - `lib/station_data.dart` — Models and filter functions (created in Task 1)
  - `lib/callApi.dart:20,63` — `offices` global list and `codeFrom`/`codeTo` variables
  - `gobus-mobile:cityList_screen.dart:94-127` — Reference search + ExpansionTile pattern
  - `gobus-mobile:cityItem_view.dart` — City header style
  - `gobus-mobile:stationItem_view.dart` — Station item style

  **Acceptance Criteria**:
  - [ ] `dart analyze lib/_getOfficeList.dart` — 0 errors, 0 warnings
  - [ ] Search TextField visible at top of dialog
  - [ ] Typing in search filters stations in real-time by Arabic name
  - [ ] Stations grouped by region under expandable headers
  - [ ] Tapping a station correctly assigns `codeFrom`/`codeTo` + `officeNameFrom`/`officeNameTo`
  - [ ] Clear button appears when search text is present, clears on tap
  - [ ] Empty search returns all stations (no filter)
  - [ ] Non-matching search shows "لا توجد نتائج" empty state
  - [ ] Duplicate stations show distinguishing info (code appended)

  **QA Scenarios**:

  ```
  Scenario: Widget structure verification
    Tool: Code review (read files)
    Preconditions: _getOfficeList.dart modified
    Steps:
      1. Read _getOfficeList.dart and verify SearchableGetOffice widget exists
      2. Verify it has a TextEditingController for search
      3. Verify it uses ExpansionTile for region grouping
      4. Verify station onTap assigns codeFrom/officeNameFrom or codeTo/officeNameTo
    Expected Result: Widget structure matches design
    Evidence: .sisyphus/evidence/task-4-widget-structure.md

  Scenario: Search functionality
    Tool: Code review (read files)
    Preconditions: _getOfficeList.dart modified
    Steps:
      1. Find the onChanged handler for the search TextField
      2. Verify it calls filterStations() with the query text
      3. Verify empty query shows all groups
      4. Verify non-empty query filters stations
    Expected Result: Search logic correctly implemented
    Evidence: .sisyphus/evidence/task-4-search-logic.md

  Scenario: Selection logic
    Tool: Code review (read files)
    Preconditions: _getOfficeList.dart modified
    Steps:
      1. Find the onTap handler for station items
      2. Verify it assigns codeFrom/officeNameFrom (if direction==1) or codeTo/officeNameTo (if direction==2)
      3. Verify it calls widget.notifyParent()
      4. Verify it calls Navigator.of(context).pop()
    Expected Result: Selection assigns globals and pops dialog (same as current behavior)
    Evidence: .sisyphus/evidence/task-4-selection-logic.md

  Scenario: Duplicate station display
    Tool: Code review (read files)
    Preconditions: _getOfficeList.dart modified
    Steps:
      1. Find the station tile rendering code
      2. Verify duplicate stations (أحمد حلمى) have distinguishing info appended
    Expected Result: Duplicates are distinguishable
    Evidence: .sisyphus/evidence/task-4-duplicates.md
  ```

  **Commit**: YES
  - Message: `feat(stations): add searchable station selection dialog with region grouping`
  - Files: `lib/_getOfficeList.dart`, `lib/station_data.dart`
  - Pre-commit: `dart analyze lib/_getOfficeList.dart lib/station_data.dart`


- [x] 5. Wire `SearchableGetOffice` into `homePage.dart`

  **What to do**:
  - In `lib/_getOfficeList.dart`, modify the `OfficePnl` widget's `onTap` to open `SearchableGetOffice` instead of `GetOffice`
  - Or: leave old `GetOffice` class in place but change the entry point reference
  - In `_OfficePnlState.build()`, the dialog call is at line 86-89:
    ```dart
    showDialog(
      context: context,
      builder: (context) => GetOffice(widget.direction, refresh),
    );
    ```
  - Change to:
    ```dart
    showDialog(
      context: context,
      builder: (context) => SearchableGetOffice(widget.direction, refresh),
    );
    ```
  - **Optional**: If the old `GetOffice` widget is no longer referenced anywhere, remove it to keep codebase clean. But keep it if there are other references.

  **Must NOT do**:
  - ❌ Don't change any other code in `homePage.dart`
  - ❌ Don't modify the API call, trip flow, or any other functionality

  **Recommended Agent Profile**:
  - **Category**: `quick` — 3-line change, trivial
  - **Skills**: `[]` — Simple reference swap
  - Reason: One-line entry point change

  **Parallelization**:
  - **Can Run In Parallel**: NO (depends on Task 4)
  - **Parallel Group**: Sequential (Wave 2)
  - **Blocks**: Task 6
  - **Blocked By**: Task 4

  **References**:
  - `lib/_getOfficeList.dart:86-89` — The current `GetOffice` dialog call in `OfficePnl`
  - `lib/_getOfficeList.dart` — The new `SearchableGetOffice` widget (created in Task 4)

  **Acceptance Criteria**:
  - [ ] Tapping "من" or "الى" on home page opens `SearchableGetOffice` dialog (not old `GetOffice`)
  - [ ] `dart analyze lib/_getOfficeList.dart` — 0 errors
  - [ ] Selection still correctly updates global variables and refreshes parent

  **QA Scenarios**:

  ```
  Scenario: Entry point changed
    Tool: Code review (read files)
    Preconditions: _getOfficeList.dart modified
    Steps:
      1. Search for "GetOffice(" in _getOfficeList.dart
      2. Verify the only ShowDialog call uses SearchableGetOffice, not GetOffice
    Expected Result: Entry point updated to new widget
    Evidence: .sisyphus/evidence/task-5-entry-point.md

  Scenario: No regressions
    Tool: Code review (read files)
    Preconditions: _getOfficeList.dart modified
    Steps:
      1. Verify OfficePnl still passes widget.direction and refresh callback
      2. Verify the overall widget hierarchy is unchanged
    Expected Result: Existing OfficePnl wrapper unchanged
    Evidence: .sisyphus/evidence/task-5-no-regression.md
  ```

  **Commit**: YES (can group with Task 4)
  - Message: `feat(stations): wire searchable station dialog into home page`
  - Files: `lib/_getOfficeList.dart`
  - Pre-commit: `dart analyze lib/_getOfficeList.dart`


- [x] 6. End-to-end verification

  **What to do**:
  - Read all changed files and verify:
    1. `lib/station_data.dart` — models correct, mapping complete, filter logic works
    2. `lib/_getOfficeList.dart` — SearchableGetOffice correctly built, entry point swapped
    3. `lib/myClasses.dart` — `off` class removed (if Task 2 was done)
  - Verify no imports are broken
  - Verify `codeFrom`/`codeTo` assignment still works correctly in all flow paths
  - Run `dart analyze` on all changed files
  - Run `flutter analyze` on the whole project to catch any side effects

  **Must NOT do**:
  - ❌ Don't make any code changes in this task (verification only)

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high` — Code review + analysis
  - **Skills**: `[]` — Analysis and verification
  - Reason: Cross-file verification, needs understanding of the full feature

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Parallel Group**: Final
  - **Blocks**: Nothing (final verification task)
  - **Blocked By**: Task 4, Task 5

  **References**:
  - All modified files: `lib/station_data.dart`, `lib/_getOfficeList.dart`, `lib/myClasses.dart`

  **Acceptance Criteria**:
  - [ ] `flutter analyze` — 0 errors, 0 warnings
  - [ ] All 3 modified files compile without issues
  - [ ] Station search dialog opens from home page
  - [ ] Search filters correctly
  - [ ] Station selection updates global variables
  - [ ] No regressions in trip search, seat selection, confirmation, or booking flows

  **QA Scenarios**:

  ```
  Scenario: Full project analysis
    Tool: Bash (flutter)
    Preconditions: All changes complete
    Steps:
      1. Run `flutter analyze`
      2. Capture output
    Expected Result: No errors, no warnings
    Evidence: .sisyphus/evidence/task-6-flutter-analyze.md

  Scenario: Verify no unintended changes
    Tool: Bash (git)
    Preconditions: Git repository
    Steps:
      1. Run `git diff --stat` to see changed files
      2. Verify only station_data.dart, _getOfficeList.dart, and myClasses.dart (if cleaned up) are changed
    Expected Result: Only intended files modified
    Evidence: .sisyphus/evidence/task-6-git-diff.md
  ```

  **Commit**: YES
  - Message: `feat(stations): complete station search with region grouping`
  - Files: All modified files
  - Pre-commit: `flutter analyze`

---

## Final Verification Wave

> 4 review agents run in PARALLEL. ALL must approve. Present results and get explicit user "okay" before finalizing.

- [x] F1. **Plan Compliance Audit** — `oracle`
  Read the plan end-to-end and the implementation:
  - For each "Must Have": verify implementation exists in code
  - For each "Must NOT Have": search codebase for forbidden patterns
  - Check evidence files exist in .sisyphus/evidence/
  - Compare deliverables against plan
  Output: `Must Have [N/N] | Must NOT Have [N/N] | Tasks [N/N] | VERDICT: APPROVE/REJECT`

- [x] F2. **Code Quality Review** — `unspecified-high`
  - Run `dart analyze` on changed files
  - Review for: proper error handling, no hardcoded magic numbers, consistent naming with existing code, no dead imports, RTL text direction correctness
  - Check AI slop: excessive comments, over-abstraction, dead code
  Output: `Analysis [PASS/FAIL] | Files [N clean/N issues] | VERDICT`

- [x] F3. **Functional Verification** — `unspecified-high`
  Verify the search behavior by reading the code logic:
  - Search filters by Arabic name (case-insensitive)
  - Clear button resets to full list
  - Grouping correctly assigns stations to regions
  - Empty state shows "لا توجد نتائج" when no results
  - Selection assigns `codeFrom`/`codeTo` globally (same as old behavior)
  - `notifyParent()` is called after selection
  - `Navigator.pop()` returns to home page after selection
  - Duplicate stations show distinguishing info
  Output: `Checks [N/N pass] | VERDICT`

- [x] F4. **Scope Fidelity Check** — `deep`
  For each task: read "What to do", read actual diff (git log/diff). Verify 1:1 — everything in spec was built (no missing), nothing beyond spec was built (no creep). Check "Must NOT do" compliance. Flag unaccounted changes.
  Output: `Tasks [N/N compliant] | Contamination [CLEAN/N issues] | VERDICT`

---

## Commit Strategy

- **Task 1+2+3**: `feat(stations): add station data models with hardcoded region mapping`
  Files: `lib/station_data.dart`, `lib/myClasses.dart`
  Pre-commit: `dart analyze lib/station_data.dart lib/myClasses.dart`

- **Task 4+5**: `feat(stations): add searchable station selection dialog with region grouping`
  Files: `lib/_getOfficeList.dart`
  Pre-commit: `dart analyze lib/_getOfficeList.dart`

- **Task 6**: `feat(stations): final verification`
  Files: All modified files
  Pre-commit: `flutter analyze`

---

## Success Criteria

### Verification Commands
```bash
flutter analyze    # Expected: No issues found
dart analyze lib/station_data.dart   # Expected: No issues found
dart analyze lib/_getOfficeList.dart  # Expected: No issues found
```

### Final Checklist
- [ ] All "Must Have" items implemented and verified
- [ ] All "Must NOT Have" items confirmed absent
- [ ] `flutter analyze` passes with 0 errors
- [ ] Station search dialog opens from home page (من / إلى taps)
- [ ] Search filters stations in real-time by Arabic name
- [ ] Stations grouped by region under ExpansionTile headers
- [ ] Station selection correctly updates global variables
- [ ] No regressions in trip search, seat selection, confirm, or booking flows

