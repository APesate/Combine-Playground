import UIKit
import Combine

public class TodoListTableViewCell: UITableViewCell {

	public static var identifier: String = "TodoListTableViewCell"

	public let stateSwitch = UISwitch()
	private let titleLabel = StrikethroughLabel()
	var cancellables: Set<AnyCancellable> = []

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupComponents()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func prepareForReuse() {
		titleLabel.text = nil
		stateSwitch.isOn = false
		cancellables.removeAll()
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		reloadTitle()
	}

	// MARK: Interface

	/// We user the @Published property wrapper to turn this property into a Combine Publisher.
	@Published public var markAsCompleted: Bool = false

	public func setup(with item: TodoItem) {
		stateSwitch.isOn = item.isDone
		titleLabel.text = item.title
	}

	// MARK: Private

	private func setupComponents() {
		contentView.backgroundColor = .systemBackground
		selectionStyle = .none

		titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
		titleLabel.numberOfLines = 0
		
		stateSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)

		[titleLabel, stateSwitch].forEach(contentView.addSubview(_:))
	}

	private func setupConstraints() {
		[titleLabel, stateSwitch].forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })

		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
			contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),

			stateSwitch.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
			stateSwitch.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
			contentView.trailingAnchor.constraint(equalTo: stateSwitch.trailingAnchor, constant: 24)
		])
	}

	private func reloadTitle(animated: Bool = false) {
		guard animated else {
			titleLabel.textColor = self.stateSwitch.isOn ? .tertiaryLabel : .label
			stateSwitch.isOn ? titleLabel.showStrikeTextLayer() : titleLabel.hideStrikeTextLayer()
			return
		}

		stateSwitch.isOn ? titleLabel.strikeThroughText(duration: animated ? 0.5 : 0.0) : titleLabel.hideStrikeTextLayer()
		UIView.transition(with: titleLabel, duration: animated ? 0.25 : 0.0, options: .transitionCrossDissolve, animations: {
			self.titleLabel.textColor = self.stateSwitch.isOn ? .tertiaryLabel : .label
		})
	}

	@objc private func switchChanged() {
		markAsCompleted = stateSwitch.isOn
		reloadTitle(animated: true)
	}

}
