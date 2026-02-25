import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct SegmentedControl<Option: Hashable & Identifiable>: View {

  @Binding private var selection: Option
  private let options: [Option]
  private let label: KeyPath<Option, String>
  private let selectionColor: Color
  private let backgroundColor: Color

  public init(
    selection: Binding<Option>,
    options: [Option],
    label: KeyPath<Option, String>,
    selectionColor: Color,
    backgroundColor: Color? = nil
  ) {
    self._selection = selection
    self.options = options
    self.label = label
    self.selectionColor = selectionColor
    self.backgroundColor = backgroundColor ?? selectionColor.opacity(0.5)
  }

  public var body: some View {
    #if os(iOS) || os(visionOS)
    if #available(iOS 26, visionOS 26, *) {
      Picker("", selection: $selection) {
        ForEach(options) { option in
          Text(option[keyPath: label])
            .font(.system(size: 5, weight: .semibold, design: .rounded))
            .tag(option)
        }
      }
      .pickerStyle(.segmented)
      .onAppear {
        UISegmentedControl.appearance().setTitleTextAttributes(
          [.font: UIFont.systemFont(ofSize: SegmentButton.segmentLabelFontSize, weight: .semibold)],
          for: .normal
        )
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(selectionColor)
        UISegmentedControl.appearance().backgroundColor = UIColor(backgroundColor)
      }
    } else {
      legacy
    }
    #else
    legacy
    #endif
  }
  
  var legacy: some View {
    LegacySegmentedControl(
      selection: $selection,
      options: options,
      label: label,
      selectionColor: selectionColor,
      backgroundColor: backgroundColor
    )
  }
}

private struct LegacySegmentedControl<Option: Hashable & Identifiable>: View {

  @Binding var selection: Option
  let options: [Option]
  let label: KeyPath<Option, String>
  let selectionColor: Color
  let backgroundColor: Color

  @State private var optionIsPressed: [Option.ID: Bool] = [:]

  @Namespace private var namespaceID
  private let buttonBackgroundID = "buttonBackgroundID"

  private let insets = EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
  private let interSegmentSpacing: CGFloat = 2
  private let animation: Animation = .bouncy

  var body: some View {
    HStack(spacing: interSegmentSpacing) {
      ForEach(Array(zip(options.indices, options)), id: \.1.id) { index, option in
        SegmentButton(
          label: option[keyPath: label],
          selectionColor: selectionColor,
          isSelected: selection == option,
          animation: animation,
          isPressed: .init(
            get: { optionIsPressed[option.id, default: false] },
            set: { optionIsPressed[option.id] = $0 }
          ),
          backgroundID: buttonBackgroundID,
          namespaceID: namespaceID,
          action: { selection = option }
        )
        .zIndex(selection == option ? 0 : 1)
      }
    }
    .padding(insets)
    .onAppear {
      optionIsPressed = Dictionary(uniqueKeysWithValues: options.lazy.map { ($0.id, false) })
    }
    .background(backgroundColor)
    .clipShape(RoundedRectangle(cornerRadius: 14))
  }
}

fileprivate struct SegmentButton: View {

  static let segmentLabelFontSize: CGFloat = 10
  
  let label: String
  let selectionColor: Color
  let isSelected: Bool
  let animation: Animation
  @Binding var isPressed: Bool
  let backgroundID: String
  let namespaceID: Namespace.ID
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      segmentLabel
        .blendMode(.difference)
        .overlay {
          segmentLabel
            .blendMode(.hue)
            .accessibilityHidden(true)
        }
        .overlay {
          segmentLabel
            .blendMode(.overlay)
            .accessibilityHidden(true)
        }
        .background {
          if isSelected {
            selectionColor
              .clipShape(RoundedRectangle(cornerRadius: 10))
              .transition(.offset())
              .matchedGeometryEffect(id: backgroundID, in: namespaceID)
          }
        }
        .animation(animation, value: isSelected)
    }
    .buttonStyle(SegmentPressStyle(isPressed: $isPressed))
    .accessibilityElement(children: .combine)
    .accessibilityAddTraits(isSelected ? .isSelected : [])
    .accessibilityRemoveTraits(isSelected ? [] : .isSelected)
  }

  private var segmentLabel: some View {
    Text(label)
      .font(.system(size: Self.segmentLabelFontSize, weight: .semibold, design: .rounded))
      .foregroundColor(isPressed ? .secondary : .primary)
      .lineLimit(1)
      .padding(.vertical, 4)
      .frame(maxWidth: .infinity)
  }
}

private struct SegmentPressStyle: ButtonStyle {

  @Binding var isPressed: Bool

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .contentShape(Rectangle())
      .onChange(of: configuration.isPressed) { newValue in
        isPressed = newValue
      }
  }
}
