//
//  ViewController.swift
//  DongHo
//
//  Created by Nguyen Trung on 11/5/20.
//  Copyright © 2020 Nguyen Hung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var clockView: UIImageView!
    @IBOutlet weak var kimGioView: UIView!
    @IBOutlet weak var kimPhutView: UIView!
    @IBOutlet weak var kimGiayView: UIView!
    @IBOutlet weak var centerView: UIView!
    
    /*NSDate là một class được sử dụng rất nhiều khi viết ứng dụng để làm việc với các dữ liệu date time

    Khi muốn lấy ra giá trị của một phần của NSDate như ngày, tháng hoặc giờ, phút, để làm được việc này, chúng ta cần sử dụng lớp NSDateComponents

    Khi muốn chuyển đổi giữa NSDate và NSDateComponents, chúng ta cần sử dụng thêm lớp NSCalendar. Lớp NSCalendar là lớp thực hiện việc biến đổi từ NSDate thành NSDateComponents và ngược lại

    Ở ứng dụng này, chúng ta định nghĩa ra 2 biến kiểu NSDate và NSCalendar*/
    
    let currentDate = NSDate()
    let calendar = NSCalendar.current
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        runDongHo()
    }
    
    //Định nghĩa một hàm setupUI() để luôn xác định kim nằm ở tâm so với đồng hồ
    func setUI(){
        view.bringSubviewToFront(centerView)
        
        clockView.center = view.center
        
        centerView.frame.size = CGSize(width: 20, height: 20)
        centerView.center = view.center
        centerView.layer.cornerRadius = centerView.bounds.width/2
        centerView.layer.masksToBounds = true
        centerView.backgroundColor = UIColor.black
        
        kimGioView.frame.size = CGSize(width: clockView.bounds.size.width/10*2.5, height: 6)
        kimGioView.center = clockView.center
        
        kimPhutView.frame.size = CGSize(width: clockView.bounds.size.width/10*3, height: 4)
        kimPhutView.center = clockView.center
        
        kimGiayView.frame.size = CGSize(width: clockView.bounds.size.width/10*3.5, height: 2)
        kimGiayView.center = clockView.center
    }
    
    //Định nghĩa hàm setAnchorPoint để thay đổi điểm neo kim đồng hồ
    func setAnchorPoint(kimView: UIView, point: CGPoint){
        kimView.layer.anchorPoint = point
    }
    
    //Định nghĩa hàm getLocation() để xác định vị trí kim và góc quay
    func getLocation(kimView: UIView, alpha: CGFloat){
        let r = kimView.bounds.size.height/2
        kimView.layer.cornerRadius = r
        
        setAnchorPoint(kimView: kimView, point: CGPoint(x: 0, y: 0.5))
        kimView.transform = CGAffineTransform(rotationAngle: alpha)
    }
    
    //Định nghĩa một hàm setTimer để tính góc quay ban đầu của kim theo thời gian thực (tính từ thời điểm 0h)
    func setTimer() -> (hour: CGFloat, minute: CGFloat, second: CGFloat){
        let hour = calendar.component(.hour, from: currentDate as Date)
        let minute = calendar.component(.minute, from: currentDate as Date)
        let second = calendar.component(.second, from: currentDate as Date)
        let hourInAboutSecond = hour*60*60 + minute*60 + second
        let minuteInAboutSecond = minute*60 + second
        
        let firstAlphaHour = CGFloat.pi * (2*CGFloat(hourInAboutSecond)/12/60/60 - 0.5)
        let firstAlphaMinute = CGFloat.pi * (2*CGFloat(minuteInAboutSecond)/12/60 - 0.5)
        let firstAlphaSecond = CGFloat.pi * (2*CGFloat(second)/12 - 0.5)
        
        return (firstAlphaHour, firstAlphaMinute, firstAlphaSecond)
    }
    
    //Định nghĩa hàm runDongHo()
    func runDongHo() {
        getLocation(kimView: kimGioView, alpha: setTimer().hour)
        getLocation(kimView: kimPhutView, alpha: setTimer().minute)
        getLocation(kimView: kimGiayView, alpha: setTimer().second)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runLoop), userInfo: nil, repeats: true)
    }
    
    //- Định nghĩa hàm runLoop():Sử dụng concatenating để nối tiếp các bước transform giúp cho kim có thể quay theo vòng tròn
    @objc func runLoop(){
        let omegaGiay = CGAffineTransform(rotationAngle: CGFloat.pi*2/60)
        let omegaPhut = CGAffineTransform(rotationAngle: CGFloat.pi*2/60/60)
        let omegaGio = CGAffineTransform(rotationAngle: CGFloat.pi*2/60/60/12)
        
        kimGiayView.transform = kimGiayView.transform.concatenating(omegaGiay)
        kimPhutView.transform = kimPhutView.transform.concatenating(omegaPhut)
        kimGioView.transform = kimGioView.transform.concatenating(omegaGio)
    }
}

