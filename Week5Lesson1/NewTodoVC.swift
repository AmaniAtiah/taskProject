//
//  NewTodoVC.swift
//  Week5Lesson1
//
//  Created by Amani Atiah on 24/04/1443 AH.
//

import UIKit

class NewTodoVC: UIViewController  {
    var isCreationTodo = true
    var editedTodo: Todo?
    var editedTodoIndex: Int?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var todoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isCreationTodo  {
            mainButton.setTitle("تعديل", for: .normal)
            
            navigationItem.title = "تعديل المهمة"
            
            if let todo = editedTodo {
                titleTextField.text = todo.title
                detailsTextView.text = todo.details
                todoImageView.image = todo.image
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        if isCreationTodo {
            let todo = Todo(title:titleTextField.text!, image: todoImageView.image, details: detailsTextView.text)
            
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil, userInfo: ["addedTodo" : todo])
            
            let alert = UIAlertController(title: "تمت الاضافة", message: "تم اضافة لمهمة بنجاح", preferredStyle: UIAlertController.Style.alert)
            
            let closeAction = UIAlertAction(title: "تم", style: UIAlertAction.Style.default) { _ in
                self.tabBarController?.selectedIndex = 0
                
                self.titleTextField.text = ""
                self.detailsTextView.text = ""
                
            }
            alert.addAction(closeAction)
            present(alert, animated: true, completion: {
                
            })
            
        } else {
            let todo = Todo(title: titleTextField.text!, image: todoImageView.image, details: detailsTextView.text)
            
            NotificationCenter.default.post(name:NSNotification.Name(rawValue:  "CurrentTodoEdited"), object: nil, userInfo: ["editedTodo": todo, "editedTodoIndex": editedTodoIndex])
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewTododded"), object: nil, userInfo: ["addedTodo" : todo])
            
            let alert = UIAlertController(title: "تم الاعادة", message: "تم تعديل المهمة بنجاح", preferredStyle: UIAlertController.Style.alert)
            
            let closeAction = UIAlertAction(title: "تم", style: UIAlertAction.Style.default) { _ in
                self.navigationController?.popViewController(animated: true)
                self.titleTextField.text = ""
                self.detailsTextView.text = ""
                
            }
            alert.addAction(closeAction)
            present(alert, animated: true, completion: {
                
            })
        }

        

        
    }
    
   
    @IBAction func changeButtonClicked(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension NewTodoVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        dismiss(animated: true, completion: nil)
        
        todoImageView.image = image
    }
}
