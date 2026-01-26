import Foundation

public extension FileManager {
  func findFiles(in directory: URL, type: String) -> [URL] {
    guard let enumerator = enumerator(
      at: directory,
      includingPropertiesForKeys: [.isRegularFileKey],
      options: []
    ) else { return [] }
    
    var files: [URL] = []
    for case let fileURL as URL in enumerator where fileURL.pathExtension == type {
      files.append(fileURL)
    }
    return files
  }
}
