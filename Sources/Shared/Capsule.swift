import Foundation

class Capsule: NSObject {

  static var ObjectKey = 0
  let concept: Any

  init(concept: Any) {
    self.concept = concept
  }
}
