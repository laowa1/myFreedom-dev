//
//  UIImage+extensions.swift
//  MyFreedom
//
//  Created by m1pro on 08.04.2022.
//

import UIKit

extension UIImage {

    func fitted(in size: CGSize) -> UIImage {
        let newSize: CGSize
        let aspectRatio = self.size.width / self.size.height

        if aspectRatio < 1 {
            let width = size.height * aspectRatio
            if width > size.width {
                let newHeight = size.width / aspectRatio
                newSize = CGSize(width: size.width, height: newHeight)
            } else {
                newSize = CGSize(width: width, height: size.height)
            }
        } else {
            let height = size.width / aspectRatio
            if height > size.height {
                let newWidth = size.height * aspectRatio
                newSize = CGSize(width: newWidth, height: size.height)
            } else {
                newSize = CGSize(width: size.width, height: height)
            }
        }

        return resized(to: newSize)
    }

    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }

    func centered(in size: CGSize) -> UIImage {
        if size.width < self.size.width || size.height < self.size.height {
            return fitThenCenter(in: size)
        }

        return UIGraphicsImageRenderer(size: size).image { _ in
            let origin = CGPoint(x: (size.width - self.size.width) / 2, y: (size.height - self.size.height) / 2)
            draw(at: origin)
        }
    }

    func fitThenCenter(in size: CGSize) -> UIImage {
        return fitted(in: size).centered(in: size)
    }
}
