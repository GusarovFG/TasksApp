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
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonItemPressed))
        let deleteAllButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAllTasks))
        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.rightBarButtonItems?.append(deleteAllButton)
        self.title = "Заметки"
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3450840844, green: 0.5538550592, blue: 0.5901235993, alpha: 1) 
        
        self.tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    private func deleteAllTasksButtonPressed() {
        let actionSheet = UIAlertController(title: "Удаление всех заметок", message: "Вы действительно хотите удалить все заметки?", preferredStyle: .alert)
        
        let deleteButton = UIAlertAction(title: "Удалить", style: .default) { _ in
            CoreDataManager.shared.deleteAllTasks()
            self.tasks = CoreDataManager.shared.fetchTasks()
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(deleteButton)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func barButtonItemPressed() {
        let deatilVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        self.navigationController?.pushViewController(deatilVC, animated: true)
    }
    
    @objc private func deleteAllTasks() {
        deleteAllTasksButtonPressed()
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
 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            CoreDataManager.shared.deleteTask(index: indexPath.row)
        }
    }
}
