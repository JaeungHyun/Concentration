import UIKit

class ViewController: UIViewController {
	
	private lazy var game =
        Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    // lazy initializer
    // lazy property는 didSet을 가질 수 없음.
    
    var numberOfPairsOfCards: Int { // Computed property
        get {
            return (cardButtons.count+1) / 2
        }
    }
	
	private(set) var flipCount = 0 {
        // observer patterns
		didSet {
           updateFlipCountLabel()
		}
	}
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
	
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    @IBOutlet private var scoreLabel: UILabel!
	@IBOutlet private var cardButtons: [UIButton]!
	
	@IBAction func touchCard(_ sender: UIButton) {
		flipCount += 1
		if let cardNumber = cardButtons.firstIndex(of: sender) {
			game.chooseCard(at: cardNumber)
            scoreLabel.text = "Score: \(game.score)"
			updateViewFromModel()
		} else {
			print("chosen card was not in cardButtons")
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
	
    //private var emojiChoices = [String]()
    
    private var emojiChoices = "🦇😈🎃👻🍭🍬"
    
	private var emoji = [Card: String]()  // Dictionary<Int, String>()
	
	private func emoji(for card: Card) -> String {
        
		if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
			emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
		}
		return emoji[card] ?? "?" // emoji[card.identifier]가 optional이면 값을 리턴, 없으면 "?"을 리턴
	}
    
    @IBAction func startNewGame(_ sender: Any) {
        flipCount = 0
        game.score = 0
        scoreLabel.text = "Score: 0"
        emoji = [Card: String]()
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            game.cards[index].isFaceUp = false
            game.cards[index].isMatched = false
            game.indexOfOneAndOnlyFaceUpCard = nil
        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
        
    }
}
