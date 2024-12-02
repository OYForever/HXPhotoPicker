//
//  Core+AVAsset.swift
//  HXPhotoPicker
//
//  Created by Slience on 2023/1/12.
//

import UIKit
import AVFoundation

extension AVAsset {
    func getImage(at seconds: TimeInterval, isAccurate: Bool = false, videoComposition: AVVideoComposition? = nil) -> UIImage? {
        let generator = AVAssetImageGenerator(asset: self)
        
        // 基本设置
        generator.appliesPreferredTrackTransform = true
        generator.videoComposition = videoComposition
        generator.apertureMode = .encodedPixels
        
        // 设置时间精度
        if isAccurate {
            generator.requestedTimeToleranceBefore = .zero
            generator.requestedTimeToleranceAfter = .zero
        }
        
        // 创建时间点
        let time = CMTime(seconds: seconds, preferredTimescale: duration.timescale)
        
        do {
            let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            return nil
        }
    }
    func getImage(
        at time: TimeInterval,
        videoComposition: AVVideoComposition? = nil,
        imageGenerator: ((AVAssetImageGenerator) -> Void)? = nil,
        completion: @escaping (AVAsset, UIImage?, AVAssetImageGenerator.Result) -> Void
    ) {
        loadValuesAsynchronously(forKeys: ["duration"]) { [weak self] in
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(.init(), nil, .failed)
                }
                return
            }
            if self.statusOfValue(forKey: "duration", error: nil) != .loaded {
                DispatchQueue.main.async {
                    completion(self, nil, .failed)
                }
                return
            }
            let generator = AVAssetImageGenerator(asset: self)
            generator.appliesPreferredTrackTransform = true
            generator.videoComposition = videoComposition
            let time = CMTime(value: CMTimeValue(time), timescale: self.duration.timescale)
            let array = [NSValue(time: time)]
            generator.generateCGImagesAsynchronously(
                forTimes: array
            ) { (_, cgImage, _, result, _) in
                if let image = cgImage, result == .succeeded {
                    var image = UIImage(cgImage: image)
                    if image.imageOrientation != .up,
                       let img = image.normalizedImage() {
                        image = img
                    }
                    DispatchQueue.main.async {
                        completion(self, image, result)
                    }
                }else {
                    DispatchQueue.main.async {
                        completion(self, nil, result)
                    }
                }
            }
            DispatchQueue.main.async {
                imageGenerator?(generator)
            }
        }
    }
}
