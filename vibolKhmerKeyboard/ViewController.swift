//
//  ViewController.swift
//  vibolKhmerKeyboard
//
//  Created by Vibol's Macbook Pro on 9/3/18.
//  Copyright © 2018 Vibol Roeun. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    let realm = try! Realm()
    var todoItems: Results<Data>?
    
    @IBOutlet weak var testText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        testText.becomeFirstResponder()

        
        //insertData()
        //loadData()
    }

//    func insertData(){
//        let data = Data()
//        data.name = "virak roeun"
//        data.age = 10
//        
//        do {
//            
//            try realm.write {
//                realm.add(data)
//            }
//            
//        }catch{
//            print("Error initiazing new Realm \(error)")
//        }
//    }
    
    func loadData(){
        todoItems = realm.objects(Data.self)
        print("Containing App \(String(describing: todoItems?.count))")
    }

}

