import Cocoa
import Imaginary

class ViewController: NSViewController {

  @IBOutlet weak var collectionView: NSCollectionView!

  lazy var values: [URL] = { [unowned self] in
    var array = [URL]()

    for i in 0..<500 {
      if let imageURL = URL(
        string: "https://placeimg.com/640/480/\(i)") {
        array.append(imageURL)
      }
    }

    return array
    }()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupCollectionView()
  }

  func setupCollectionView() {
    view.wantsLayer = true

    let layout = NSCollectionViewFlowLayout()
    layout.itemSize = NSSize(width: 300.0, height: 150.0)
    layout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
    layout.minimumInteritemSpacing = 4.0
    layout.minimumLineSpacing = 4.0
    collectionView.collectionViewLayout = layout

    collectionView.layer?.backgroundColor = NSColor.black.cgColor
    collectionView.register(NSNib(nibNamed: "Cell", bundle: nil)!,
                            forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell"))
  }
}

extension ViewController: NSCollectionViewDataSource {

  func numberOfSections(in collectionView: NSCollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return values.count
  }

  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {

    let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell"), for: indexPath)
    guard let cell = item as? Cell else { return item }

    let value = values[(indexPath as NSIndexPath).item]
    cell.imageView?.setImage(url: value, placeholder: Image(named:"placeholder"))

    return cell
  }

}
