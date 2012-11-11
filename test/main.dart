import "game_of_life_test.dart";

import "packages/unittest/unittest.dart";
import "packages/unittest/mock.dart";

main() {
  group("Generation tests", () => generationTests.forEach(test));
  group("Engine tests", () => engineTests.forEach(test));
}