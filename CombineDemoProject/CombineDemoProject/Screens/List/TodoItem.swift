import Foundation

public class TodoItem: Hashable, Equatable {

	private let id = UUID()
	public let title: String
	public var isDone: Bool

	public init(title: String, isDone: Bool) {
		self.title = title
		self.isDone = isDone
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	static public  func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
		lhs.id == rhs.id
	}

}
