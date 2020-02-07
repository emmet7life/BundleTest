//
//  ELEdgeViewController.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/5/11.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit

class ELEdgeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ELEdgeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let red = CGFloat(arc4random_uniform(UInt32(100))) * 0.01
        let green = CGFloat(arc4random_uniform(UInt32(100))) * 0.01
        let blue = CGFloat(arc4random_uniform(UInt32(100))) * 0.01
        cell.contentView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return cell
    }
}
