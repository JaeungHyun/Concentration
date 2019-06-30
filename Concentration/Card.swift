import Foundation


// 구조체는 값 타입
struct Card: Hashable {

    func hash(into hasher: inout Hasher) -> Int { return identifier } // 4.1 부터 hashValue가 아니라 func hash(into:)로 변경, hashValue is deprecated
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
	
	var isFaceUp = false
	var isMatched = false
	private var identifier: Int
	
	static var identifierFactory = 0
	
	static func getUniqueIdentifier() -> Int {
		identifierFactory += 1 // 정적메소드 안이라서 Card.identifierFactory라 적지 않아도 된다.
		return identifierFactory
	}
	
	init() {
		self.identifier = Card.getUniqueIdentifier()
	}
}
