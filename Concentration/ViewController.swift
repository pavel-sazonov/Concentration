//
//  ViewController.swift
//  Concentration
//
//  Created by Pavel Sazonov on 15/02/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCard(withEmoji: "👻", on: sender)
        flipCount += 1
    }
    
    @IBAction func touchSecondCard(_ sender: UIButton) {
        flipCard(withEmoji: "🎃", on: sender)
        flipCount += 1
    }
    
    func flipCard(withEmoji emoji: String, on button: UIButton) {
        if button.currentTitle == emoji {
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        } else {
            button.setTitle(emoji, for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
}

