//
//  TaskAddViewController.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/11/26.
//

import UIKit

class TaskAddViewController: UIViewController {
    
    var section: Int = 0

    // MARK: - Properties
    
    private var viewUpCheck: Bool = false
    private var keyboardHeight: CGFloat = 0
    private var textViewHeight: CGFloat = 0
    private let placeHolder: String = "예. 11월 27일날 데모 발표하기"
    private var dueDate: Date = Date()
    private var priority: Int = 4
    
    // MARK: - Views
    
    private let textView = UITextView()
    private let priorityButton = UIButton()
    private let submitButton = UIButton()
    private let dateButton: DatePickerButtonView = {
        let dateButton = DatePickerButtonView()
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        
        return dateButton
    }()

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        configureDataPickerView()
        configurePriority()
        configureSubmit()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        DispatchQueue.main.async {
            self.textView.becomeFirstResponder()
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if !viewUpCheck {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                keyboardHeight = keyboardSize.height
                self.view.frame.origin.y -= keyboardSize.height
            }
            viewUpCheck = true
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if viewUpCheck {
            self.view.frame.origin.y += keyboardHeight
            viewUpCheck = false
        }
    }
}

// MARK: - TaskAddViewController TextView Delegate

extension TaskAddViewController: UITextViewDelegate {
    
    private func configureTextView() {
        textView.delegate = self
        textView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        submitButton.alpha = text.isEmpty ? 0.5 : 0.9
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
        if textView.text == "" {
            textViewPlaceholder()
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textViewPlaceholder()
        }
    }
    
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

// MARK: - Date Picker Configure & Method

extension TaskAddViewController {
    
    private func configureDataPickerView() {
        view.addSubview(dateButton)
        dateButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 15).isActive = true
        dateButton.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
    }
}

// MARK: - Priority Button Configure & Method

private extension TaskAddViewController {
    
    func configurePriority() {
        view.addSubview(priorityButton)
        let calendarImage = UIImage(systemName: "flag", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .light, scale: .small))
        priorityButton.setImage(calendarImage, for: .normal)
        priorityButton.setTitle(" 우선 순위 없음", for: .normal)
        priorityButton.setTitleColor(.gray, for: .normal)
        priorityButton.tintColor = .gray
        priorityButton.backgroundColor = .clear
        priorityButton.layer.cornerRadius = 10
        priorityButton.layer.borderWidth = 1
        priorityButton.layer.borderColor = UIColor.gray.cgColor
        priorityButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)
        priorityButton.translatesAutoresizingMaskIntoConstraints = false
        priorityButton.leadingAnchor.constraint(equalTo: dateButton.trailingAnchor, constant: 15).isActive = true
        priorityButton.topAnchor.constraint(equalTo: dateButton.topAnchor).isActive = true
        priorityButton.addTarget(self, action: #selector(priorityPopover), for: .touchUpInside)
    }
    
    @objc func priorityPopover(_ sender: UIButton) {
        let popoverViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: String(describing: PopoverViewController.self), creator: { (coder) -> PopoverViewController? in
            return PopoverViewController(coder: coder)
        })
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.popoverPresentationController?.delegate = self
        popoverViewController.popoverPresentationController?.sourceView = sender
        popoverViewController.popoverPresentationController?.sourceRect = .init(x: sender.frame.width / 2, y: 0, width: 0, height: 0)
        popoverViewController.viewModels = Priority.allCases.compactMap { $0.viewModel() }
        popoverViewController.modalTransitionStyle = .crossDissolve
        popoverViewController.selectHandler = { indexPath in
            popoverViewController.dismiss(animated: true, completion: nil)
            self.changePriority(row: indexPath.row)
            self.priority = indexPath.row
        }
        present(popoverViewController, animated:true)
    }
    
    private func changePriority(row: Int) {
        let calendarImage = UIImage(systemName: "flag.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .light, scale: .small))
        priorityButton.setImage(calendarImage, for: .normal)
        guard let priorityViewModel = Priority.init(rawValue: row + 1)?.viewModel() else { return }
        priorityButton.tintColor = priorityViewModel.tintColor
        priorityButton.setTitle(" \(priorityViewModel.title)", for: .normal)
    }
}

extension TaskAddViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - Submit Button Configure & Method

private extension TaskAddViewController {
    
    func configureSubmit() {
        self.view.addSubview(submitButton)
        let submitImage = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .bold, scale: .large))
        submitButton.setImage(submitImage, for: .normal)
        submitButton.alpha = 0.5
        submitButton.tintColor = .red
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        submitButton.topAnchor.constraint(equalTo: dateButton.topAnchor).isActive = true
        submitButton.addTarget(self, action: #selector(tabSubmitButton), for: .touchUpInside)
    }
    
    @objc func tabSubmitButton(_ sender: UIButton) {
        guard let text = textView.text else { return }
        if text == "" {
            return
        } else {
            var object: [String: Any] = [:]
            object.updateValue(text, forKey: "taskTitle")
            object.updateValue(dueDate, forKey: "dueDate")
            object.updateValue(priority, forKey: "priority")
            object.updateValue(section, forKey: "section")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "addTask"), object: object)
        }
    }
}



