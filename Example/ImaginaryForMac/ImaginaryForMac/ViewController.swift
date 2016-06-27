import Cocoa
import Imaginary

class ViewController: NSViewController {

  @IBOutlet weak var collectionView: NSCollectionView!

  lazy var values: [NSURL] = { [unowned self] in
    var array = [NSURL]()

    for i in 0..<500 {
      if let imageURL = NSURL(
        string: "https://unsplash.it/600/300/?image=\(i)") {
        array.append(imageURL)
      }
    }

    return array
    }()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupCollectionView()
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }


  func setupCollectionView() {
    view.wantsLayer = true

    let layout = NSCollectionViewFlowLayout()
    layout.itemSize = NSSize(width: 300.0, height: 150.0)
    layout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
    layout.minimumInteritemSpacing = 4.0
    layout.minimumLineSpacing = 4.0
    collectionView.collectionViewLayout = layout

    collectionView.layer?.backgroundColor = NSColor.blackColor().CGColor

    collectionView.registerNib(NSNib(nibNamed: "Cell", bundle: nil), forItemWithIdentifier: "Cell")
  }
}

extension ViewController: NSCollectionViewDataSource {

  func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
    return 1
  }

  func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return values.count
  }

  func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {

    let item = collectionView.makeItemWithIdentifier("Cell", forIndexPath: indexPath)
    guard let cell = item as? Cell else { return item }

    let value = values[indexPath.item]
    cell.imageView?.setImage(value, placeholder: Image(named: "placeholder"))

    return cell
  }

}
