//
//  ViewController7.swift
//  BundleTest
//
//  Created by jianli chen on 2019/5/28.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit
import MXParallaxHeader

class ViewController7: UIViewController {

    @IBOutlet weak var scrollView: MXScrollView!
    let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
    let headerContent = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .purple
        
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: view.width, height: 200)
        header.backgroundColor = .clear
        
//        let headerContent = UIView()
        headerContent.frame = CGRect(x: 0, y: 0, width: view.width, height: 200)
        headerContent.backgroundColor = .gray
        
        header.addSubview(headerContent)
        
        scrollView.parallaxHeader.view = header
        scrollView.parallaxHeader.height = 200
        scrollView.parallaxHeader.minimumHeight = 88.0+44.0
        scrollView.parallaxHeader.mode = .fill
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            automaticallyAdjustsScrollViewInsets = false
        }
        
        edgesForExtendedLayout = .top
        
//        tableView.bounces = false
        
//        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: 200)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = 44.0
        tableView.clipsToBounds = false
        scrollView.clipsToBounds = false
        scrollView.parallaxHeader.view?.clipsToBounds = false
        scrollView.parallaxHeader.contentView.clipsToBounds = false
//        tableView.delegate = self
        
        scrollView.addSubview(tableView)
        
        scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var frame = view.bounds
        scrollView.frame = frame
        scrollView.contentSize = frame.size
        
        frame.size.height -= scrollView.parallaxHeader.minimumHeight
        tableView.frame = frame
//        tableView.contentSize =
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewController7: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let colors: [UIColor] = [
            UIColor.red,
            UIColor.gray,
            UIColor.green,
            UIColor.purple
        ]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row % colors.count]
        return cell
    }
    
}

extension ViewController7: MXScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = self.scrollView.parallaxHeader.progress
        print("progress is \(progress)")
        headerContent.backgroundColor = UIColor.gray.withAlphaComponent(progress)
    }
}
