import CoreGraphics

extension CGSize {
  public static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
    CGSize(
      width: lhs.width - rhs.width,
      height: lhs.height - rhs.height
    )
  }
  
  public static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
    CGSize(
      width: lhs.width * rhs,
      height: lhs.height * rhs
    )
  }
}

