import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    
    //Mark! Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "FakeNewsIdentifier")
        container.loadPersistentStores { description, error in
            if let error = error as NSError?{
                ("Unable to load persistent stores: \(error)")
            }
        }
        print(NSPersistentContainer.defaultDirectoryURL())
        return container
    }()
    
    
    func applicationDidEnterBackground(_ notification: Notification) {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
    }

    
    
    //lazy var managedObjectContext : NSManagedObjectContext = {
    //    return self.persistentContainer.viewContext
    //}()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let rootVC = window?.rootViewController as? ViewController {
            rootVC.container = persistentContainer
        }
        let _ = persistentContainer
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension NSPersistentContainer{
    func saveContext () {
        if viewContext.hasChanges{
            do {
                try viewContext.save()
                print("success!")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved Error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


// enumerateStrings
