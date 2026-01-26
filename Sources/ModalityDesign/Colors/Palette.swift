import SwiftUI
 
// TODO: Put things in order
extension Color {
  public static let cursorColor = Color(hue: 0.1, saturation: 0.8, brightness: 1)
  public static let primaryPurple = Color(hue: 0.732, saturation: 0.716, brightness: 0.851)
  
  public static let secondaryPurple = Color(hue: 0.732, saturation: 0.55,  brightness: 0.45)
  
  public static let backgroundColor = Color(hue: 0.222, saturation: 0.10, brightness: 0.07)
  public static let graphicsBackgroundColor = Color(hue: 0.222, saturation: 0.10, brightness: 0.04115)
  public static let controlBackgroundColor = Color(0x151515)
  
  public static let veryDarkDesaturatedBlue = Color(0x1f2937)
  public static let cardsBackgroundColor = Color(0x202020)
  
  private static let ebony = Color(hue: 0.0, saturation: 0.0,  brightness: 0.1)

  fileprivate static let mintCream = Color(0xF5FFFA)
  fileprivate static let vermilion = Color(0xE34234)
  
  public static let correctNote = Color(red: 60 / 255,  green: 220 / 255, blue: 70 / 255)
  public static let lateNote =    Color(red: 235 / 255, green: 215 / 255, blue: 10 / 255)
  public static let earlyNote =   Color(red: 255 / 255, green: 159 / 255, blue: 50 / 255)
  public static let missedNote =  Color(red: 230 / 255, green: 60 / 255,  blue: 60 / 255)
}

public enum TextColors {
//  public static let primary = Color.mintCream.opacity(0.9)
//  public static let secondary = Color.gray.opacity(0.7)
//  public static let disabled = Color.mintCream.opacity(0.1)
//  
//  public static let chartAxis = primary
//  public static let chartLegend = secondary
//  public static let chartLabels = secondary
}

public enum PrimaryColors {
  
}

public enum AccentColors {
  
}

public enum SemanticColors {
  
}

public enum VioletPalette {
  // Base
  public static let bg              = Color(hue: 0.222, saturation: 0.10, brightness: 0.07)

  // Core violet (keep your electric vibe)
  public static let primary         = Color(hue: 0.722, saturation: 0.90, brightness: 0.95)
  public static let primaryDeep     = Color(hue: 0.722, saturation: 1.00, brightness: 0.70)

  // VIOLET FAMILY — expanded (cool → warm)
  public static let blueViolet      = Color(hue: 0.660, saturation: 0.85, brightness: 0.88)
  public static let indigoViolet    = Color(hue: 0.675, saturation: 0.80, brightness: 0.72)
  public static let periwinkle      = Color(hue: 0.670, saturation: 0.28, brightness: 0.96)
  public static let lavender        = Color(hue: 0.730, saturation: 0.25, brightness: 0.96)
  public static let lilac           = Color(hue: 0.745, saturation: 0.35, brightness: 0.92)
  public static let amethyst        = Color(hue: 0.735, saturation: 0.55, brightness: 0.86)
  public static let ultraviolet     = Color(hue: 0.770, saturation: 0.78, brightness: 0.90)
  public static let neonUltraviolet = Color(hue: 0.770, saturation: 1.00, brightness: 1.00)
  public static let magentaViolet   = Color(hue: 0.820, saturation: 0.85, brightness: 0.88)
  public static let redViolet       = Color(hue: 0.860, saturation: 0.70, brightness: 0.78)

  // Deep/dark violets for backgrounds & pressed states
  public static let eggplant        = Color(hue: 0.780, saturation: 0.55, brightness: 0.40)
  public static let plum            = Color(hue: 0.805, saturation: 0.50, brightness: 0.52)
  public static let grape           = Color(hue: 0.760, saturation: 0.65, brightness: 0.45)
  public static let noirViolet      = Color(hue: 0.740, saturation: 0.50, brightness: 0.28)

  // Tints for states (hover/focus/disabled)
  public static let violetTintLo    = Color(hue: 0.722, saturation: 0.25, brightness: 0.98)
  public static let violetTintMd    = Color(hue: 0.722, saturation: 0.40, brightness: 0.93)
  public static let violetTintHi    = Color(hue: 0.722, saturation: 0.65, brightness: 0.88)

  // Semantic mapped into violet family (aggressive but cohesive)
  public static let infoViolet      = Color(hue: 0.690, saturation: 0.70, brightness: 0.90) // cooler side
  public static let successViolet   = Color(hue: 0.740, saturation: 0.55, brightness: 0.88) // softer green-less success
  public static let warningViolet   = Color(hue: 0.800, saturation: 0.85, brightness: 0.90) // warm violet
  public static let errorViolet     = Color(hue: 0.860, saturation: 0.95, brightness: 0.85) // red-violet punch

  // Text & surfaces tuned for bg
  public static let textHigh        = Color(hue: 0.16,  saturation: 0.05, brightness: 0.98)
  public static let textLow         = Color(hue: 0.16,  saturation: 0.05, brightness: 0.68)
  public static let surface         = Color(hue: 0.22,  saturation: 0.18, brightness: 0.12)
  public static let surfaceHi       = Color(hue: 0.22,  saturation: 0.22, brightness: 0.16)
  public static let border          = Color(hue: 0.16,  saturation: 0.05, brightness: 0.22)

  // Glow utilities (shadows/outer glows)
  public static let glowViolet      = Color(hue: 0.722, saturation: 1.00, brightness: 1.00)
  public static let glowUltra       = Color(hue: 0.770, saturation: 1.00, brightness: 1.00)

  // A compact ramp (dark → light) for charts/heatmaps
  public static let violetRamp: [Color] = [
    noirViolet,
    grape,
    plum,
    eggplant,
    indigoViolet,
    amethyst,
    lilac,
    lavender,
    periwinkle,
    violetTintLo
  ]
}
