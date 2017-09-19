import UIKit
import Imaginary

class ViewController: UITableViewController {

  struct Constants {
    static let imageWidth = 500
    static let imageHeight = 500
    static let imageNumber = 400
  }

  lazy var imaginaryArray: [URL] = { [unowned self] in
    var array = [URL]()

    for i in 0..<Constants.imageNumber {
      if let imageURL = URL(
        string: "https://placeimg.com/640/480/any/\(i)") {
            array.append(imageURL)
      }
    }

    return array
    }()

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.white

    setupTableView()
  }

  // MARK: - Setup tableView

  func setupTableView() {
    tableView.register(FeedTableViewCell.self,
      forCellReuseIdentifier: FeedTableViewCell.reusableIdentifier)
    tableView.separatorStyle = .none
  }
}

// MARK: - TableView Delegate

extension ViewController {

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 250
  }
}

// MARK: - TableView DataSource

extension ViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return imaginaryArray.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: FeedTableViewCell.reusableIdentifier) as? FeedTableViewCell else { return UITableViewCell() }

    cell.generalImageView.setImage(
      url: imaginaryArray[indexPath.row],
      placeholder: UIImage(named: "placeholder"))

    return cell
  }
}
