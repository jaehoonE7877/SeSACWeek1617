//
//  ViewController.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/18.
//

import UIKit

class SimpleTableViewController: UITableViewController {
    
    let list = ["슈비버거", "프랭크", "자갈치", "고래밥"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

extension SimpleTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        var content = cell.defaultContentConfiguration()
        
        content.text = list[indexPath.row] // textLabel
        
        content.image = UIImage(systemName: "star")
        
        content.secondaryText = "안녕하세요" // detailTextLabel
        
        cell.contentConfiguration = content
        
        return cell
    }
    
}