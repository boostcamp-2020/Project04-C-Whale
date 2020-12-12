//
//  TaskAddViewController.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/11/26.
//

import UIKit

protocol TaskAddViewControllerDelegate: class {
    func taskAddViewControllerDidDone(_ taskAddViewController: TaskAddViewController)
}

class TaskAddViewController: UIViewController {
    
    var section: Int = 0

    // MARK: - Properties
    
    weak var delegate: TaskAddViewControllerDelegate?
    private var viewUpCheck: Bool = false
    private var keyboardHeight: CGFloat = 0
    private var textViewHeight: CGFloat = 0
    private let placeHolder: String = "예. 11월 27일날 데모 발표하기"
    
    private(set) var priority: Priority = .four {
        didSet {
            let viewModel = priority.viewModel()
            priorityButton.tintColor = viewModel.tintColor
            priorityButton.setTitle(" \(viewModel.title)", for: .normal)
        }
    }
    var text: String {
        return textView.text
    }
    var date: Date {
        return dateButtonView.date
    }
    
    // MARK: - Views
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        return view
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        
        return textView
    }()
    
    private let accessoryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let accessoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let dateButtonView: DatePickerButtonView = {
        let dateButton = DatePickerButtonView()
        
        return dateButton
    }()
    
    private lazy var priorityButton: BorderRadiusButton = {
        let priorityButton = BorderRadiusButton()
        let priorityImage = UIImage(systemName: "flag.fill")
        priorityButton.setImage(priorityImage, for: .normal)
        priorityButton.setTitle(" 우선순위4", for: .normal)
        priorityButton.setTitleColor(.gray, for: .normal)
        priorityButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        priorityButton.contentEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
        priorityButton.tintColor = .gray
        priorityButton.backgroundColor = .clear
        priorityButton.configure(borderWidth: 1, borderColor: .gray, radius: 10)
        priorityButton.addTarget(self, action: #selector(didTapPriorityButton), for: .touchUpInside)
        
        return priorityButton
    }()
    
    private lazy var submitButton: UIButton = {
        let submitButton = UIButton()
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        let submitImage = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .bold, scale: .large))
        submitButton.setImage(submitImage, for: .normal)
        submitButton.tintColor = .halgoraedoDarkBlue
        submitButton.isEnabled = false
        submitButton.addTarget(self, action: #selector(tabSubmitButton(_:)), for: .touchUpInside)
        
        return submitButton
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        textView.resignFirstResponder()
        presentDismissActionSheet()
    }
    
    // MARK: - Initialize
    
    private func setupViews() {
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        view.addSubview(contentView)
        contentView.addSubview(textView)
        contentView.addSubview(accessoryView)
        accessoryView.addSubview(submitButton)
        accessoryView.addSubview(accessoryStackView)
        accessoryStackView.addArrangedSubview(dateButtonView)
        accessoryStackView.addArrangedSubview(priorityButton)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            accessoryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            accessoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            accessoryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalToConstant: 38),
            textView.bottomAnchor.constraint(equalTo: accessoryView.topAnchor),
            
            submitButton.topAnchor.constraint(equalTo: accessoryView.topAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: accessoryView.trailingAnchor, constant: -10),
            submitButton.bottomAnchor.constraint(equalTo: accessoryView.bottomAnchor, constant: -10),
            submitButton.widthAnchor.constraint(equalTo: submitButton.heightAnchor),
            
            accessoryStackView.topAnchor.constraint(equalTo: accessoryView.topAnchor, constant: 20),
            accessoryStackView.leadingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: 10),
            accessoryStackView.bottomAnchor.constraint(equalTo: accessoryView.bottomAnchor, constant: -10),
            accessoryStackView.trailingAnchor.constraint(lessThanOrEqualTo: submitButton.leadingAnchor, constant: -8),
        ])
        
        textView.delegate = self
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Methods
    
    func presentDismissActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let selectTaskAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "계속 편집", style: .default) {
            _ in
            self.textView.becomeFirstResponder()
        }
        [selectTaskAction, cancelAction].forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Selectors
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard !viewUpCheck,
            let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        keyboardHeight = keyboardSize.height
        self.view.frame.origin.y -= keyboardSize.height
        viewUpCheck = true
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard viewUpCheck else { return }
        self.view.frame.origin.y += keyboardHeight
        viewUpCheck = false
    }
    
    @objc func didTapPriorityButton(_ sender: UIButton) {
        let popoverViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "\(PopoverViewController.self)", creator: { (coder) -> PopoverViewController? in
            return PopoverViewController(coder: coder)
        })
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.popoverPresentationController?.delegate = self
        popoverViewController.popoverPresentationController?.sourceView = sender
        popoverViewController.popoverPresentationController?.sourceRect.origin.x = sender.frame.width / 2
        popoverViewController.viewModels = Priority.allCases.compactMap { $0.viewModel() }
        popoverViewController.selectHandler = { indexPath in
            popoverViewController.dismiss(animated: true, completion: nil)
            self.priority = Priority.init(rawValue: indexPath.row+1) ?? .four
        }
        
        present(popoverViewController, animated:true)
    }
    
    @objc private func tabSubmitButton(_ sender: UIButton) {
        guard let text = textView.text,
              !text.isEmpty
        else {
            return
        }
        
        delegate?.taskAddViewControllerDidDone(self)
        
//        var object: [String: Any] = [:]
//        object.updateValue(text, forKey: "taskTitle")
//        // object.updateValue(dueDate, forKey: "dueDate")
//        object.updateValue(priority, forKey: "priority")
//        object.updateValue(section, forKey: "section")
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "addTask"), object: object)
    }
}

// MARK: - TaskAddViewController TextView Delegate

extension TaskAddViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        submitButton.isEnabled = !text.isEmpty
        textView.text = textView.text.replacingOccurrences(of: placeHolder, with: "")
        textView.textColor = UIColor.black
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        if estimatedSize.height > 100 {
            return
        }
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                if textViewHeight < estimatedSize.height && textViewHeight != 0 {
                    self.view.frame.size.height += estimatedSize.height - textViewHeight
                    self.view.frame.origin.y -= estimatedSize.height - textViewHeight
                } else if textViewHeight > estimatedSize.height {
                    self.view.frame.size.height -= textViewHeight - estimatedSize.height
                    self.view.frame.origin.y += textViewHeight - estimatedSize.height
                }
                textViewHeight = estimatedSize.height
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.text.isEmpty else { return }
        textViewPlaceholder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.isEmpty else { return }
        textViewPlaceholder()
    }
    
    // MARK: Helper Functions
    
    func textViewPlaceholder() {
        if textView.text == placeHolder {
            textView.text = ""
            textView.textColor = UIColor.black
        } else if textView.text == "" {
            textView.text = placeHolder
            textView.textColor = UIColor.lightGray
        }
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension TaskAddViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
