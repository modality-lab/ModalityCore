import Combine
import Observation

extension KeyPath: @unchecked @retroactive Sendable where Root: Sendable, Value: Sendable {}

@available(iOS 17.0, macOS 14.0, visionOS 1.0, *)
public extension Observable where Self: AnyObject & Sendable {
  
  @MainActor
  func observe<Value: Sendable>(
    initSetupNeeded: Bool = true,
    _ keyPath: KeyPath<Self, Value>,
    onChange: @MainActor @escaping (Value) -> Void
  ) {
    if initSetupNeeded {
      onChange(self[keyPath: keyPath])
    }
    
    withContinuousObservation(keyPath, onChange: onChange)
  }
  
  func withContinuousObservation<Value: Sendable>(
    _ keyPath: KeyPath<Self, Value>,
    onChange: @MainActor @escaping (Value) -> Void
  ) {
    withObservationTracking {
      let _ = self[keyPath: keyPath]
    } onChange: { [weak self] in
      guard let self else { return }
      
      Task { @MainActor in
        onChange(self[keyPath: keyPath])
        
        self.withContinuousObservation(keyPath, onChange: onChange)
      }
    }
  }
  
  @MainActor
  func bind<Value: Sendable>(
    _ keyPath: KeyPath<Self, Value>,
    to subject: CurrentValueSubject<Value, Never>
  ) {
    withContinuousObservation(keyPath) { subject.send($0) }
  }
  
  @MainActor
  func subjectObserving<Value: Sendable>(
    _ keyPath: KeyPath<Self, Value>
  ) -> CurrentValueSubject<Value, Never> {
    let subject = CurrentValueSubject<Value, Never>(self[keyPath: keyPath])
    bind(keyPath, to: subject)
    return subject
  }
}
