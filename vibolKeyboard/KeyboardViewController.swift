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
    
    let popUpView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.backgroundColor = UIColor.red
        return view
    }()
    
    lazy var b1:UIButton = {
        let b = UIButton()
        b.setTitle("a", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.backgroundColor = UIColor.blue
        return b
    }()
    
    lazy var b2:UIButton = {
        let b = UIButton()
        b.setTitle("b", for: .normal)
        b.setTitleColor(UIColor.black, for: .normal)
        b.backgroundColor = UIColor.white
        return b
    }()
    
    lazy var stack:UIStackView = {
        let s = UIStackView(frame: self.view.bounds)
        s.axis = .horizontal
        s.distribution = .fillEqually
        s.alignment = .fill
        s.spacing = 2
        s.backgroundColor = UIColor.white
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        s.addArrangedSubview(self.b1)
        s.addArrangedSubview(self.b2)
        
        return s
    }()
    
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
        
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "No file")
        arrayUpKeys = key.primaryUpKeys
        arrayBottomKeys = key.primaryBottomKeys
        
        gestureButtons()
        deleteLongGesture()
        clearTextButton()
        
        
        popUpView.addSubview(stack)
        setupStack()
    }

    func setupStack(){
        stack.topAnchor.constraint(equalTo: popUpView.topAnchor, constant: 0.0).isActive = true
        stack.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor, constant: 0.0).isActive = true
        stack.rightAnchor.constraint(equalTo: popUpView.rightAnchor, constant: 0.0).isActive = true
        stack.leftAnchor.constraint(equalTo: popUpView.leftAnchor, constant: 0.0).isActive = true
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
       // convert coordinate Button to view
        let p = view.convert(btn.frame, from: self.view)
        let q = btn.convert(btn.frame, from: self.viewContainer)
        
        b1.setTitle(arrayUpKeys[btn.tag], for: .normal)
        b2.setTitle(key.upkeys[btn.tag], for: .normal)
        popUpView.frame = CGRect(x: p.origin.x, y: -q.origin.y+2, width: 72, height: 35)
        self.view.addSubview(popUpView)
        
        
        
        btn.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 1, animations: {
            btn.transform = CGAffineTransform.identity
            //popUpView.removeFromSuperview()
        }, completion: nil)
        
        
        if let txtButton = btn.titleLabel?.text {
            let character = String(txtButton.suffix(1))
            model.conbaineChar(char: Character(character))
            self.proxy.insertText(character)
        }
        
        suggestionTextButton()
        isSuggestWord = false
    }

    @objc func upTap(_ sender: UISwipeGestureRecognizer){
        let btn = sender.view as! UIButton
        let txtButton = btn.titleLabel?.text
        let character = String((txtButton!.prefix(1)))
   
        model.conbaineChar(char: Character(character))
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
        let text:Character = Character((sender.titleLabel?.text)!)
        insertTextFromButton(txt: text)
    }
    
    @IBAction func spacePress(_ sender: UIButton) {
        let text:Character = " "
        model.conbaineChar(char: text)
        suggestionTextButton()
        insertTextFromButton(txt: text)
    }
    @IBAction func linePress(_ sender: UIButton) {
        let text:Character = "\n"
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
    
    func insertTextFromButton(txt: Character){
        DispatchQueue.main.async {
            self.proxy.insertText(String(txt))
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
