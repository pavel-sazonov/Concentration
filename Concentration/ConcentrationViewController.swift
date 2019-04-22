//
//  ViewController.swift
//  Concentration
//
//  Created by Pavel Sazonov on 15/02/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    private lazy var game = ConcentrationGame(numberOfPairsOfCards: numberOfPairsOfCards)
    
//    override var vclLoggingName: String {
//        return "Game"
//    }
    
    var numberOfPairsOfCards: Int {
        return visibleCardButtons.count / 2
    }
    
    private var emojiChoices = "👻🎃😱👽💀🧟‍♀️🐲👹🤡☠️"
    
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    private var emoji = [ConcentrationCard: String]()
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
         didSet { updateFlipCountLabel() }
    }
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    private var visibleCardButtons: [UIButton]! {
        return cardButtons?.filter { !$0.superview!.isHidden }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = visibleCardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            
            UIView.transition(with: sender, // flip card face up
                              duration: Constants.flipDuration,
                              options: [.transitionFlipFromLeft],
                              animations: { self.updateViewFromModel() },
                              completion: { finished in
                                let cardsIndicesToAnimate = self.game.faceUpCardsIndices
                                if cardsIndicesToAnimate.count == 2 {
                                    if self.game.faceUpCardsMatched {  // scale up matched cards
                                        UIViewPropertyAnimator.runningPropertyAnimator(
                                            withDuration: Constants.scaleUpDuration,
                                            delay: 0,
                                            options: [],
                                            animations: {
                                                cardsIndicesToAnimate.forEach {
                                                    self.game.faceDownCards(at: $0)
                                                    self.visibleCardButtons[$0].transform =
                                                        CGAffineTransform.identity.scaledBy(x: Constants.scaleUpSize,
                                                                                            y:  Constants.scaleUpSize)
                                                }
                                        },
                                            completion: { position in  // scale down matched card and hide
                                                UIViewPropertyAnimator.runningPropertyAnimator(
                                                    withDuration: Constants.scaleDownDuration,
                                                    delay: 0,
                                                    options: [],
                                                    animations: {
                                                        cardsIndicesToAnimate.forEach {
                                                            self.visibleCardButtons[$0].transform =
                                                                CGAffineTransform.identity.scaledBy(x: Constants.scaleDownSize,
                                                                                                    y:  Constants.scaleDownSize)
                                                            self.visibleCardButtons[$0].alpha = 0
                                                        }
                                                },
                                                    completion: { position in // back card setting
                                                        cardsIndicesToAnimate.forEach {
                                                            self.visibleCardButtons[$0].alpha = 1
                                                            self.visibleCardButtons[$0].transform = .identity
                                                        }
                                                        self.updateViewFromModel()
                                                })
                                        })
                                    } else { // flip face down not matched cards
                                        cardsIndicesToAnimate.forEach { index in
                                            UIView.transition(with: self.visibleCardButtons[index],
                                                              duration: Constants.flipDuration,
                                                              options: [.transitionFlipFromLeft],
                                                              animations: { self.game.faceDownCards(at: index) })
                                        }
                                        self.updateViewFromModel()
                                    }
                                }
            })
        }
    }
    
    @IBAction private func startNewGame() {
        game.newGame()
        emojiChoices = theme ?? ""
        emoji = [:]
        updateViewFromModel()
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        
        flipCountLabel.attributedText = attributedString
    }
    
    private func updateViewFromModel() {
        if visibleCardButtons != nil {
            for index in visibleCardButtons.indices {
                let button = visibleCardButtons[index]
                let card = game.cards[index]
                
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                }
            }
            scoreLabel.text = "Score: \(game.score)"
            updateFlipCountLabel()
        }
    }
    
    private func emoji(for card: ConcentrationCard) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4Random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
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

extension ConcentrationViewController {
    private struct Constants {
        static let flipDuration = 0.5
        static let scaleUpDuration = 0.6
        static let scaleDownDuration = 0.75
        static let scaleUpSize: CGFloat = 2.0
        static let scaleDownSize: CGFloat = 0.1
    }
}
