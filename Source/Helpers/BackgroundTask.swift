import Foundation

class BackgroundTask {

  private var block: dispatch_block_t

  init(processing: () -> Void) {
    block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) {
      processing()
    }
  }

  func start() -> BackgroundTask {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), block)
    return self
  }

  func cancel() {
    dispatch_block_cancel(block)
  }
}
