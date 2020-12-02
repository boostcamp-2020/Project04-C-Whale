//
//  DatePickerButtonView.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/02.
//

import UIKit

class DatePickerButtonView: UIView {
    
    // MARK: - Views
    
    @IBOutlet weak private var dateButton: UIButton!
    @IBOutlet weak private(set) var contentView: UIView!
    @IBOutlet weak private(set) var datePicker: UIDatePicker!
    private(set) var dateFormat = "yyyy년 MM월 dd일"
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        UINib(nibName: "\(DatePickerButtonView.self)", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        dateButton.setTitle(Date().toString(format: dateFormat), for: .normal)
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = 10
        datePicker.alpha = 0.011
    }
    
    // MARK: - Methods
    
    func configure(dateFormat: String) {
        self.dateFormat = dateFormat
    }
    
    // MARK: IBActions
    
    @IBAction private func valueChangedDatePicker(_ sender: UIDatePicker) {
        let dateString = sender.date.toString(format: "yyyy년 MM월 dd일")
        dateButton.setTitle(dateString, for: .normal)
    }
}
