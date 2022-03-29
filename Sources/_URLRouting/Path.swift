public struct Path<ComponentParsers: Parser<URLRequestData>>: Parser {
  @usableFromInline
  let componentParsers: ComponentParsers

  @inlinable
  public init(@PathBuilder build: () -> ComponentParsers) {
    self.componentParsers = build()
  }

  @inlinable
  public func parse(_ input: inout URLRequestData) rethrows -> ComponentParsers.Output {
    try self.componentParsers.parse(&input)
  }
}

extension Path: ParserPrinter where ComponentParsers: ParserPrinter {
  @inlinable
  public func print(_ output: ComponentParsers.Output, into input: inout URLRequestData) rethrows {
    try self.componentParsers.print(output, into: &input)
  }
}

public struct PathComponent<ComponentParser: Parser<Substring>>: Parser {
  @usableFromInline
  let componentParser: ComponentParser

  @usableFromInline
  init(_ componentParser: ComponentParser) {
    self.componentParser = componentParser
  }

  public func parse(_ input: inout URLRequestData) throws -> ComponentParser.Output {
    guard input.path.count >= 1 else { throw RoutingError() }
    return try Parse {
      self.componentParser
      End()
    }.parse(input.path.removeFirst())
  }
}

extension PathComponent: ParserPrinter where ComponentParser: ParserPrinter {
  public func print(_ output: ComponentParser.Output, into input: inout URLRequestData) rethrows {
    try input.path.prepend(self.componentParser.print(output))
  }
}
