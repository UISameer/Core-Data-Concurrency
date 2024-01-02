import UIKit
import CoreData

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
            //        addTwoUsersOnSameContext()
//        managedObjectAccessOnDifferentContext()
        
        let concurrencyNotifications = ConcurrencyNotifications()
        concurrencyNotifications.notificationInsertFired()
        
        fetchUsers()
    }
    
    func fetchUsers() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            // Context created on main thread
        let moc = appDelegate.persistentContainer.viewContext
        let userFetchRequest = NSFetchRequest<User>(entityName: "User")
        
        do {
            let users: [User] = try moc.fetch(userFetchRequest)
            print(users.map{ $0.firstName} )
            print(users.count)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
        // Rule 1 - Managed object contexts are bound to the thread (queue) that they are associated with upon initialization.
    func addTwoUsers() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            // Context created on main thread
        let moc = appDelegate.persistentContainer.viewContext
        let userFetchRequest = NSFetchRequest<User>(entityName: "User")
        
        do {
            let users: [User] = try moc.fetch(userFetchRequest)
            print(users.count)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        DispatchQueue.global(qos: .background).async {
                // Context created on main thread used by another thread
            let user = User(context: moc)
            user.secondName = "Sanjay"
            user.firstName = "Sameer"
            
            let secondUser = User(context: moc)
            secondUser.secondName = "Ashok"
            secondUser.firstName = "Mukta"
            
                // Save to persistent store
            do {
                try moc.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
        // Rule 1 Solution
    func addTwoUsersOnSameContext() {
        
        /*
         perform(_:) and performAndWait(_:) ensure the block operations are executed on the queue specified for the context. The perform(_:) method returns immediately and the context executes the block methods on its own thread. With the performAndWait(_:) method, the context still executes the block methods on its own thread, but the method doesn’t return until the block is executed.
         */
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            // Context created on main thread
        let moc = appDelegate.persistentContainer.viewContext
        
        DispatchQueue.global(qos: .background).async {
            
            print("Background thread")
            print("\(Thread.current)\n\n")
            
            moc.perform {
                
                print("\(Thread.current)\n\n")
                print("Switched to Main thread")
                
                    // Context created on main thread used by another thread
                let user = User(context: moc)
                user.secondName = "Sanjay"
                user.firstName = "Sameer"
                
                let secondUser = User(context: moc)
                secondUser.secondName = "Ashok"
                secondUser.firstName = "Mukta"
                
                    // Save to persistent store
                do {
                    try moc.save()
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
    }
    
        // Rule 2 Managed objects retrieved from a context are bound to the same queue that the context is bound to
    func managedObjectAccessOnDifferentContext() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let mainQueueContext = appDelegate.persistentContainer.viewContext
        let privateQueueContext = appDelegate.persistentContainer.newBackgroundContext()
        
        // Created a user object
        let user = User(context: mainQueueContext)
        user.secondName = "Mahendra"
        user.firstName = "Shriram"
        
        // Created a Task Object
        let task = Task(context: privateQueueContext)
        task.name = "First Task"
        
        user.taks = [task]
        do {
            try mainQueueContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    /*
     One rule of thumb is that object all their relationship properties must create on the same context in which object was created.
     */
    
}

