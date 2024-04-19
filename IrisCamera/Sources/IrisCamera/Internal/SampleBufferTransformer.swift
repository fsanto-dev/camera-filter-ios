import AVKit
import CoreImage
import Foundation

struct SampleBufferTransformer {
    func transform(videoSampleBuffer: CMSampleBuffer) -> CMSampleBuffer {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(videoSampleBuffer) else {
            print("failed to get pixel buffer")
            fatalError()
        }

        let ciImage = CIImage(cvImageBuffer: pixelBuffer)
        let ciContext = CIContext()
        let invertColorFilter = CIFilter(name: "CIColorInvert")

        invertColorFilter?.setValue(ciImage, forKey: kCIInputImageKey)

        if let outputImage = invertColorFilter?.outputImage {
            ciContext.render(outputImage, to: pixelBuffer)
        }

        guard let result = try? pixelBuffer.mapToSampleBuffer(timestamp: videoSampleBuffer.presentationTimeStamp) else {
            fatalError()
        }

        return result
    }
}
