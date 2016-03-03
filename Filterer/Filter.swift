//
//  Filter.swift
//  Filterer
//
//  Created by alberto pasca on 09/02/16.
//  Copyright © 2015 Coursera. All rights reserved.
//

import UIKit

class Filter
{
    var value : Int
    var filterType : Filters = Filters.None


    // +---------------------------------------------------------------------------+
    //MARK: - Init
    // +---------------------------------------------------------------------------+


    init(){
        self.value      = 0
        self.filterType = .None
    }

    init( defaultValue val : Int, filterType : Filters ) {
        self.value      = val
        self.filterType = filterType
    }


    // +---------------------------------------------------------------------------+
    //MARK: - Core
    // +---------------------------------------------------------------------------+

    /**
    Apply a defined filter

    - parameter sourceImage: The source UIImage to filter
    - parameter filter:      The Filter type

    - returns: returns an UIImage filtered
    */
    static func applyFilter(sourceImage : UIImage!, filter : Filter) -> UIImage! {
        let pImage = RGBAImage(image: sourceImage)!
        var index  = 0

        for y in 0..<pImage.height {
            for x in 0..<pImage.width {
                index = y * pImage.width + x
                var pixel = pImage.pixels[index]

                switch filter.filterType {
                case .Red:
                    // Red filter
                    pixel.red = UInt8(max(0, min(255, filter.value)))
                    break
                case .Green:
                    // Green filter
                    pixel.green = UInt8(max(0, min(255, filter.value)))
                    break
                case .Blue:
                    // Blue filter
                    pixel.blue = UInt8(max(0, min(255, filter.value)))
                    break
                case .Yellow:
                    // Yellow filter
                    pixel.red   = UInt8(max(0, min(255, filter.value)))
                    pixel.green = UInt8(max(0, min(255, filter.value)))
                    break
                case .Purple:
                    // Purple filter
                    pixel.red  = UInt8(max(0, min(255, filter.value)))
                    pixel.blue = UInt8(max(0, min(255, filter.value)))
                    break
                case .Orange:
                    // Orange filter
                    pixel.red   = UInt8(max(0, min(255, filter.value)))
                    pixel.green = UInt8(max(0, min(165, filter.value)))
                    break
                case .Nigth:
                    // Darken filter
                    pixel.red   = UInt8(max(0, min(0, filter.value)))
                    pixel.green = UInt8(max(0, min(0, filter.value)))
                    break
                case .Invert:
                    // Color invert filter
                    pixel.red   = UInt8(max(0, min(255, Double(filter.value) - Double(pixel.red))))
                    pixel.green = UInt8(max(0, min(255, Double(filter.value) - Double(pixel.green))))
                    pixel.blue  = UInt8(max(0, min(255, Double(filter.value) - Double(pixel.blue))))
                    break;
                case .Sepia:
                    // Sepia tone filter
                    pixel.red   = UInt8(max(0, min(255, Double(filter.value) * 0.393 + Double(pixel.green) * 0.769 + Double(pixel.blue) * 0.189)))
                    pixel.green = UInt8(max(0, min(255, Double(pixel.red) * 0.349 + Double(filter.value) * 0.686 + Double(pixel.blue) * 0.168)))
                    pixel.blue  = UInt8(max(0, min(255, Double(pixel.red) * 0.272 + Double(pixel.green) * 0.534 + Double(filter.value) * 0.131)))
                    break;
                case .Gray:
                    // Grayscale filter
                    let color = UInt8(max(0, min(255, Double(pixel.red) * 0.2126 + Double(pixel.green) * 0.7152 + Double(pixel.blue) * 0.0722)))
                    pixel.red   = UInt8(max(0, min(Int(color), filter.value)))
                    pixel.green = UInt8(max(0, min(Int(color), filter.value)))
                    pixel.blue  = UInt8(max(0, min(Int(color), filter.value)))
                    break
                default:
                    break
                }

                pImage.pixels[index] = pixel
            }
        }

        return pImage.toUIImage()
    }

}
