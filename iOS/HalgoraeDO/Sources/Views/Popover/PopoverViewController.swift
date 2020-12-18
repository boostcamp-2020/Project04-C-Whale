//
//  PopoverViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/26.
//

import UIKit

class PopoverViewController: UIViewController {
    
    var viewModels = [PopoverViewModelType]()
    var selectHandler: ((IndexPath) -> Void)?
    /// default:  CGSize(width: 250, height: 44)
    var cellSize: CGSize = CGSize(width: 250, height: 44)
    
    @IBOutlet weak private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureContentSize()
    }
    
    private func configureContentSize() {
        preferredContentSize = CGSize(width: cellSize.width, height: cellSize.height * CGFloat(viewModels.count))
    }
}

extension PopoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "popoverCell", for: indexPath)
        let viewModel = viewModels[indexPath.row]
        cell.textLabel?.text = viewModel.title
        cell.imageView?.tintColor = viewModel.tintColor
        cell.imageView?.image = viewModel.image
        return cell
    }
}

extension PopoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectHandler?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellSize.height
    }
}
