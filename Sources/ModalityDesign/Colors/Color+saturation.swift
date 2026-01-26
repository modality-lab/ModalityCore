import SwiftUI

extension Color {
  public func saturation(_ amount: Double) -> Color {
    let saturation = max(0, min(1, amount))
    if saturation == 1 {
      return self
    }
    let (r, g, b, a) = components
    let maxVal = max(r, g, b)
    let minVal = min(r, g, b)
    let delta = maxVal - minVal
    let v = maxVal
    if saturation == 0 {
      return Color(red: v, green: v, blue: v, opacity: a)
    }
    if delta == 0 {
      return self
    }
    var h: CGFloat = 0
    if maxVal == r {
      h = (g - b) / delta + (g < b ? 6 : 0)
    } else if maxVal == g {
      h = (b - r) / delta + 2
    } else {
      h = (r - g) / delta + 4
    }
    h /= 6
    let hh = h * 6
    let i = floor(hh)
    let f = hh - i
    let p = v * (1 - saturation)
    let q = v * (1 - f * saturation)
    let t = v * (1 - (1 - f) * saturation)
    var newR: CGFloat = 0
    var newG: CGFloat = 0
    var newB: CGFloat = 0
    switch i {
    case 0:
      newR = v
      newG = t
      newB = p
    case 1:
      newR = q
      newG = v
      newB = p
    case 2:
      newR = p
      newG = v
      newB = t
    case 3:
      newR = p
      newG = q
      newB = v
    case 4:
      newR = t
      newG = p
      newB = v
    case 5:
      newR = v
      newG = p
      newB = q
    default:
      break
    }
    return Color(red: Double(newR), green: Double(newG), blue: Double(newB), opacity: Double(a))
  }
}
