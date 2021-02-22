//
//  JoeyTextLayer.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/3/20.
//

import UIKit

class JoeyTextLayer: CATextLayer {

    override func draw(in context: CGContext) {
        let height = self.bounds.size.height
        let fontSize = self.fontSize
        let yDiff = (height-fontSize)/2 - fontSize/10

        context.saveGState()
        context.translateBy(x: 0, y: yDiff)
        super.draw(in: context)
        context.restoreGState()
    }
}
