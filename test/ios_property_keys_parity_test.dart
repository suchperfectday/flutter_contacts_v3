import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final RegExp _contactKey = RegExp(r'CNContact\w+Key');

const String _pluginPath = 'ios/Classes/SwiftFlutterContactsPlugin.swift';

List<String> propertyKeysAfter(String source, String anchor) {
  final int anchorIndex = source.indexOf(anchor);
  expect(anchorIndex, isNot(-1), reason: 'anchor not found: $anchor');
  final int open = source.indexOf('keys += [', anchorIndex);
  expect(open, isNot(-1), reason: 'no property key list after: $anchor');
  final int close = source.indexOf(']', open);
  return _contactKey
      .allMatches(source.substring(open, close))
      .map((Match match) => match.group(0)!)
      .toList();
}

void main() {
  final String plugin = File(_pluginPath).readAsStringSync();

  test('change history reads fetch every property key that select fetches', () {
    final List<String> selectKeys = propertyKeysAfter(
      plugin,
      'static func selectInternal(',
    );
    final List<String> changedKeys = propertyKeysAfter(
      plugin,
      'case "getChangedContacts":',
    );
    expect(changedKeys, containsAll(selectKeys));
  });

  test('change history reads fetch related names', () {
    final List<String> changedKeys = propertyKeysAfter(
      plugin,
      'case "getChangedContacts":',
    );
    expect(changedKeys, contains('CNContactRelationsKey'));
  });
}
