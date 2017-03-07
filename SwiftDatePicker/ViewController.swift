//
//  ViewController.swift
//  SwiftDatePicker
//
//  Created by wang tie on 2017/3/3.
//  Copyright © 2017年 360jk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let nib = UINib.init(nibName: "DatePicker", bundle: Bundle.main)
        let bounds = UIScreen.main.bounds
//        let swiftDatePicker:SwiftDatePicker = Bundle.main.loadNibNamed("DatePicker", owner: nil, options: nil)?.first as! SwiftDatePicker
        
       let swiftDatePicker = SwiftDatePicker.init(frame: CGRect.init(x: 0, y: 0, width:bounds.size.width , height: bounds.size.height))
        swiftDatePicker.dateStyle = .styleYearMonthDayHourMinute
        self.view.addSubview(swiftDatePicker)
        // Do any additional setup after loading the view, typically from a nib.
    }

    func loadViewFromNib()-> UIView {
        let className = type(of:self)
        let bundle = Bundle(for:className)
        let nib = UINib.init(nibName: "DatePicker", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

