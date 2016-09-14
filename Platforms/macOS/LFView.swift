import Foundation
import AVFoundation

open class LFView: NSView {
    public static var defaultBackgroundColor:NSColor = NSColor.black

    public var videoGravity:String = AVLayerVideoGravityResizeAspect {
        didSet {
            layer?.setValue(videoGravity, forKey: "videoGravity")
        }
    }

    var position:AVCaptureDevicePosition = .front {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.frame = NSRect(x: 0, y: 0, width: self.frame.width - 0.1, height: self.frame.height - 0.1)
            }
        }
    }
    var orientation:AVCaptureVideoOrientation = .portrait

    private weak var currentStream:NetStream? {
        didSet {
            guard let oldValue:NetStream = oldValue else {
                return
            }
            oldValue.mixer.videoIO.drawable = nil
        }
    }

    override public init(frame: NSRect) {
        super.init(frame: frame)
        awakeFromNib()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open override func awakeFromNib() {
        wantsLayer = true
        layer = AVCaptureVideoPreviewLayer()
        layer?.backgroundColor = LFView.defaultBackgroundColor.cgColor
        layer?.setValue(videoGravity, forKey: "videoGravity")
    }

    public func attach(stream:NetStream?) {
        layer?.setValue(stream?.mixer.session, forKey: "session")
        stream?.mixer.videoIO.drawable = self
        currentStream = stream
    }
}

extension LFView: NetStreamDrawable {
    // MARK: NetStreamDrawable
    func render(image:CIImage, to toCVPixelBuffer:CVPixelBuffer) {
    }
    func draw(image:CIImage) {
    }
}
