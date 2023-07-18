//
//  Extensions.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 17/07/23.
//

import Foundation
import UIKit

extension UIImage {
    var base64: String? {
        guard let imageData = self.pngData() else {
            return nil
        }
        return imageData.base64EncodedString()
    }
}

extension String {

    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
