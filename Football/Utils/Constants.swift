//
//  Constants.swift
//  DriverApp
//
//  Created by NEW MAC on 01/08/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import Foundation
import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseUsers = databaseRoot.child("users")
    }
}
