//
//  Info.swift
//  TonesOfMisery
//
//  Created by Ramsey Shafi on 9/11/16.
//
//

import Foundation

class Info: CCNode {

    func backToHome() {
        let scene = CCBReader.load(asScene: "MainScene")
        CCDirector.shared().present(scene)
    }
}
