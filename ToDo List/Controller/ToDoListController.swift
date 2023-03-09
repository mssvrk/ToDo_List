//
//  ToDoListController.swift
//  ToDo List
//
//  Created by Mac on 03/03/2023.
//  Copyright © 2023 mssvrk. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TaskCell"

class ToDoListController: UIViewController {
    
    // MARK: Properties
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = .powderPink
        tableView.separatorColor = .azure
        
        return tableView
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 35).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return button
    }()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    .viewContext
    
    private var tasks = [ToDoListTask]()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        
        getAllTasks()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupNavController()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Setting up views & constraints
    
    func setupViews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    // MARK: Navigation Controller
    
    func setupNavController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .azure
        navigationController?.navigationBar.tintColor = .powderPink
        
        navigationItem.title = "To Do List"
        let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.powderPink, NSAttributedString.Key.font: UIFont(name: "ProximaNova-Bold", size: 40)!]
        navigationController?.navigationBar.largeTitleTextAttributes = titleAttributes
        

        addButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        let rightButton = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = rightButton
    
    }
    
    // MARK: Core Data
    
    func getAllTasks() {
        do {
            tasks = try context.fetch(ToDoListTask.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch let error as NSError {
            print("Could not fetch, error: \(error), \(error.userInfo)")
        }
    }
    
    func edit(task: ToDoListTask, newName: String) {
        task.name = newName
        
        do {
            try context.save()
            getAllTasks()
        } catch let error as NSError {
            print("Could not update, error: \(error), \(error.userInfo)")
        }
    }
    
    @objc func addTask() {
        
        let alert = UIAlertController(title: "New Task", message: "Add New To Do List Task", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [unowned self] action in
            guard let textField = alert.textFields?.first, let text = textField.text, !text.isEmpty else {
                return
            }
            self.createTask(name: text)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    
    func createTask(name: String) {
        let newTask = ToDoListTask(context: context)
        newTask.name = name
        newTask.dateCreated = Date() as NSDate
        newTask.isDone = false
        
        
        do {
            try context.save()
            getAllTasks()
        } catch let error as NSError {
            print("Could not dave, error: \(error), \(error.userInfo)")
        }
    }
    func delete(task: ToDoListTask) {
        context.delete(task)
        
        do {
            try context.save()
            getAllTasks()
        } catch let error as NSError {
            print("Could not delete, error: \(error), \(error.userInfo)")
        }
    }
}

extension ToDoListController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TaskCell
        
        cell.nameLabel.text = task.name?.capitalized
        cell.checkmarkImageView.image = task.isDone ? UIImage(named: "checkmark") : UIImage(named: "circle")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = tasks[indexPath.row]
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Done/Undone", style: .default, handler: { _ in
            let cell = tableView.cellForRow(at: indexPath) as! TaskCell
            self.tasks[indexPath.row].isDone = self.tasks[indexPath.row].isDone ? false : true
            cell.checkmarkImageView.image = self.tasks[indexPath.row].isDone ? UIImage(named: "checkmark") : UIImage(named: "circle")
            
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let edit = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .alert)
            edit.addTextField(configurationHandler: nil)
            edit.textFields?.first?.text = task.name
            edit.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [unowned self] _ in
                guard let textField = edit.textFields?.first, let newName = textField.text, !newName.isEmpty else {
                    return
                }
                self.edit(task: task, newName: newName)
            }))
            self.present(edit, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [unowned self] _ in
            self.delete(task: task)
        }))
        present(sheet, animated: true)
    
    }
    
}
