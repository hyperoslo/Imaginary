import UIKit
import Fakery

class ViewController: UITableViewController {

  struct ImageDimensions {
    static let width = 500
    static let height = 500
  }

  lazy var imaginaryArray: [NSURL] = {
    let faker = Faker()
    var array = [NSURL]()

    for i in 0..<20 {
      if let imageURL = NSURL(
        string: "http://lorempixel.com/\(ImageDimensions.width)/\(ImageDimensions.height)/?type=attachment&id=\(i)\(50)") {
        array.append(imageURL)
      }
    }

    return array
    }()

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.whiteColor()

    tableView.registerClass(FeedTableViewCell.self,
      forCellReuseIdentifier: FeedTableViewCell.reusableIdentifier)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .None
  }

  // MARK: - Setup tableView

  func setupTableView() {

  }
}

// MARK: - TableView Delegate

extension ViewController {

  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 250
  }
}

// MARK: - TableView DataSource

extension ViewController {

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return imaginaryArray.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier(
      FeedTableViewCell.reusableIdentifier) as? FeedTableViewCell else { return UITableViewCell() }

    cell.configureCell(UIImage())

    return cell
  }
}
