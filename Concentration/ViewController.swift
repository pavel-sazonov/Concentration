//
//  ViewController.swift
//  Concentration
//
//  Created by Pavel Sazonov on 15/02/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return cardButtons.count / 2
    }
    
    var emojiChoices = ["👻", "🎃", "😱", "👽", "💀", "🧟‍♀️", "🐲", "👹", "🤡"]
    var removedEmojies = [String]()
    var emoji = [Int: String]()
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }

    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBAction func startNewGame() {
        flipCount = 0
        newGame()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            let removedEmoji = emojiChoices.remove(at: randomIndex)
            emoji[card.identifier] = removedEmoji
            removedEmojies.append(removedEmoji)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    func newGame() {
        for index in cardButtons.indices {
            game.cards[index].isFaceUp = false
            game.cards[index].isMatched = false
            cardButtons[index].setTitle("", for: UIControl.State.normal)
            cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        }
        
        emoji = [:]
        emojiChoices += removedEmojies
        removedEmojies = []
    }
}

