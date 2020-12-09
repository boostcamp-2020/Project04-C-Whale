//
//  AddProjectViewController.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/12/06.
//

import UIKit

protocol MenuAddProjectDelegate {
    func addProject(_ projectName: String, _ showMode: Bool, _ color: String)
}

enum ProjectColors: Int, CaseIterable {
    case gray = 0
    case red
    case yellow
    case green
    case skyblue
    case pink
    
    var color: String {
        switch self {
        case .gray: return "#BDBDBD"
        case .red: return "#FFA7A7"
        case .yellow: return "#FFE08C"
        case .green: return "#B7F0B1"
        case .skyblue: return "#B2CCFF"
        case .pink: return "#FFB2D9"
        }
    }
    
    func colorButton(_ button: UIButton) {
        button.tintColor = UIColor(hexFromString: color)
        button.setImage(UIImage(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .bold, scale: .large)), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .bold, scale: .large)), for: .selected)
    }
}

class AddProjectViewController: UIViewController {
    
    // MARK: - Properties
    
    var menuAddProjectDelegate: MenuAddProjectDelegate?
    private var isList: Bool = true
    private var projectColor: ProjectColors? = ProjectColors.gray
    
    // MARK: Views
    
    @IBOutlet weak private var projectNameTextField: UITextField!
    @IBOutlet private var colorSet: [UIButton]!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configColorSets()
    }
    
    // MARK: - Methods
    
    private func configColorSets() {
        colorSet[0].isSelected = true
        for i in 0..<colorSet.count {
            ProjectColors.init(rawValue: i)?.colorButton(colorSet[i])
        }
    }
    
    // MARK: IBActions
    
    @IBAction private func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func tapAddProject(_ sender: UIButton) {
        if projectNameTextField.text == "" {
            let alert = UIAlertController(title: "새 프로젝트", message: "프로젝트 이름을 입력하세요", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler : nil)
            alert.addAction(defaultAction)
            present(alert, animated: false, completion: nil)
            return
        }
        guard let projectName = projectNameTextField.text,
              let color = projectColor?.color
        else {
            return
        }
        menuAddProjectDelegate?.addProject(projectName, isList, color)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func showModeSegment(_ sender: UISegmentedControl) {
        isList = sender.selectedSegmentIndex == 0
    }
    
    @IBAction private func tapColorSet(_ sender: UIButton) {
        for button in colorSet {
            button.isSelected = false
        }
        sender.isSelected = true
        projectColor = ProjectColors.init(rawValue: sender.tag)
    }
}
