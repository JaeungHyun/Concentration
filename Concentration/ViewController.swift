//  ViewController.swift
//  Concentration
//
//  Coding as done by Instructor CS193P Michel Deiman on 11/11/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    // lazy initializer
    // lazy property는 didSet을 가질 수 없음.
	
	var flipCount = 0 {
        // observer patterns
		didSet {
			flipCountLabel.text = "Flips: \(flipCount)"
		}
	}
	
	@IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
	
	@IBOutlet var cardButtons: [UIButton]!
	
    var alreadyChoseTheme = false
	
	@IBAction func touchCard(_ sender: UIButton) {
        if alreadyChoseTheme == false {
            chooseTheme()
            alreadyChoseTheme = true
        }
        
		flipCount += 1
		if let cardNumber = cardButtons.firstIndex(of: sender) {
			game.chooseCard(at: cardNumber)
            scoreLabel.text = "Score: \(game.score)"
			updateViewFromModel()
		} else {
			print("choosen card was not in cardButtons")
		}
	}
	
	func updateViewFromModel() {
        for index in cardButtons.indices { // indices : countable range
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
	
    var emojiChoices = [String]()
	
    func chooseTheme() {
        let theme = ["sprots" : ["⚽️", "🏀", "🏈","⚾️","🥎","🎾","🏐"],
                     "halloween" : ["🦇", "😈", "🎃", "👻", "🍭", "🍬"],
                     "cars" : ["🚗","🚕","🚌","🚙","🚎","🏎","🚓"],
                     "faces" : ["😀","😇","🤪","😎","🥶","🤡"],
                     "animals" : ["🐶","🐱","🐭","🐹","🐰","🦊"],
                     "weather" : ["❄️","⛈","🌤","☀️","☂️","☃️"]]
        let themeKeys = Array(theme.keys)
        let themeIndex = Int(arc4random_uniform(UInt32(themeKeys.count)))
        emojiChoices = Array(theme.values)[themeIndex]
    }
    
	var emoji = [Int: String]()  // Dictionary<Int, String>()
	
	func emoji(for card: Card) -> String {
        game.chosenBefore = Array(emoji.keys)
		if emoji[card.identifier] == nil, emojiChoices.count > 0 {
			let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count - 1)))
			emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
		}
		return emoji[card.identifier] ?? "?" // emoji[card.identifier]가 optional이면 값을 리턴, 없으면 "?"을 리턴
	}
    

    
    @IBAction func startNewGame(_ sender: Any) {
        flipCount = 0
        game.score = 0
        scoreLabel.text = "Score: 0"
        emojiChoices += emoji.values
        emoji = [Int:String]()
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            game.cards[index].isFaceUp = false
            game.cards[index].isMatched = false
            game.indexOfOneAndOnlyFaceUpCard = nil
        }
        chooseTheme()
    }
}















