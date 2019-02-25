//
//  ViewController.swift
//  Concentration
//
//  Created by Pavel Sazonov on 15/02/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return cardButtons.count / 2
    }
    
    private var emojiChoices = "👻🎃😱👽💀🧟‍♀️🐲👹🤡"
    private var removedEmojies = ""
    private var emoji = [Card: String]()
    
    private (set) var flipCount = 0 {
        didSet { updateFlipCountLabel() }
    }

    @IBOutlet private weak var flipCountLabel: UILabel! {
         didSet { updateFlipCountLabel() }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBAction private func startNewGame() {
        flipCount = 0
        game.newGame()
        for index in cardButtons.indices {
            cardButtons[index].setTitle("", for: UIControl.State.normal)
            cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        }
        emoji = [:]
        emojiChoices += removedEmojies
        removedEmojies = ""
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        
        flipCountLabel.attributedText = attributedString
    }
    
    private func updateViewFromModel() {
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
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4Random)
            let removedEmoji = String(emojiChoices.remove(at: randomStringIndex))
            emoji[card] = removedEmoji
            removedEmojies.append(removedEmoji)
        }
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4Random: Int {
        if self > 0 {
            return Int.random(in: 0..<self)
        } else if self < 0 {
            return -Int.random(in: 0..<abs(self))
        } else {
            return 0
        }
    }
}
