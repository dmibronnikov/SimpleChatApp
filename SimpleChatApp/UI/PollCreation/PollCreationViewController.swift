import UIKit

private let questionCharacterLimit: Int = 140
final class PollCreationViewController: UITableViewController {
    private enum Section: Int, CaseIterable {
        case question
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
    
    private var questionText: String = ""
    
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
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(onCloseTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Create",
            style: .plain,
            target: self,
            action: #selector(onCreatePollTapped)
        )
    }
    
    @objc private func onCloseTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func onCreatePollTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
            case .question:
                return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
            case .question:
                return dequeueQuestionCell(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch Section(rawValue: section)! {
            case .question:
                return questionHeaderView
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
    
    // MARK: - UITableViewDelegate
}
