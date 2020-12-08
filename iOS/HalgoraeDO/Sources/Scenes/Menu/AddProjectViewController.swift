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
    }
}

class AddProjectViewController: UIViewController {
    
    // MARK: - Properties
    
    var menuAddProjectDelegate: MenuAddProjectDelegate?
    var isList: Bool = true
    var projectColor: Int = 0
    
    // MARK: Views
    
    @IBOutlet weak var projectName: UITextField!
    @IBOutlet var colorSet: [UIButton]!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorButtonCheckmark(index: 0)
    }
    
    // MARK: - Methods
    
    private func colorButtonCheckmark(index: Int) {
        for i in 0..<colorSet.count {
            ProjectColors.init(rawValue: i)?.colorButton(colorSet[i])
        }
        colorSet[index].setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .bold, scale: .large)), for: .normal)
    }
    
    // MARK: IBActions
    
    @IBAction func tabCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tabAddProjectButton(_ sender: UIButton) {
        if projectName.text == "" {
            let alert = UIAlertController(title: "새 프로젝트", message: "프로젝트 이름을 입력하세요", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler : nil)
            alert.addAction(defaultAction)
            present(alert, animated: false, completion: nil)
            return
        }
        guard let projectName = projectName.text,
              let color = ProjectColors.init(rawValue: projectColor)?.color
        else {
            return
        }
        menuAddProjectDelegate?.addProject(projectName, isList, color)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showModeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isList = true
        } else {
            isList = false
        }
    }
    
    @IBAction func tabColorSet(_ sender: UIButton) {
        colorButtonCheckmark(index: sender.tag)
        projectColor = sender.tag
    }
}
