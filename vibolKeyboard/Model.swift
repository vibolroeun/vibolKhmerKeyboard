//
//  KeysGesture.swift
//  vibolKhmerKeyboard
//
//  Created by Vibol's Macbook Pro on 11/21/18.
//  Copyright © 2018 Vibol Roeun. All rights reserved.
//

import Foundation
import RealmSwift

class Model {
    
    var word: String = ""
    let realm = try! Realm()
    var wordObjs: Results<Data>?
   
    init() {
        wordObjs = realm.objects(Data.self)
    }
    
    
    func conbaineChar(char: String){
        word = word + char
    }
    
    func filterObj() -> Results<Data> {
        let words = wordObjs?.filter("name LIKE '*\(word)*'")
        
        return words!
    }
    
    func removeLastChar(){
        if word.count > 0 {
            word.remove(at: word.index(before: word.endIndex))
        }

    }
}
