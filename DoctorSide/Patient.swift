//
//  Patient.swift
//  ParseStarterProject
//
//  Created by 农仕彪 on 15/7/27.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit
import Parse
class Patient {
    var name: String
    var textInfo: String
    var objectID: String
    // MARK: Initialization
    
    init?(name: String, textInfo: String, objectID: String) {
        // Initialize stored properties.
        self.name = name
        self.textInfo = textInfo
        self.objectID = objectID
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || textInfo.isEmpty {
            return nil
        }
    }

}
