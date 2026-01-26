import AudioToolbox
import os

public extension AudioUnit {
  var sampleRate: Double {
    get throws {
      var sampleRate: Double = 44100
      var size: UInt32 = UInt32(MemoryLayout.size(ofValue: sampleRate))
      
      let result = AudioUnitGetProperty(
        self,
        kAudioUnitProperty_SampleRate,
        kAudioUnitScope_Input,
        0,
        &sampleRate,
        &size
      )
      
      if result != noErr {
        throw "Couldn't get input device sample rate. Error code: \(result)".error
      }
      
      return sampleRate
    }
  }
}
