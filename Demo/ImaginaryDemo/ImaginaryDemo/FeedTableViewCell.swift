import UIKit

class FeedTableViewCell: UITableViewCell {

  static let reusableIdentifier = "FeedTableViewCell"

  lazy var generalImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = UIColor.blackColor()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
    }()

  lazy var separator: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.whiteColor()
    view.translatesAutoresizingMaskIntoConstraints = false

    return view
    }()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    [generalImageView, separator].forEach { addSubview($0) }

    selectionStyle = .None

    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureCell(image: UIImage) {
    generalImageView.image = image
  }

  func setupConstraints() {
    generalImageView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
    generalImageView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
    generalImageView.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
    generalImageView.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true

    separator.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
    separator.heightAnchor.constraintEqualToConstant(4).active = true
    separator.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
    separator.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
  }
}
