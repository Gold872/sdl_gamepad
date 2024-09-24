/// Helpful methods on integers.
extension IntUtils on int {
  /// Returns null if this number matches the test value.
  int? nullIf(int test) => this == test ? null : this;
}
