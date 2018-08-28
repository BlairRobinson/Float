//
//  MessageTableViewController.swift
//  Float
//
//  Created by Blair Robinson on 28/08/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController {

    @IBOutlet weak var newMessageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newMessageBtn.layer.cornerRadius = 15
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)

        
        return cell
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
