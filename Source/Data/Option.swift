import Foundation

public struct Option: OptionSetType {

  public let rawValue: Int

  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

  // Delay the setting of the placeholder until the image fetching completes
  static let DelayPlaceholder = Option(rawValue: 1)
}
