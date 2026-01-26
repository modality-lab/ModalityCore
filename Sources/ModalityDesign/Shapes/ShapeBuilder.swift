import SwiftUI

@resultBuilder
@MainActor
public enum ShapeBuilder {
  public static func buildBlock<S: Shape>(_ builder: S) -> some Shape {
    builder
  }
}

public extension ShapeBuilder {
  static func buildOptional<S: Shape>(_ component: S?) -> EitherShape<S, EmptyShape> {
    component.flatMap(EitherShape.first) ?? EitherShape.second(EmptyShape())
  }

  static func buildEither<First: Shape, Second: Shape>(first component: First) -> EitherShape<First, Second> {
    .first(component)
  }

  static func buildEither<First: Shape, Second: Shape>(second component: Second) -> EitherShape<First, Second> {
    .second(component)
  }
}
