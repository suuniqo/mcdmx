<!-- .github/copilot-instructions.md -->
# Copilot / AI agent instructions for mcdmx

This file contains repository-specific guidance for AI coding agents working on the `mcdmx` Flutter app. Keep edits focused, small, and consistent with existing patterns.

1. Purpose & Big Picture
- Project: Flutter app (multi-platform: Android, iOS, Windows, macOS, Linux, Web).
- Entry point: `lib/main.dart` — app uses `ChangeNotifierProvider` (`MyAppState`) and a `PageView` + `NavigationBar` pattern for navigation.
- Pages: `/lib/pages/*` (e.g., `home.dart`, `map.dart`, `news.dart`, `planner.dart`, `settings.dart`). Each file typically exports a `*Page` widget (stateless/stateful).

2. Key architectural patterns
- Global state: single `MyAppState` ChangeNotifier (defined in `lib/main.dart`) provided at the root via `provider` package.
- Navigation: index-driven `PageController` in `MyHomePage` (see `lib/main.dart`) — update index to change pages rather than using push/pop for the main bottom navigation.
- UI files: keep UI per-screen under `lib/pages/`. Prefer small focused widgets rather than giant monoliths.

3. Build / run / debug workflows (explicit)
- Install deps: `flutter pub get`.
- Run on default device: `flutter run`.
- Run on a specific device: `flutter run -d windows` or `flutter run -d android` or `flutter run -d chrome`.
- Android (Gradle) build (Windows): `.\android\gradlew.bat assembleDebug` (from repo root).
- Release builds:
  - Android: `flutter build apk --release` (set signing in `android/app/build.gradle.kts` if needed)
  - Windows/macOS/Linux: `flutter build windows` / `flutter build macos` / `flutter build linux`.
- Tests: `flutter test`.
- Lint & analysis: `flutter analyze` (project uses `flutter_lints` via `analysis_options.yaml`).

4. Project-specific conventions
- Files under `lib/pages/` map 1:1 to bottom navigation destinations; the `NavigationDestination` ordering in `lib/main.dart` reflects page order.
- App state lives in `MyAppState` (root provider). Avoid adding a second global provider unless explicitly needed; prefer adding localized providers inside a page.
- The codebase currently uses placeholders for many pages — when implementing a page, preserve the public class name and file name (e.g., `NewsPage` in `lib/pages/news.dart`).
- Package publishing: `publish_to: 'none'` in `pubspec.yaml` — do not change unless publishing intentionally.

5. Integration & platform notes
- Native/platform code is under `android/`, `ios/`, `windows/`, `macos/`, `linux/`. Changes to platform code can affect CI and builds — be conservative.
- Gradle config: `android/app/build.gradle.kts` sets Java/SDK versions (Java 17). Keep compatibility when editing build files.
- Generated plugin registrants exist in each platform folder; adding plugins will modify those generated files — run `flutter pub get` and rebuild after changes.

6. Example tasks and how to approach them
- Implement a new screen: add `lib/pages/<name>.dart` with `<Name>Page` class, wire it into `lib/main.dart`'s `PageView` children and `NavigationDestination` in the correct index.
- Add a package: update `pubspec.yaml`, run `flutter pub get`, and then run the app to let build tools regenerate platform registrants.
- Change global state: modify `MyAppState` in `lib/main.dart`. Keep the API surface small and stable.

7. Do / Don't for AI edits
- DO: Make small, self-contained changes; run `flutter analyze` and `flutter test` locally when possible.
- DO: Preserve class and file naming conventions (e.g., `NewsPage` in `lib/pages/news.dart`).
- DO: Respect `publish_to: 'none'` and existing platform build settings.
- DON'T: Rename top-level app identifiers (like applicationId in Android) without explicit instruction.
- DON'T: Replace the root `MyAppState` provider pattern with an unrelated global state library without discussion.

8. Useful file references
- App entry + navigation: `lib/main.dart`
- Pages: `lib/pages/*.dart` (e.g., `lib/pages/news.dart`)
- Manifest/build: `android/app/build.gradle.kts`, `ios/Runner/Info.plist`
- Dependencies: `pubspec.yaml`
- Lints: `analysis_options.yaml`

If anything here is unclear or you want more detail (CI commands, device matrix, or example PRs), tell me which area to expand. I'll iterate the file based on your feedback.
