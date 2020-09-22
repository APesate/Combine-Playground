import Combine
import UIKit

public class TodoListViewController: UIViewController {

	private let tableView = UITableView()
	private let viewModel: TodoListViewModel
	private lazy var tableViewDataSource = makeDataSource()
	private var cancellables: Set<AnyCancellable> = []

	public init(viewModel: TodoListViewModel = .init()) {
		self.viewModel = viewModel

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupComponents()
		setupConstraints()
	}

	// MARK: Bindings

	/// In this method we add the `Subscriber` to the viewModel `dataSource` property.
	/// This way every time there is an update we can update the tableView dataSource.
	private func bindDataSource() {
		viewModel
			.$dataSource
			.sink { [weak tableViewDataSource] (items) in
				var snapshot = Snapshot()
				snapshot.appendSections([.main])
				snapshot.appendItems(items, toSection: .main)
				
				tableViewDataSource?.apply(snapshot, animatingDifferences: true)
			}
			.store(in: &cancellables)
	}

	/// To be able to update the data properly, we add a subscriber to the `markAsCompleted` property from the cell.
	/// Every time the user changes the state of the item we will get notified and we then pass the action to the viewModel
	/// So that it can update the data accordingly 
	private func cell(for tableView: UITableView, at indexPath: IndexPath, for model: TodoItem) -> UITableViewCell? {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.identifier, for: indexPath) as? TodoListTableViewCell else {
			return UITableViewCell()
		}

		cell.setup(with: model)
		cell.$markAsCompleted
			.receive(on: RunLoop.main)
			.dropFirst() // We drop the first value as we don't want to update the model when we are just setting up the cell.
			.sink(receiveValue: { [weak self] (newState) in
				guard let self = self else { return }
				self.viewModel.set(itemAt: indexPath.row, completed: newState)
			})
			.store(in: &cell.cancellables)

		return cell
	}

}

extension TodoListViewController {

	// MARK: Private

	private func setupComponents() {
		title = "Todo List"
		navigationController?.navigationBar.prefersLargeTitles = true
		view.backgroundColor = .systemGroupedBackground

		tableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: TodoListTableViewCell.identifier)
		tableView.tableFooterView = UIView()
		tableView.backgroundColor = .systemGroupedBackground
		tableView.dataSource = tableViewDataSource

		view.addSubview(tableView)

		addCreateItemButton()
		bindDataSource()
	}

	private func setupConstraints() {
		tableView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
			view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
		])
	}

	private func addCreateItemButton() {
		let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
		navigationItem.setRightBarButton(button, animated: false)
	}

	// MARK: Actions

	@objc private func addNewItem() {
		let alert = UIAlertController(title: "New Entry", message: nil, preferredStyle: .alert)
		alert.addTextField(configurationHandler: nil)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (_) in
			guard let self = self else { return }
			guard let textField = alert.textFields?.first, let entry = textField.text else { return }

			let item = TodoItem(title: entry, isDone: false)
			self.viewModel.add(item: item)
		}))

		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

		present(alert, animated: true, completion: nil)
	}

}

// MARK: - TableView
private extension TodoListViewController {

	private typealias DataSource = UITableViewDiffableDataSource<Section, TodoItem>
	private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TodoItem>

	private enum Section: Hashable {

		case main

	}

	private func makeDataSource() -> DataSource {
		let dataSource = DataSource(tableView: tableView, cellProvider: cell(for:at:for:))
		return dataSource
	}

}
