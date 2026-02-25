import Foundation
import SwiftUI

public struct Ring<Containing: Equatable & Hashable>: Identifiable, Equatable, Hashable {

  public let id: String

  public let wedges: [Wedge]

  public var innerRadius: CGFloat
  public let height: CGFloat
  
  public let yShift: CGFloat
  public let scale: CGFloat
  public let aspectRatio: CGFloat
      
  public var outerRadius: CGFloat { innerRadius + height }

  public init(
    id: String,
    wedges: [Wedge],
    innerRadius: CGFloat,
    height: CGFloat,
    yShift: CGFloat = 0,
    scale: CGFloat = 1,
    aspectRatio: CGFloat = 1
  ) {
    self.id = id
    self.wedges = wedges
    self.innerRadius = innerRadius
    self.height = height
    self.yShift = yShift
    self.scale = scale
    self.aspectRatio = aspectRatio
  }
}

extension Ring: Animatable {
  
  public var animatableData: CGFloat {
    get { innerRadius }
    set { innerRadius = newValue }
  }
}
