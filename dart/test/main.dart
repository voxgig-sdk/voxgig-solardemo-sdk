// Solardemo SDK test suite entry. GENERATED — do not edit.

import 'dart:io';

import 'harness.dart' as harness;

import 'exists_test.dart' as exists_test;
import 'struct_test.dart' as struct_test;
import 'primary_test.dart' as primary_test;
import 'pipeline_test.dart' as pipeline_test;
import 'feature_test.dart' as feature_test;
import 'netsim_test.dart' as netsim_test;
import 'custom_test.dart' as custom_test;
import 'readme_examples_test.dart' as readme_examples_test;
import 'entity/moon/MoonEntity_test.dart' as moon_entity_test;
import 'entity/moon/MoonDirect_test.dart' as moon_direct_test;
import 'entity/planet/PlanetEntity_test.dart' as planet_entity_test;
import 'entity/planet/PlanetDirect_test.dart' as planet_direct_test;

Future<void> main() async {
  exists_test.tests();
  struct_test.tests();
  primary_test.tests();
  pipeline_test.tests();
  feature_test.tests();
  netsim_test.tests();
  custom_test.tests();
  readme_examples_test.tests();
  moon_entity_test.tests();
  moon_direct_test.tests();
  planet_entity_test.tests();
  planet_direct_test.tests();

  final failed = await harness.runAll();
  if (0 < failed) {
    exitCode = 1;
  }
}
