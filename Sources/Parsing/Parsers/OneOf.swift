/// A parser that attempts to run a number of parsers till one succeeds.
///
/// ```swift
/// enum Currency { case eur, gbp, usd }
///
/// let currency = OneOf {
///   "€".map { Currency.eur }
///   "£".map { Currency.gbp }
///   "$".map { Currency.usd }
/// }
/// ```
///
/// If you are optionally parsing input that should coalesce into some default, you can skip the
/// optionality and instead use ``OneOf`` and ``replaceError(with:)``:
///
/// ```swift
/// enum Currency { case eur, gbp, usd, unknown }
///
/// let currency = OneOf {
///   "€".map { Currency.eur }
///   "£".map { Currency.gbp }
///   "$".map { Currency.usd }
/// }
/// .replaceError(with: Currency.unknown)
/// ```
public struct OneOf<Parsers>: Parser where Parsers: Parser {
  public let parsers: Parsers

  @inlinable
  public init(@OneOfBuilder _ build: () -> Parsers) {
    self.parsers = build()
  }

  @inlinable
  public func parse(_ input: inout Parsers.Input) rethrows -> Parsers.Output {
    try self.parsers.parse(&input)
  }
}
