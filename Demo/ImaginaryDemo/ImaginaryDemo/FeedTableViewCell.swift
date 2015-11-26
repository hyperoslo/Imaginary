import UIKit

class FeedTableViewCell: UITableViewCell {

  lazy var generalImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = UIColor.blackColor()
    
    return imageView
    }()

  lazy var separator: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.whiteColor()

    return view
    }()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    [generalImageView, separator].forEach { addSubview($0) }

    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureCell(image: UIImage) {
    generalImageView.image = image
  }

  func setupConstraints() {
    generalImageView.topAnchor.constraintEqualToAnchor(topAnchor)
    generalImageView.bottomAnchor.constraintEqualToAnchor(separator.topAnchor)
    generalImageView.leftAnchor.constraintEqualToAnchor(leftAnchor)
    generalImageView.rightAnchor.constraintEqualToAnchor(rightAnchor)

    separator.widthAnchor.constraintEqualToAnchor(widthAnchor)
    separator.heightAnchor.constraintEqualToConstant(4)
    separator.leftAnchor.constraintEqualToAnchor(leftAnchor)
    separator.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
  }
}
