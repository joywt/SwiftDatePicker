//
//  SwiftDatePicker.swift
//  SwiftDatePicker
//
//  Created by wang tie on 2017/3/3.
//  Copyright © 2017年 360jk. All rights reserved.
//

import UIKit
import SnapKit
import SwiftDate
class SwiftDatePicker: UIView,UIPickerViewDelegate,UIPickerViewDataSource {

    static let MINYEAR = 1970
    static let MAXYEAR = 2050
    @IBOutlet weak var segementView: UISegmentedControl!
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
    enum  DateStyle {
        case styleYearMonthDayHourMinute
        case styleMonthDayHourMinute
        case styleYearMonthDay
        case styleMonthDay
        case styleHourMinute
    }
    
    var dateStyle: DateStyle = DateStyle.styleYearMonthDayHourMinute  {
        didSet{
            pickerView.reloadAllComponents()
        }
    }
    var themeColor = UIColor.init(red: 247/255, green: 137/255, blue: 51/255, alpha: 1.0)
    var yearSource = [String]()
    let monthSource = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    var hourSource = [String]()
    var minuteSource = [String]()
    var yearIndex = 0 {
        didSet{
            yearLabel.text = yearSource[yearIndex]
        }
    }
    var monthIndex:Int = 0 {
        didSet{
            switch dateStyle {
            case .styleYearMonthDayHourMinute,.styleYearMonthDay: pickerView.reloadComponent(2)
            case .styleMonthDay: pickerView.reloadComponent(1)
            default: break
            }
            
        }
    }
    
    var swiftDatePicker:UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        swiftDatePicker = loadViewFromNib()
        swiftDatePicker.layer.cornerRadius = 5.0
        swiftDatePicker.layer.masksToBounds = true
        addSubview(swiftDatePicker)
        addConstraints()
        
        for i in 1970...2050{
            yearSource.append("\(i)")
        }
        
        for i in 0..<60{
            if i < 24 {
                hourSource.append("\(i)")
            }
            minuteSource.append("\(i)")
        }
        showCurrentTime()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        fatalError("init(coder:) has not been implemented")
    }
    
    func loadViewFromNib()-> UIView {
        let className = type(of:self)
        let bundle = Bundle(for:className)
        let nib = UINib.init(nibName: "DatePicker", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func addConstraints() {
        swiftDatePicker.translatesAutoresizingMaskIntoConstraints = false
        swiftDatePicker.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
    }

    func addLabelWithNames(nameArr:[String]) {
        print("self ...\(yearLabel)")
        for view in yearLabel.subviews {
            if view is UILabel{
                view.removeFromSuperview()
            }
        }
        
        var i = 0
        let pickWidth = self.pickerView.frame.size.width
        for name in nameArr {
            let cellWidth = pickWidth / CGFloat(nameArr.count)
            let x = cellWidth * CGFloat(i)
            let y = self.yearLabel.frame.size.height / 2 - 15
            let label = UILabel.init(frame: CGRect.init(x: x, y: y, width: cellWidth, height: 15))
            label.text =  name
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = self.themeColor
            self.yearLabel.addSubview(label)
            i = i + 1
        }
        
    }
    
    var dayNumber:Int {
        let month = monthSource[monthIndex]
        switch month {
        case "1","3","5","7","8","10","12": return 31
        case "4","6","9","11": return 30
        case "2": return runNian ? 29 : 28
        default:break
        }
        return 0
    }
    var daySource:[String] {
        var arr = [String]()
        for i in 1...dayNumber {
            arr.append("\(i)")
        }
        return arr
    }
    var runNian:Bool {
        if let year = Int(yearSource[yearIndex]){
            if year % 4 == 0 {
                if year % 100 == 0 {
                    if year % 400 == 0 {
                        return true
                    }else {
                        return false
                    }
                }else {
                    return false
                }
            }else {
                return false
            }
        }
        return false
    }
    
    
    func showCurrentTime() {
        let date = Date()
        yearIndex = date.year - SwiftDatePicker.MINYEAR
        monthIndex = date.month - 1
        let dayIndex = date.day - 1
        let hourIndex = date.hour
        let minuteIndex = date.minute
        switch dateStyle {
        case .styleYearMonthDayHourMinute:
            pickerView.selectRow(yearIndex, inComponent: 0, animated: false)
            pickerView.selectRow(monthIndex, inComponent: 1, animated: false)
            pickerView.selectRow(dayIndex, inComponent: 2, animated: false)
            pickerView.selectRow(hourIndex, inComponent: 3, animated: false)
            pickerView.selectRow(minuteIndex, inComponent: 4, animated: false)
            
        case .styleMonthDayHourMinute:
            pickerView.selectRow(monthIndex, inComponent: 0, animated: false)
            pickerView.selectRow(dayIndex, inComponent: 1, animated: false)
            pickerView.selectRow(hourIndex, inComponent: 2, animated: false)
            pickerView.selectRow(minuteIndex, inComponent: 3, animated: false)
        case .styleYearMonthDay:
            pickerView.selectRow(yearIndex, inComponent: 0, animated: false)
            pickerView.selectRow(monthIndex, inComponent: 1, animated: false)
            pickerView.selectRow(dayIndex, inComponent: 2, animated: false)
        case .styleMonthDay:
            pickerView.selectRow(monthIndex, inComponent: 0, animated: false)
            pickerView.selectRow(dayIndex, inComponent: 1, animated: false)
        case .styleHourMinute:
            pickerView.selectRow(hourIndex, inComponent: 0, animated: false)
            pickerView.selectRow(minuteIndex, inComponent: 1, animated: false)
        }
        
        
    }
//#pragma mark - delegate & dataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch dateStyle {
        case .styleYearMonthDayHourMinute:
            self.addLabelWithNames(nameArr: ["年","月","日","时","分"])
            return 5
        case .styleMonthDayHourMinute:
            self.addLabelWithNames(nameArr: ["月","日","时","分"])
            return 4
        case .styleYearMonthDay:
            self.addLabelWithNames(nameArr: ["年","月","日"])
            return 3
        case .styleMonthDay:
            self.addLabelWithNames(nameArr: ["月","日"])
            return 2
        case .styleHourMinute:
            self.addLabelWithNames(nameArr: ["时","分"])
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numbersOfRows: [Int] {
            switch dateStyle {
            case .styleYearMonthDayHourMinute:return [yearSource.count,monthSource.count,dayNumber,hourSource.count,minuteSource.count]
            case .styleMonthDayHourMinute:return [monthSource.count,dayNumber,hourSource.count,minuteSource.count]
            case .styleYearMonthDay:return [yearSource.count,monthSource.count,dayNumber]
            case .styleMonthDay:return [monthSource.count,dayNumber]
            case .styleHourMinute:return [hourSource.count,minuteSource.count]
            }
        }
//        print("number \(numbersOfRows)")
        return numbersOfRows[component]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        var title:String {
            switch dateStyle {
            case .styleYearMonthDayHourMinute:
                switch component {
                case 0: return yearSource[row]
                case 1: return monthSource[row]
                case 2: return daySource[row]
                case 3: return hourSource[row]
                case 4: return minuteSource[row]
                default: break
                }
            case .styleMonthDayHourMinute:
                switch component {
                case 0: return monthSource[row]
                case 1: return daySource[row]
                case 2: return hourSource[row]
                case 3: return minuteSource[row]
                default: break
                }
            case .styleYearMonthDay:
                switch component {
                case 0: return yearSource[row]
                case 1: return monthSource[row]
                case 2: return daySource[row]
                default: break
                }
            case .styleMonthDay:
                switch component {
                case 0: return monthSource[row]
                case 1: return daySource[row]
                default: break
                }
            case .styleHourMinute:
                switch component {
                case 0: return hourSource[row]
                case 1: return minuteSource[row]
                default: break
                }
            }
            return ""

        }
//        print("title ...\(title)")
        label.text = title
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch dateStyle {
        case .styleYearMonthDayHourMinute,.styleYearMonthDay:
            if component == 0 { //year
                yearIndex = row
            }else if component == 1 { // 月
                monthIndex = row
            }
        case .styleMonthDay:
            if component == 0 {
                monthIndex = row
            }
        default: break
        }
    }
    
}
