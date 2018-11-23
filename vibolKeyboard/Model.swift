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
    
    var word = [Character]()
    let realm = try! Realm()
//    var wordObjs: Results<Words>?
   
    init() {
//        wordObjs = realm.objects(Words.self)
    }
    
    
    func conbaineChar(char: Character){
        word.append(char)
    }
    
    func filterObj() -> Results<Words> {
        
        let words = realm.objects(Words.self).filter("word LIKE '*\(String(word))*'").sorted(byKeyPath: "frequency", ascending: false)
        
        return words
    }
    
    func updateFrequency(word: String){
        try! realm.write {
            for f in realm.objects(Words.self).filter("word = '\(word)'"){
                f.frequency += 1
            }
            
        }
    }
    
    func removeLastChar(){
        if word.count > 0 {
            word.remove(at: word.index(before: word.endIndex))
            
        }

    }
}
