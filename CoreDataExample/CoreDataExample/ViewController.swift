//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Harsha Agarwal on 03/05/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = model[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let name = model.name, let date = model.createdAt {
            cell.textLabel?.text = "\(name) - \(date)"
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    private var model = [ToDoList]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    /// contains all of coredata implementation
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CORE DATA TODO LISTS"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        getItems()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
        // Do any additional setup after loading the view.
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit",
                                      style: .destructive ,
                                      handler: {[weak self] _ in
            guard let field =  alert.textFields?.first,
                  let  text = field.text, !text.isEmpty else {
                return
            }
            self?.createItem(name: text)
        }))
        present(alert, animated: false)
    }
    
    func getItems() {
        do {
            model = try context.fetch(ToDoList.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            //error
        }
    }
    
    func createItem(name: String) {
        let newData  = ToDoList(context: context)
        newData.name = name
        newData.createdAt = Date()
        do {
            try context.save()
            getItems()
        } catch {
            ///error
        }
    }

    func deleteItems(item: ToDoList) {
        context.delete(item)
        
        do {
            try context.save()
            getItems()
        } catch {
            //error
        }
    }
    
    func updateItem(item: ToDoList, name: String) {
        item.name = name
        do {
            try context.save()
        } catch {
            //error
        }
    }

}

