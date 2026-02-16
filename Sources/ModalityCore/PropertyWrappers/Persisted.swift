import Combine
import Foundation
import Dispatch


@propertyWrapper
public struct Persisted<Value> {
  private let key: String
  private let defaultValue: Value
  private let debounceInterval: TimeInterval?
  private var value: Value
  private var debounceWorkItem: DispatchWorkItem?
  private let subject: CurrentValueSubject<Value, Never>

  private let read: (String) -> Value?
  private let write: (Value, String) -> Void

  public var wrappedValue: Value {
    get { value }
    set { value = newValue }
  }

  public var projectedValue: CurrentValueSubject<Value, Never> {
    subject
  }

  public static subscript<T: ObservableObject>(
    _enclosingInstance instance: T,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, Value>,
    storage storageKeyPath: ReferenceWritableKeyPath<T, Persisted<Value>>
  ) -> Value {
    get {
      instance[keyPath: storageKeyPath].value
    }
    set {
      if let publisher = instance.objectWillChange as? ObservableObjectPublisher {
        publisher.send()
      }
      var wrapper = instance[keyPath: storageKeyPath]
      wrapper.value = newValue
      wrapper.subject.send(newValue)
      wrapper.persistValue(newValue)
      instance[keyPath: storageKeyPath] = wrapper
    }
  }

  private mutating func persistValue(_ newValue: Value) {
    if let interval = debounceInterval {
      debounceWorkItem?.cancel()
      let key = self.key
      let write = self.write
      let workItem = DispatchWorkItem {
        write(newValue, key)
      }
      debounceWorkItem = workItem
      DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + interval, execute: workItem)
    } else {
      write(newValue, key)
    }
  }
}

extension Persisted {
  public init(key: String, defaultValue: Value, debounce: TimeInterval? = nil) {
    self.key = key
    self.defaultValue = defaultValue
    self.debounceInterval = debounce
    self.read = { UserDefaults.standard.object(forKey: $0) as? Value }
    self.write = { UserDefaults.standard.set($0, forKey: $1) }
    let initial = UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
    self.value = initial
    self.subject = CurrentValueSubject(initial)
  }
}

extension Persisted where Value: Codable {
  public init(codableKey key: String, defaultValue: Value, debounce: TimeInterval? = nil) {
    self.key = key
    self.defaultValue = defaultValue
    self.debounceInterval = debounce
    self.read = { key in
      guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
      return try? JSONDecoder().decode(Value.self, from: data)
    }
    self.write = { value, key in
      if let data = try? JSONEncoder().encode(value) {
        UserDefaults.standard.set(data, forKey: key)
      }
    }
    let initial: Value = {
      guard let data = UserDefaults.standard.data(forKey: key),
            let decoded = try? JSONDecoder().decode(Value.self, from: data) else { return defaultValue }
      return decoded
    }()
    self.value = initial
    self.subject = CurrentValueSubject(initial)
  }
}

extension Persisted where Value: RawRepresentable, Value.RawValue == String {
  public init(key: String, defaultValue: Value, debounce: TimeInterval? = nil) {
    self.key = key
    self.defaultValue = defaultValue
    self.debounceInterval = debounce
    self.read = { key in
      guard let raw = UserDefaults.standard.string(forKey: key) else { return nil }
      return Value(rawValue: raw)
    }
    self.write = { value, key in
      UserDefaults.standard.set(value.rawValue, forKey: key)
    }
    let initial: Value = {
      guard let raw = UserDefaults.standard.string(forKey: key) else { return defaultValue }
      return Value(rawValue: raw) ?? defaultValue
    }()
    self.value = initial
    self.subject = CurrentValueSubject(initial)
  }
}
