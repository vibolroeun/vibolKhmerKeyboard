//
//  KeysAttribute.swift
//  vibolKeyboard
//
//  Created by Vibol's Macbook Pro on 11/21/18.
//  Copyright © 2018 Vibol Roeun. All rights reserved.
//

import UIKit


class KeysAttribute {
    
    private let style = NSMutableParagraphStyle()
    
    
    var topTitleAttributes: [NSAttributedString.Key : Any]
    var bottomSubtitleAttributes: [NSAttributedString.Key: Any]
    
    init() {
        
        style.alignment = NSTextAlignment.center
        style.lineSpacing = 15.0
        style.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        topTitleAttributes = [
            NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 12)!,
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.paragraphStyle : style
        ]
        
        bottomSubtitleAttributes = [
            NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 17)!,
            NSAttributedString.Key.paragraphStyle : style
        ]
        
    }
    

    
}

