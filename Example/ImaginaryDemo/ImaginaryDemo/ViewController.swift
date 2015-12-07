import UIKit
import Fakery
import Imaginary

class ViewController: UITableViewController {

  struct Constants {
    static let imageWidth = 500
    static let imageHeight = 500
    static let imageNumber = 400
  }

  lazy var imaginaryArray: [NSURL] = { [unowned self] in
    let faker = Faker()
    var array = [NSURL]()

    for i in 0..<Constants.imageNumber {
      if let imageURL = NSURL(
        string: faker.internet.image(width: Constants.imageWidth, height: Constants.imageHeight)
          + "?type=attachment&id=(\(i))(50)") {
            array.append(imageURL)
      }
    }

    return array
    }()

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.whiteColor()

    setupTableView()
  }

  // MARK: - Setup tableView

  func setupTableView() {
    tableView.registerClass(FeedTableViewCell.self,
      forCellReuseIdentifier: FeedTableViewCell.reusableIdentifier)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .None
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

    cell.generalImageView.setImage(imaginaryArray[indexPath.row])

    return cell
  }
}
