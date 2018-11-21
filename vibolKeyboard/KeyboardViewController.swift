//
//  KeyboardViewController.swift
//  vibolKeyboard
//
//  Created by Vibol's Macbook Pro on 9/3/18.
//  Copyright © 2018 Vibol Roeun. All rights reserved.
//

import UIKit
import RealmSwift

class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var wordButtons: [UIButton]!
    @IBOutlet var nextKeyboardButton: UIButton!
    var proxy: UITextDocumentProxy!
    var keyboardView: UIView!
    
    var word: String = ""
    let realm = try! Realm()
    var todoItems: Results<Data>?

    let primaryUpKeys = ["ឈ", "ឹ", "ែ", "ឬ", "ទ", "ួ", "ូ", "ី", "ៅ", "ភ", "ាំ", "ៃ", "ឌ", "ធ", "អ", "ះ", "ៈ", "គ", "ឡ", "៉", "ឍ", "ឃ", "ជ", "េះ", "ព", "ណ", "ំ", "ុះ", "ឿ", "ោះ" ]
    let primaryBottomKeys = ["ឆ", "ឺ", "េ", "រ", "ត", "យ", "ុ", "ិ", "ោ", "ផ", "ា", "ស", "ដ", "ថ", "ង", "ហ", "ញ", "ក", "ល", "់", "ឋ", "ខ", "ច", "វ", "ប", "ន", "ម", "ុំ", "ៀ", "ើ" ]
    

    @IBOutlet var primaryButtons: [UIButton]!
    @IBOutlet weak var lineButton: UIButton!
    @IBOutlet weak var deletButton: UIButton!
    
    @IBOutlet weak var changeViewButton: UIButton!
    @IBOutlet var primaryView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadInterface()
        proxy = textDocumentProxy as UITextDocumentProxy
        nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .touchUpInside)
        
        gestureButtons()
        deleteLongGesture()

        //print(Realm.Configuration.defaultConfiguration.fileURL)
        loadData()
        
    }
    
    func loadData(){
        todoItems = realm.objects(Data.self)
        
    }

    
    func gestureButtons(){
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        style.lineSpacing = 15.0
        
        style.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let topTitleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 12)!,
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.paragraphStyle : style
        ]
        let bottomSubtitleAttributes = [
            NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 17)!,
            NSAttributedString.Key.paragraphStyle : style
        ]
        
        for btn in primaryButtons {
            
            let primaryAttribute = NSMutableAttributedString(string: primaryUpKeys[btn.tag], attributes: topTitleAttributes)
            primaryAttribute.append(NSAttributedString(string: "\n"))
            primaryAttribute.append(NSAttributedString(string: primaryBottomKeys[btn.tag], attributes: bottomSubtitleAttributes))
            btn.setAttributedTitle(primaryAttribute, for: .normal)
           
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nomalTap(_:)))
                tapGesture.numberOfTapsRequired = 1
            
            let switchupGesture = UISwipeGestureRecognizer(target: self, action: #selector(upTap(_:)))
                switchupGesture.direction = UISwipeGestureRecognizer.Direction.up
            
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
            longGesture.minimumPressDuration = 0.5
            longGesture.numberOfTouchesRequired = 1
           
            btn.addGestureRecognizer(tapGesture)
            btn.addGestureRecognizer(switchupGesture)
            btn.addGestureRecognizer(longGesture)
            
            tapGesture.require(toFail: switchupGesture)
            tapGesture.require(toFail: longGesture)
            
        }
        
    }
    
    func deleteLongGesture(){
        let longDeleteGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleDeleteLongPress(_:)))
        longDeleteGesture.minimumPressDuration = 0.5
        longDeleteGesture.numberOfTouchesRequired = 1
        
        deletButton.addGestureRecognizer(longDeleteGesture)
    }
    
    
    @objc func nomalTap(_ sender: UITapGestureRecognizer){
        let title = sender.view as! UIButton
        let txtButton = title.titleLabel?.text
        let character = String(txtButton!.suffix(1))
        queryData(c: character)
        
        DispatchQueue.main.async {
            self.proxy.insertText(character)
        }
        
        
    }
    
    @objc func upTap(_ sender: UISwipeGestureRecognizer){
        let title = sender.view as! UIButton
        let txtButton = title.titleLabel?.text
        let character = String((txtButton!.prefix(1)))
        queryData(c: character)
        DispatchQueue.main.async {
            self.proxy.insertText(character)
        }
        
    }
    
    func queryData(c: String){
      
        word = word + c
        print(word)
        
        queryWords(word: word)
        
        
    }
    
    func queryWords(word: String){
        clearTextButton()
        let words = todoItems?.filter("name LIKE '*\(word)*'")
        let wordCount = words!.count
        
        
        for i in 0..<wordCount where i < 3{
            let label = words?[i].name
            
            wordButtons[i].setTitle(label , for: .normal)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(wordTap(_:)))
            wordButtons[i].addGestureRecognizer(tapGesture)
            
        }
    }
    
    func clearTextButton(){
        for button in wordButtons {
            button.setTitle("", for: .normal)
        }
    }
    
    @objc func wordTap(_ sender: UITapGestureRecognizer){
        let view = sender.view as! UIButton
        let title = view.titleLabel?.text
        
        DispatchQueue.main.async {
            self.proxy.insertText(title!)
        }
        
        
    }
    
    
    @objc func longTap(_ sender: UILongPressGestureRecognizer){
        let title = sender.view as! UIButton
        let txt = title.titleLabel?.text
        
        DispatchQueue.main.async {
            self.proxy.insertText(String((txt!.suffix(1))))
        }
        
    }
    
    @objc func handleDeleteLongPress(_ sender: UILongPressGestureRecognizer){
        proxy.deleteBackward()
    }
    
    @IBAction func buttonsClick(_ sender: UIButton) {
        let text = sender.titleLabel?.text
        insertTextFromButton(txt: text!)
    }
    
    @IBAction func spacePress(_ sender: UIButton) {
        let text = " "
        queryData(c: text)
        insertTextFromButton(txt: text)
    }
    @IBAction func linePress(_ sender: UIButton) {
        let text = "\n"
        insertTextFromButton(txt: text)
        
    }
    
    @IBAction func deletePress(_ sender: Any) {
        //var char = Array(word)

        if word.count > 0 {
            
            word.remove(at: word.index(before: word.endIndex))
            print(word)
            queryWords(word: word)

        }
        
        proxy.deleteBackward()
        
    }
    
    func insertTextFromButton(txt: String){
        DispatchQueue.main.async {
            self.proxy.insertText(txt)
        }
        
    }
    
    func loadInterface(){
        
        let keyboardNib = UINib(nibName: "keyboardView", bundle: nil)
        keyboardView = keyboardNib.instantiate(withOwner: self, options: nil).first as? UIView
        keyboardView.frame.size = view.frame.size
        view.addSubview(keyboardView)
       
    }
    
    @IBAction func changeView(_ sender: UIButton) {
        if sender.titleLabel?.text == "១២៣" {
            primaryView.isHidden = true
            //secondView.isHidden = false
            changeViewButton.setTitle("កខគ", for: .normal)
        }else if sender.titleLabel?.text == "កខគ" {
            primaryView.isHidden = false
           // secondView.isHidden = true
            changeViewButton.setTitle("១២៣", for: .normal)
        }
    }
    

}
