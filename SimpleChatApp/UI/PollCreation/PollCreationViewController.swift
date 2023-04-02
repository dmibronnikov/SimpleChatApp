import UIKit

private let questionCharacterLimit: Int = 140
private let optionsLimit = 8

final class PollCreationViewController: UITableViewController {
    struct Actions {
        let createPoll: (_ poll: Poll) -> Void
    }
    var actions: Actions!
    
    private enum Section: Int, CaseIterable {
        case question
        case options
    }
    
    private enum OptionItem {
        case option(id: Int, text: String)
        case addOption
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "New Poll"
        label.font = .appFont(size: 16, weight: .semibold)
        label.textColor = .textPrimary
        
        return label
    }()
    
    private let gradientBackgroundView: GradientView = {
        let gradientView = GradientView()
        gradientView.colors = [
            UIColor.darkAccent,
            UIColor.background,
            UIColor.darkAccent
        ].map { $0.withAlphaComponent(0.3).cgColor }
        gradientView.locations = [0.0, 0.2, 1.0]
        gradientView.startPoint = CGPoint(x: 0.5, y: 0.1)
        gradientView.endPoint = CGPoint(x: 0.6, y: 1.0)
        
        return gradientView
    }()
    
    private let questionHeaderView: CounterSectionHeader = {
        let header = CounterSectionHeader()
        header.configure(text: "Question", maxCount: questionCharacterLimit)
        return header
    }()
    private let optionsHeaderView: CounterSectionHeader = {
        let header = CounterSectionHeader()
        header.configure(text: "Options", maxCount: optionsLimit)
        return header
    }()
    
    private var questionText: String = "" {
        didSet {
            updateCreatePollButtonState()
        }
    }
    private var options: [Int: String] = [:] {
        didSet {
            optionsHeaderView.update(with: options.count)
            updateCreatePollButtonState()
            tableView.reloadData()
        }
    }
    
    private var selectedId: Int?
    
    private var optionsIds: [Int] {
        options.keys.sorted()
    }
    private var nextOptionId: Int {
        guard let lastId = optionsIds.last else { return 1 }
        
        return lastId + 1
    }
    private var optionsItems: [OptionItem] {
        var items: [OptionItem] = optionsIds.map { .option(id: $0, text: options[$0]!) }
        if options.count < optionsLimit {
            items.append(.addOption)
        }
        
        return items
    }
    private var createButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.backgroundView = gradientBackgroundView
        tableView.register(PollCreationQuestionCell.self)
        tableView.register(PollCreationOptionCell.self)
        tableView.register(PollCreationAddOptionCell.self)
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = titleLabel
        
        let cancelButton = UIBarButtonItem(
            image: UIImage(named: "cancel_18"),
            style: .plain,
            target: self,
            action: #selector(onCloseTapped)
        )
        cancelButton.tintColor = .textPrimary
        
        createButton = UIBarButtonItem(
            title: "Create",
            style: .plain,
            target: self,
            action: #selector(onCreatePollTapped)
        )
        createButton?.setTitleTextAttributes([
            .font: UIFont.appFont(size: 14, weight: .medium),
            .foregroundColor: UIColor.accent
        ], for: .normal)
        createButton?.setTitleTextAttributes([
            .font: UIFont.appFont(size: 14, weight: .medium),
            .foregroundColor: UIColor.gray
        ], for: .disabled)
        createButton?.tintColor = .accent
        updateCreatePollButtonState()
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = createButton
    }
    
    private func updateCreatePollButtonState() {
        createButton?.isEnabled = !(options.filter { !$0.value.isEmpty }.isEmpty
                                    || questionText.isEmpty)
    }
    
    // MARK: - Actions
    
    @objc private func onCloseTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func onCreatePollTapped(_ sender: UIBarButtonItem) {
        let poll = Poll(
            question: questionText,
            options: optionsIds.map { Poll.Option(id: $0, text: options[$0] ?? "", votes: 0) }
        )
        
        actions.createPoll(poll)
        dismiss(animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
            case .question:
                return 1
            case .options:
                return optionsItems.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
            case .question:
                return dequeueQuestionCell(tableView, cellForRowAt: indexPath)
            case .options:
                return dequeueOptionCell(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let selectedId = selectedId,
           case .option(let id, _) = optionsItems[indexPath.row],
           id == selectedId {
            cell.becomeFirstResponder()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch Section(rawValue: section)! {
            case .question:
                return questionHeaderView
            case .options:
                return optionsHeaderView
        }
    }
    
    private func dequeueQuestionCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PollCreationQuestionCell.self, at: indexPath)
        cell.configure(with: questionCharacterLimit) { [weak self, weak tableView] text in
            self?.questionText = text
            self?.questionHeaderView.update(with: text.count)
            DispatchQueue.main.async {
                tableView?.beginUpdates()
                tableView?.endUpdates()
            }
        }
        
        return cell
    }
    
    private func dequeueOptionCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch optionsItems[indexPath.row] {
            case .option(let id, let text):
                let cell = tableView.dequeue(PollCreationOptionCell.self, at: indexPath)
                cell.configure(with: text)
                cell.actions = .init(
                    delete: { [weak self] in
                        self?.options.removeValue(forKey: id)
                    },
                    textChanged: { [weak self] updatedText in
                        self?.options[id] = updatedText
                        if let selectedId = self?.selectedId, selectedId == id {
                            self?.selectedId = nil
                        }
                    }
                )
                
                return cell
            case .addOption:
                return tableView.dequeue(PollCreationAddOptionCell.self, at: indexPath)
        }
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section)! {
            case .options:
                if case .addOption = optionsItems[indexPath.row] {
                    let id = nextOptionId
                    options[id] = ""
                    selectedId = id
                }
            case .question:
                break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.section)! {
            case .question:
                return UITableView.automaticDimension
            case .options:
                switch optionsItems[indexPath.row] {
                    case .option:
                        return PollCreationOptionCell.height
                    case .addOption:
                        return PollCreationAddOptionCell.height
                }
        }
    }
}
