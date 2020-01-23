//
//  Food.swift
//  Fridge Tracker
//
//  Created by Nurin Izzati Jafri on 2020/01/19.
//  Copyright © 2020 Nurin Izzati Jafri. All rights reserved.
//

import UIKit

class Food {
    init?(name: String, photo: UIImage?, expirydate: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.expirydate = expirydate
        
    }
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var expirydate: String
    
    
}
