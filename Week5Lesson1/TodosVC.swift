//
//  TodosVC.swift
//  Week5Lesson1
//
//  Created by Amani Atiah on 23/04/1443 AH.
//

import UIKit
import CoreData

class TodosVC: UIViewController {

    var todosArray: [Todo] = []
    @IBOutlet weak var todosTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todosArray = getTodos()
        
        var m = Math()
//
//        do {
//            var r = try m.divide(num1: 40, num2: 10)
//            print(r)
//        } catch {
//
//            let alert = UIAlertController(title: "error", message: "can't divide by zero", preferredStyle: .alert)
//
//            let action = UIAlertAction(title: "ok", style: .default, handler: nil)
//
//            alert.addAction(action)
//
//            present(alert, animated: true, completion: nil)
//        }
//
        // new notification
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded), name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil)
        
        // edit notification
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoEdited), name: NSNotification.Name(rawValue: "CurrentTodoEdited"), object: nil)
        
        // delete notification
        NotificationCenter.default.addObserver(self, selector: #selector(todoDeleted), name: NSNotification.Name(rawValue: "TodoDeleted"), object: nil)
        
        todosTableView.dataSource = self
        todosTableView.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func newTodoAdded(notification: Notification){
        if let myTodo = notification.userInfo?["addedTodo"] as? Todo {
            todosArray.append(myTodo)
            todosTableView.reloadData()
            storeTodo(todo: myTodo)

        }
    }
    
    @objc func currentTodoEdited(notification: Notification) {
        
        if let todo = notification.userInfo?["editedTodo"] as? Todo {
            if let index = notification.userInfo?["editedTodoIndex"] as? Int {
                todosArray[index] = todo
                todosTableView.reloadData()
                updateTodo(todo: todo, index: index)
            }
           }
        
        
    }
    
    @objc func todoDeleted(notification: Notification) {
        if let index = notification.userInfo?["deletedTodoIndex"] as? Int {
            
            todosArray.remove(at: index)
            todosTableView.reloadData()
            deleteTodo(index: index)
            
        }
        
    }
    
    func storeTodo(todo: Todo) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContext = appDelegate.persistentContainer.viewContext
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todos", in: manageContext) else {return}
        let todoObject = NSManagedObject.init(entity: todoEntity, insertInto: manageContext)
        todoObject.setValue(todo.title, forKey: "title")
        todoObject.setValue(todo.details, forKey: "details")

        if let image = todo.image {
            let imageData = image.jpegData(compressionQuality: 1)
            todoObject.setValue(imageData, forKey: "image")
        }
        do {
            try manageContext.save()
            print("success")
        } catch {
            print("error")
        }
        
    }
    
    func updateTodo(todo: Todo, index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do {
            
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            
        
            result[index].setValue(todo.title, forKey: "title")
            result[index].setValue(todo.details, forKey: "details")
            
            if let image = todo.image {
                let imageData = image.jpegData(compressionQuality: 1)
                result[index].setValue(imageData, forKey: "image")

            }
            
            try context.save()
            
        } catch {
            print("=====Error=====")
        }
    }
    
    func deleteTodo(index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do {
            
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let todoDelete = result[index]
            context.delete(todoDelete)
            
            try context.save()
            
        } catch {
            print("=====Error=====")
        }
    }
    
    func getTodos() -> [Todo] {
        var todos: [Todo] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            for managedTodo in result {
                print(managedTodo)
                let title = managedTodo.value(forKey: "title") as? String
                let details = managedTodo.value(forKey: "details") as? String
                
                var todoImage: UIImage? = nil
                if let imageFromContext = managedTodo.value(forKey: "image") as? Data {
                    todoImage = UIImage(data: imageFromContext)
                }

                let todo = Todo(title: title ?? "", image: todoImage, details: details ?? "")
                todos.append(todo)
            }
        } catch {
            print("=====Error=====")
        }
        return todos
    }
}

extension TodosVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
        
        let todo = todosArray[indexPath.row]
        cell.todoTitleLabel.text = todo.title
        if todo.image != nil {
            cell.toDoImageView.image = todo.image
            
        } else {
            cell.toDoImageView.image = UIImage(named: "Image-4")
        }
        cell.toDoImageView.layer.cornerRadius = cell.toDoImageView.frame.width/2
        
        
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let todo = todosArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailsVC") as? TodoDetailsVC
    
        
        if let viewController = vc {
            viewController.todo = todo
            viewController.index = indexPath.row
          
            navigationController?.pushViewController(viewController, animated: true)
        }
     
    }
    
    
}
