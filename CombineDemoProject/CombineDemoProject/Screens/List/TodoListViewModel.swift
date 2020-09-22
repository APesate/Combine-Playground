import Foundation
import Combine

public class TodoListViewModel {

	/// We user the @Published property wrapper to turn this property into a Combine Publisher.
	@Published public var dataSource: [TodoItem] = [TodoItem(title: "Send invite for the talk", isDone: true),
													TodoItem(title: "Prepare playground", isDone: true),
													TodoItem(title: "Prepare demo project", isDone: true),
													TodoItem(title: "Share playground", isDone: false),
													TodoItem(title: "Ask if there are any questions", isDone: false)]

	public init() {}

	// MARK: Interface

	public func add(item: TodoItem) {
		dataSource.append(item)
	}

	public func remove(itemAt index: Int) {
		dataSource.remove(at: index)
	}

	public func set(itemAt index: Int, completed: Bool) {
		dataSource[index].isDone = completed
	}

}
