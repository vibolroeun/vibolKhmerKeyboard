//
//  Keys.swift
//  vibolKeyboard
//
//  Created by Vibol's Macbook Pro on 11/21/18.
//  Copyright © 2018 Vibol Roeun. All rights reserved.
//

import Foundation


class KeysButtton {
    
    let primaryUpKeys = ["ឈ", "ឹ", "ែ", "ឬ", "ទ", "ួ", "ូ", "ី", "ៅ", "ភ", "ាំ", "ៃ", "ឌ", "ធ", "អ", "ះ", "ៈ", "គ", "ឡ", "៉", "ឍ", "ឃ", "ជ", "េះ", "ព", "ណ", "ំ", "ុះ", "ឿ", "ោះ" ]
    let upkeys = [" ្ឈ", "", "", "", "  ្ទ", "", "", "", "", "  ្ភ", "", "", "  ្ឌ", "  ្ធ", "  ្អ", "", "", "  ្គ", "  ្ឡ", "", "  ្ឍ", "  ្ឃ", "  ្ជ", "", "  ្ព", "  ្ណ", "", "", "", "" ]
    
    let smallConstants = ["្ក", "្ខ", "្គ", "្ឃ", "្ង", "្ច", "្ឆ", "្ជ", "្ឈ", "្ញ", "្ដ", "្ថ", "្ហ", "្ល", "្ឋ", "្រ", "្វ", "្ត", "្ប", "្ន", "្ម", "្ទ", "្ភ", "្ឌ", "្ធ", "្អ", "្ឡ", "្ឍ", "្ព", "្ណ", "្យ", "្ផ", "្ស" ]
    
    let primaryBottomKeys = ["ឆ", "ឺ", "េ", "រ", "ត", "យ", "ុ", "ិ", "ោ", "ផ", "ា", "ស", "ដ", "ថ", "ង", "ហ", "ញ", "ក", "ល", "់", "ឋ", "ខ", "ច", "វ", "ប", "ន", "ម", "ុំ", "ៀ", "ើ" ]
    
    let secondUpKeys = ["១", "២", "៣", "៤", "៥", "៦", "៧", "៨", "៩", "០", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "ឲ", "@", "#", "$", "%", "'\'", "&", "*", "(", ")" ]
    
    let secondBottomKeys = ["!", "ៗ", "៖", "៛", "៎", "៍", "័", "៏", "៌", "៊", "ឥ", "ឦ", "ឧ", "ឱ", "ឪ", "ឫ", "ឬ", "ឭ", "ឮ", "ឯ", "ឱ", ".", ",", ":", "+", "-", "_", "/", "|", "៕" ]
    
    let consonants = "កខគឃងចឆជឈញដថហលឋរវតបនមទភឌធអឡឍពណយផស"
    
    func isConsonants(char: String) -> Bool {
        
        let vogalsSet = NSCharacterSet(charactersIn: consonants)
        if char.rangeOfCharacter(from: vogalsSet as CharacterSet) != nil {
            return true
        }else{
            return false
        }
    }
    
    func isSmallConsonants(char: String) -> Bool {
        
        return smallConstants.contains(char) ? true:false
        
    }
}

