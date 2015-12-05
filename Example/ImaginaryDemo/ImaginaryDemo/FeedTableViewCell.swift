import UIKit

class FeedTableViewCell: UITableViewCell {

  static let reusableIdentifier = "FeedTableViewCell"

  lazy var generalImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .ScaleAspectFill
    imageView.backgroundColor = UIColor.whiteColor()
    imageView.clipsToBounds = true

    return imageView
    }()

  lazy var separator: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.whiteColor()

    return view
    }()

  // MARK: - Initializers

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    [generalImageView, separator].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.opaque = true
      $0.layer.drawsAsynchronously = true

      addSubview($0)
    }

    selectionStyle = .None

    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup

  func setupConstraints() {
    generalImageView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
    generalImageView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
    generalImageView.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
    generalImageView.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true

    separator.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
    separator.heightAnchor.constraintEqualToConstant(5).active = true
    separator.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
    separator.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
  }
}
