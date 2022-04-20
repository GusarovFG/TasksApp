//
//  TasksTableViewController.swift
//  TasksApp
//
//  Created by Фаддей Гусаров on 19.04.2022.
//

import UIKit

class TasksTableViewController: UITableViewController {
    
    var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tasks = CoreDataManager.shared.fetchTasks()
        self.tableView.reloadData()
    }
    
    private func setupUI() {
        let navigationItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonItemPressed))
        self.navigationItem.rightBarButtonItem = navigationItem
        self.title = "Заметки"
        
        self.tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    @objc func barButtonItemPressed() {
        let deatilVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        self.navigationController?.pushViewController(deatilVC, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tasks.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = self.tasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = task.title
        content.secondaryText = task.creationDate
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.task = self.tasks[indexPath.row]
        detailVC.indexOfTask = indexPath.row
        self.navigationController?.pushViewController(detailVC, animated: true)
    }



    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            CoreDataManager.shared.deleteTask(index: indexPath.row)
        }
    }

    // MARK: - Navigation


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
