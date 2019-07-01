
import Foundation


// 클래스는 참조 타입
// 구조체는 값 타입
struct Concentration {
	
	var cards = [Card]()
    
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var score = 0
    var chosenBefore = [Int]()
	
    // 구조체에서 일반적으로 프로퍼티 값을 바꿀 수 없음. 값을 바꾸고 싶으면 mutating을 사용해서 변경한다고 알려줘야함
	mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concetration.chooseCard(at: \(index)): chosen index not in the cards")
		if !cards[index].isMatched { // cards[index]의 isMatched가 false일 때
			if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // 이미 선택된 카드와 다른 카드이면
				// check if cards match
				if cards[matchIndex] == cards[index] {
                    // 같은 종류의 카드이면?
					cards[matchIndex].isMatched = true
					cards[index].isMatched = true
                    score += 2
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

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
