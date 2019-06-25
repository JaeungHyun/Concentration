//
//  Concentration.swift
//  Lecture 2 - Concentration
//
//  Created by Michel Deiman on 13/11/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import Foundation


// 클래스는 참조 타입
class Concentration {
	
	var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var score = 0
    var chosenBefore = [Int]()
	
	func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concetration.chooseCard(at: \(index)): chosen index not in the cards")
		if !cards[index].isMatched { // cards[index]의 isMatched가 false일 때
			if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // 이미 선택된 카드와 다른 카드이면
				// check if cards match
				if cards[matchIndex].identifier == cards[index].identifier {
                    // 같은 종류의 카드이면?
					cards[matchIndex].isMatched = true
					cards[index].isMatched = true
                    score += 2
                } else {
                    // 다른 종류의 카드이면?
                    for chosenIdentifier in chosenBefore.indices {
                        if cards[index].identifier == chosenBefore[chosenIdentifier] || cards[matchIndex].identifier == chosenBefore[chosenIdentifier] {
                            score -= 1
                        }
                    }
                }
				cards[index].isFaceUp = true
			} else {
				indexOfOneAndOnlyFaceUpCard = index
			}
		}
	}
	
	init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0 , "Concetration.chooseCard(at: \(numberOfPairsOfCards)): you must have at least one pair of cards")
        // for loop에서 in 다음에 오는 것은 시퀀스면 된다.
		for _ in 1...numberOfPairsOfCards {
			let card = Card()
			cards += [card, card]
		}
        
        //	TODO: Shuffle the cards
        for _ in 1...cards.count {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            cards.swapAt(0, randomIndex)
        }
	}
	
}
