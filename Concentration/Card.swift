import Foundation


// 구조체는 값 타입
struct Card {
	
	var isFaceUp = false
	var isMatched = false
	var identifier: Int
	
	static var identifierFactory = 0
	
	static func getUniqueIdentifier() -> Int {
		identifierFactory += 1 // 정적메소드 안이라서 Card.identifierFactory라 적지 않아도 된다.
		return identifierFactory
	}
	
	init() {
		self.identifier = Card.getUniqueIdentifier()
	}
}
