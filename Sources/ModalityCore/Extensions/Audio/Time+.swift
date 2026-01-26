import AVFAudio

public extension AVAudioTime {
  
  func dateFromHostTime() -> Date {
    let seconds = AVAudioTime.seconds(forHostTime: hostTime)
    let bootTime = ProcessInfo.processInfo.systemUptime
    let startupDate = Date(timeIntervalSinceNow: -bootTime)
    return startupDate.addingTimeInterval(seconds)
  }
}

public extension DispatchWallTime {
  init(date: Date) {
    let interval = date.timeIntervalSince1970
    let seconds = Int(interval)
    let frac = interval - Double(seconds)
    let nanoseconds = Int(Double(NSEC_PER_SEC) * frac)
    
    let ts = timespec(tv_sec: seconds, tv_nsec: nanoseconds)
    self = DispatchWallTime(timespec: ts)
  }
  
  func timeIntervalSince(_ other: DispatchWallTime) -> TimeInterval {
    let selfNanos = self.rawValue
    let otherNanos = other.rawValue
    
    // rawValue is UInt64
    if selfNanos >= otherNanos {
      let diffNanos = selfNanos - otherNanos
      return TimeInterval(diffNanos) / TimeInterval(NSEC_PER_SEC)
    } else {
      let diffNanos = otherNanos - selfNanos
      return -TimeInterval(diffNanos) / TimeInterval(NSEC_PER_SEC)
    }
  }
}
