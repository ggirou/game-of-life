import "packages/unittest/unittest.dart";
import "packages/unittest/mock.dart";

import "engine_test.dart" as engine_test;
import "generation_test.dart" as generation_test;

main() {
  engine_test.main();
  generation_test.main();
}