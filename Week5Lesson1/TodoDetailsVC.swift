//
//  TodoDetailsVC.swift
//  Week5Lesson1
//
//  Created by Amani Atiah on 23/04/1443 AH.
//

import UIKit

class TodoDetailsVC: UIViewController {

    var todo: Todo!
    var index: Int!
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var detalisLabel: UILabel!
    @IBOutlet weak var todoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if todo.image != nil {
            todoImageView.image = todo.image

        } else {
            todoImageView.image = UIImage(named: "Image-4")
        }
        
        setUpUI()
        // Do any additional setup after loading the view.
        
        //tabBarController?.tabBar.isHidden = true


        
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoEdited), name: NSNotification.Name(rawValue: "CurrentTodoEdited"), object: nil)
    }
    
    
    

    @IBAction func editTodoButtonClicked(_ sender: Any) {
   
        
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "NewTodoVC") as? NewTodoVC {
            
            
            viewController.isCreationTodo = false
            viewController.editedTodo = todo
            viewController.editedTodoIndex = index
            
        navigationController?.pushViewController(viewController, animated: true)
     
        }
    }
    
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        
        let confirmAlert = UIAlertController(title: "تنبية", message: "هل انت متاكد من رغبتك في اتمام عملية الحذف", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "تاكيد الحذف", style: .destructive) {
            alert in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TodoDeleted"), object: nil, userInfo: ["deletedTodoIndex" : self.index])
            
            let alert = UIAlertController(title: "تم", message: "تم حذف المهمة بنجاح", preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "تم", style: .default) {
                alert in
                self.navigationController?.popViewController(animated: true)
                
            }
            alert.addAction(closeAction)
            self.present(alert, animated: true, completion: nil)
            
          
            
        }
        
        confirmAlert.addAction(confirmAction)
        self.present(confirmAlert, animated: true, completion: nil)
        
        let cancelAction = UIAlertAction(title: "إغلاق", style: .default, handler: nil)
        
        confirmAlert.addAction(cancelAction)
  
                                            
    }
    
    
    @objc func currentTodoEdited(notification: Notification) {
        if let todo = notification.userInfo?["editedTodo"] as? Todo {
            self.todo = todo
            setUpUI()
            }
        }
    
    func setUpUI(){
        detalisLabel.text = todo.details
        todoTitleLabel.text = todo.title
        todoImageView.image = todo.image
    }


}


