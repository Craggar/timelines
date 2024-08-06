# Timelines

## 0.4.0 (2024-08-06)
### Changed
- Updated the `active_at`, `ended`, and `not_deleted` scopes to return live records that may have future end dates.
- Calling `end!` on a record with a future end date will now set the end date to the current date.

## 0.3.1 (2024-06-17)
### Changed
- Modified the `destroy` method to run callbacks, remove associations, etc.

## 0.3.0 (2024-05-27)
### Changed
- Added audit_trail instance method

## 0.2.3 (2024-04-01)
### Changed
- Added active_at scope and active_at? instance method to Ephemeral

## 0.1.3 (2023-10-09)
### Changed
- Updated the required rails version to "~> 7.1.0"

## 0.1.2 (2023-10-09)
### Changed
- Updated the required rails version to >= 7

## 0.1.1 (2023-10-09)
### Changed
- Updated the required rails version to "`~> 7.0.0`"
- Updated description to differ from Summary

### Added
- MIT License
## 0.1.0 (2023-10-09)
Initial release.
