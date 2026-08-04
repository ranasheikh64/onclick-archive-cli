import 'dart:io';
import 'package:yaml/yaml.dart';

String incrementVersion(String pubspecPath) {
  final file = File(pubspecPath);
  if (!file.existsSync()) {
    throw Exception('pubspec.yaml not found at $pubspecPath');
  }

  final content = file.readAsStringSync();
  final doc = loadYaml(content);
  final String? version = doc['version'];

  if (version == null) {
    throw Exception('version not found in pubspec.yaml');
  }

  // Expecting format like: 1.0.0+1
  final regex = RegExp(r'^(\d+)\.(\d+)\.(\d+)\+(\d+)$');
  final match = regex.firstMatch(version);
  
  String newVersion = version;

  if (match != null) {
    final major = match.group(1);
    final minor = match.group(2);
    final patch = int.parse(match.group(3)!);
    final build = int.parse(match.group(4)!);
    
    newVersion = '$major.$minor.${patch + 1}+${build + 1}';
  } else {
    print('Warning: version format did not match expected X.Y.Z+B');
    return version;
  }
  
  if (newVersion != version) {
    final updatedContent = content.replaceFirst(
      RegExp('^version:\\s+.*\$', multiLine: true), 
      'version: $newVersion'
    );
    file.writeAsStringSync(updatedContent);
    print('✅ Version updated from $version to $newVersion');
  }
  
  return newVersion;
}
