//
//  ResourceHelper.swift
//  BurnerSDK
//
//  Created by Burner on 11/15/18.
//  Copyright © 2018 Burner. All rights reserved.
//

import Foundation

class Resource {
    func bundle() -> Bundle {
        let bundleURL = Bundle(for: type(of: self)).url(forResource: "Resources", withExtension: "bundle")
        return Bundle(url: bundleURL!)!
    }
}
