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
    
    var word = [String]()
    let realm = try! Realm()

   
    init() {

    }
    
    
    func conbaineChar(char: String){
        word.append(char)
        print(word)
    }
    
    func filterObj() -> Results<Words> {
        
        let words = realm.objects(Words.self).filter("word LIKE '*\(word.joined())*'").sorted(byKeyPath: "frequency", ascending: false)
        
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
            print(word)
        }

    }
}
