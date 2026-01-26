import Foundation
import os

public extension UserDefaults {
  func set<C: Encodable>(codable: C, forKey key: String) {
    do {
      let encoded = try JSONEncoder().encode(codable)
      set(encoded, forKey: key)
    } catch {
      Logger.userDefaults.error("EncodeError \(error)")
    }
  }

  func decode<T: Decodable>(_ type: T.Type = T.self, forKey key: String) -> T? {
    if let savedData = object(forKey: key) {

      do {
        guard let data = savedData as? Data else { return nil }
        let decoded = try JSONDecoder().decode(type, from: data)
        return decoded
      } catch {
        Logger.userDefaults.error("DecodeError \(error)")
        return nil
      }
    } else {
      return nil
    }
  }
}

public extension Logger {
  static let userDefaults = Logger(category: "UserDefaults")
}
