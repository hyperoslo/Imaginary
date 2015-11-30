import Foundation

class Capsule : NSObject {

  static var ObjectKey = 0
  let value: Any

  init(value: Any) {
    self.value = value
  }
}
