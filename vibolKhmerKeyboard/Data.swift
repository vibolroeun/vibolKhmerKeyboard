//
//  Data.swift
//  vibolKeyboard
//
//  Created by Vibol's Macbook Pro on 11/18/18.
//  Copyright © 2018 Vibol Roeun. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}

class Words: Object {
    @objc dynamic var word: String = ""
    @objc dynamic var frequency: Int = 0
}



