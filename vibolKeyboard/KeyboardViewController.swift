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

    let key = KeysButtton()
    let attribute = KeysAttribute()
    let model = Model()
    
    var count:Int = 1
    var arrayUpKeys = [String]()
    var arrayBottomKeys = [String]()
    var isSuggestWord: Bool = false
   
    
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
        let btn = sender.view as! UIButton
        let txtButton = btn.titleLabel?.text
        let character = String(txtButton!.suffix(1))
        
        model.conbaineChar(char: character)
        suggestionTextButton()
        DispatchQueue.main.async {
            self.proxy.insertText(character)
        }
        isSuggestWord = false
    }

    @objc func upTap(_ sender: UISwipeGestureRecognizer){
        let btn = sender.view as! UIButton
        let txtButton = btn.titleLabel?.text
        let character = String((txtButton!.prefix(1)))
   
        model.conbaineChar(char: character)
        suggestionTextButton()
        DispatchQueue.main.async {
            self.proxy.insertText(character)
        }
        isSuggestWord = false

    }
    
    
    func suggestionTextButton(){
        clearTextButton()
        let words = model.filterObj()
        
        for i in 0..<words.count where i < 3{
            let label = words[i].name
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
        let title = view.titleLabel?.text
        
        DispatchQueue.main.async {
            self.proxy.insertText(title!)
        }
        isSuggestWord = true
        model.word = ""
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
        model.conbaineChar(char: text)
        suggestionTextButton()
        insertTextFromButton(txt: text)
    }
    @IBAction func linePress(_ sender: UIButton) {
        let text = "\n"
        insertTextFromButton(txt: text)
        
    }
    
    @IBAction func deletePress(_ sender: Any) {
        clearTextButton()
        model.removeLastChar()
        if !isSuggestWord {
            suggestionTextButton()
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
