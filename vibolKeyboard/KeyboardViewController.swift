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
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet var wordButtons: [UIButton]!
    @IBOutlet var nextKeyboardButton: UIButton!

    @IBOutlet var primaryButtons: [UIButton]!
    @IBOutlet weak var lineButton: UIButton!
    @IBOutlet weak var deletButton: UIButton!
    
    @IBOutlet weak var changeViewButton: UIButton!
    @IBOutlet var primaryView: UIView!
    
    var proxy: UITextDocumentProxy!
    var keyboardView: UIView!
    
    let key = KeysButtton()
    let attribute = KeysAttribute()
    let model = Model()
    
    var count:Int = 1
    var arrayUpKeys = [String]()
    var arrayBottomKeys = [String]()
    var isSuggestWord: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInterface()
        proxy = textDocumentProxy as UITextDocumentProxy
        nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .touchUpInside)
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        arrayUpKeys = key.primaryUpKeys
        arrayBottomKeys = key.primaryBottomKeys
        
        gestureButtons()
        deleteLongGesture()
        clearTextButton()
    
    }

    func gestureButtons(){
        
        for btn in primaryButtons {
            
            let primaryAttribute = NSMutableAttributedString(string: arrayUpKeys[btn.tag], attributes: attribute.topTitleAttributes)
                primaryAttribute.append(NSAttributedString(string: "\n"))
                primaryAttribute.append(NSAttributedString(string: arrayBottomKeys[btn.tag], attributes: attribute.bottomSubtitleAttributes))
            btn.setAttributedTitle(primaryAttribute, for: .normal)
            
            btn.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0).cgColor
           
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nomalTap(_:)))
                tapGesture.numberOfTapsRequired = 1

            let switchUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(upTap(_:)))
                switchUpGesture.direction = UISwipeGestureRecognizer.Direction.up
            
            let switchDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(downTap(_:)))
            switchDownGesture.direction = UISwipeGestureRecognizer.Direction.down

            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
                longGesture.minimumPressDuration = 0.3
                longGesture.numberOfTouchesRequired = 1
           
            btn.addGestureRecognizer(tapGesture)
            btn.addGestureRecognizer(switchUpGesture)
            btn.addGestureRecognizer(longGesture)
            btn.addGestureRecognizer(switchDownGesture)
            
            tapGesture.require(toFail: switchUpGesture)
            tapGesture.require(toFail: switchDownGesture)
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
        let btn = sender.view as! UIButton

        if let txtButton = btn.titleLabel?.text {
            let character = String(txtButton.suffix(1))
            model.conbaineChar(char: character)
            self.proxy.insertText(character)
        }
        
        suggestionTextButton()
        isSuggestWord = false
    }

    @objc func upTap(_ sender: UISwipeGestureRecognizer){
        let btn = sender.view as! UIButton
        
        if let txtButton = btn.titleLabel?.text {
            let character = String((txtButton.prefix(1)))
            model.conbaineChar(char: character)
            self.proxy.insertText(character)
        
        }
    
        suggestionTextButton()
        isSuggestWord = false

    }
    
    @objc func downTap(_ sender: UISwipeGestureRecognizer){
        
        let btn = sender.view as! UIButton
        
        if let txtButton = btn.titleLabel?.text {
            let txt = txtButton.suffix(1)
            if key.isConsonants(char: String(txt)) {
                let character = "្\(txt)"
                
                model.conbaineChar(char: character)
                self.proxy.insertText(String(character))
            }
            
        }
    }
    
    
    func suggestionTextButton(){
        clearTextButton()
        let words = model.filterObj()
        
        for i in 0..<words.count where i < 3{
            let label = words[i].word
            wordButtons[i].isEnabled = true
            wordButtons[i].setTitle(label , for: .normal)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(suggestionWordTap(_:)))
            wordButtons[i].addGestureRecognizer(tapGesture)
            
        }
    }
    
    func clearTextButton(){
        for button in wordButtons {
            button.setTitle(nil, for: .normal)
            button.isEnabled = false
        }
    }
    
    @objc func suggestionWordTap(_ sender: UITapGestureRecognizer){
        let view = sender.view as! UIButton
        
        
        if model.word.count > 0 {
            for _ in model.word {
                proxy.deleteBackward()
            }
        }
        
        if let title = view.titleLabel?.text {
            self.proxy.insertText(title)
            model.updateFrequency(word: title)
        }
        
        isSuggestWord = true
        model.word.removeAll()
    }
    
    
    @objc func longTap(_ sender: UILongPressGestureRecognizer){
        
        if sender.state == .began {
            let btn = sender.view as! UIButton
            
            if let txtButton = btn.titleLabel?.text {
                let txt = txtButton.prefix(1)
                if key.isConsonants(char: String(txt)) {
                    let character = "្\(txt)"
                    
                    model.conbaineChar(char: character)
                    self.proxy.insertText(String(character))
                }
            }
        }
    }
    
    @objc func handleDeleteLongPress(_ sender: UILongPressGestureRecognizer){
        proxy.deleteBackward()
    }
    
    @IBAction func buttonsClick(_ sender: UIButton) {
        let text:String = String((sender.titleLabel?.text)!)
        insertTextFromButton(txt: text)
    }
    
    @IBAction func spacePress(_ sender: UIButton) {
        let text:String = " "
        model.conbaineChar(char: text)
        suggestionTextButton()
        insertTextFromButton(txt: text)
    }
    @IBAction func linePress(_ sender: UIButton) {
        let text:String = "\n"
        insertTextFromButton(txt: text)
        
    }
    
    @IBAction func deletePress(_ sender: Any) {
        clearTextButton()
        if !isSuggestWord {
            suggestionTextButton()
        }
        
        if model.word.count > 0 {
            if key.isSmallConsonants(char: model.word.last!) {
                for _ in 0..<2{
                    proxy.deleteBackward()
                }
            }else {
                proxy.deleteBackward()
            }
            model.removeLastChar()
        }else{
            proxy.deleteBackward()
        }
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
        
        if count == 1 {
            arrayUpKeys = key.secondUpKeys
            arrayBottomKeys = key.secondBottomKeys
            
            count = 0
        }else if count == 0 {
            arrayUpKeys = key.primaryUpKeys
            arrayBottomKeys = key.primaryBottomKeys
        
            count = 1
        }
        gestureButtons()
        
    }
    

}
