# onclick-archive-cli (jronix)

A powerful Dart-based Command Line Interface (CLI) tool designed for Flutter developers to automate the iOS release workflow. With a single command, it increments the version, cleans the project, updates dependencies, installs iOS pods, and opens Xcode ready for archiving.

## Features
- **Version Auto-Increment:** Automatically bumps the patch and build number in `pubspec.yaml` (e.g., `1.0.0+1` -> `1.0.1+2`).
- **Clean Workspace:** Runs `flutter clean` to ensure a fresh build.
- **Dependency Update:** Runs `flutter pub get` and `flutter precache --ios`.
- **Pod Installation:** Automatically runs `pod install --repo-update` in the iOS directory.
- **Xcode Integration:** Opens `Runner.xcworkspace` immediately after preparation is done.

## Installation

To install this tool globally on your machine, run the following command:

```bash
dart pub global activate --source git https://github.com/ranasheikh64/onclick-archive-cli.git
```

Make sure that your Dart SDK's `bin` directory is in your system's `PATH`.

## Usage

Navigate to the root directory of your Flutter project and run:

```bash
jronix release
```

This will execute the entire release preparation workflow automatically.

### Getting Help

To see all available commands and options, you can use the help command:

```bash
jronix --help
```

Output:
```text
A powerful CLI tool for Flutter release automation.

Usage: jronix <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  release   Prepares the Flutter project for release (Clean, Pub Get, Pod Install, Open Xcode).

Run "jronix help <command>" for more information about a command.
```

## Contributing
Feel free to open issues or submit pull requests for additional automation features!
