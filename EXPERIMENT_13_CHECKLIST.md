# Experiment 13 — Implementation Checklist

| Syllabus requirement | Project implementation |
|---|---|
| Manage structured data | Campus Facilities records: name, type, building, floor, description |
| `Form` and `TextFormField` | Validated Add/Edit facility dialog |
| `DropdownButton` | Facility type selection and type filter use `DropdownButtonFormField` |
| `ListView` / display data | Responsive facility list on narrow screens and grid on wider screens |
| Create, Read, Update, Delete | Add, load/display, edit and remove facility records |
| Persistence | `shared_preferences`; Flutter Web implementation stores values in browser local storage |
| Responsive UI | Adaptive search/filter layout and 1/2/3-column facility layout based on available width |
| Existing application preserved | Existing screens/routes remain; Facilities added as a new route and Home quick action |

## Important storage scope

Browser local storage is scoped to a browser profile and website origin. It does not provide shared multi-user or cross-device data. Use a backend database if multiple users must see the same changes.

## Validation status

This package includes source and deployment instructions. Run `flutter pub get`, `flutter analyze`, and `flutter test` in a Flutter SDK environment before submission. Do not claim these commands passed unless their actual output confirms it.
