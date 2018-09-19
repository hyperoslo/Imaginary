import UIKit

class FeedTableViewCell: UITableViewCell {

  static let reusableIdentifier = "FeedTableViewCell"

  lazy var generalImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = UIColor.white
    imageView.clipsToBounds = true

    return imageView
    }()

  lazy var separator: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.white

    return view
    }()

  // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    [generalImageView, separator].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.isOpaque = true
      $0.layer.drawsAsynchronously = true

      addSubview($0)
    }

    selectionStyle = .none

    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup

  func setupConstraints() {
    generalImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    generalImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    generalImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    generalImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

    separator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    separator.heightAnchor.constraint(equalToConstant: 5).isActive = true
    separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
}
