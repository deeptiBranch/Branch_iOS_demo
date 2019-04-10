import UIKit

import CoreData

import Branch

import UserNotifications





@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    
    
    var window: UIWindow?
    
    var kReturnURLSchemeDebug = "com.done.faasos"
    
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
//        UIFont.overrideInitialize()
        
        
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
                
                if granted{
                    
                    DispatchQueue.main.async{
                        
                        UIApplication.shared.registerForRemoteNotifications()
                        
                    }
                    
                }
                
            }
            
        } else {
            
            // Fallback on earlier versions
            
            let notificationSettings = UIUserNotificationSettings(
                
                types: [.badge, .sound, .alert], categories: nil)
            
            application.registerUserNotificationSettings(notificationSettings)
            
            
            
        }
        
        
        
        // if you are using the TEST key
        
        Branch.setUseTestBranchKey(true)
        
        Branch.getInstance()?.setDebug()
        
        
        
        // listener for Branch Deep Link data
        
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            
            print(params as? [String: AnyObject] ?? {})
            
            //            ProductManager.sharedManager.getProductDetails(productId: 4265, store_id:12, brand_id: 3, completionHandler: { (product, code) in
            
            //                NavigationManager.presentProductDetailViewController(for: product, from: NavigationManager.rootViewController ?? UIViewController.init())
            
            //            }, failure: { (error, code, errorMessage) in
            
            //
            
            //            })
            
        }
        
        
        
        return true
        
    }
    
    
    
    //MARK:- UNUserNotificationCenterDelegate
    
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound, .badge])
        
        //        NotificationManager.shared.notificationDidClick(userInfo: notification.request.content.userInfo)
        
    }
    
    
    
    
    
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
//        NotificationManager.shared.notificationDidClick(userInfo: response.notification.request.content.userInfo)
        
        completionHandler()
        
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
//        GlobalFunction.setPushToken(pushToken: deviceToken)
        
        print("token: \(token)")
        
    }
    
    
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("failed to register for remote notifications with with error: \(error)")
        
    }
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        Branch.getInstance().handlePushNotification(userInfo)

//        NotificationManager.shared.notificationDidClick(userInfo: userInfo)
        
    }
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        Branch.getInstance().handlePushNotification(userInfo)
        
//        NotificationManager.shared.notificationDidClick(userInfo: userInfo)
        
    }
    
    
    
    
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        
        return true
        
    }
    
    
    
    
    
    func application(_ app: UIApplication,
                     
                     open url: URL,
                     
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
//        PhonePeSDK.shared().deeplinkUrl = url
        
        Branch.getInstance().application(app, open: url, options: options)
        
        if (url.scheme?.localizedCaseInsensitiveCompare(kReturnURLSchemeDebug) == ComparisonResult.orderedSame) {
            
            
            
            let urlQuery = url.query
            
            let urlPath = url.path
            
            
            
            if(urlPath.contains("success")){
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PaytmCallback"), object: self, userInfo:["status":"success"])
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PaypalCallback"), object: self, userInfo:["status":"success"])
                
            }else {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PaytmCallback"), object: self, userInfo:["status":"cancel"])
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PaypalCallback"), object: self, userInfo:["status":"success"])
                
            }
            
            
            
//            return POPPopupBridge.open(url, options: options)
            
        }
        
        
        
//        return PayWithAmazon.sharedInstance()?.handleRedirectURL(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String) ?? true
        return true
    }
    
    
    
    @nonobjc func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        // handler for Universal Links
        
        Branch.getInstance().continue(userActivity)
        
        return true
        
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }
    
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        
        
    }
    
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        
        
    }
    
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
        
    }
    
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
        
    }
    
    
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        
        
        let container = NSPersistentContainer(name: "FoodX")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
                
            }
            
        })
        
        return container
        
    }()
    
    
    
    
    
    // iOS 9 and below
    
    lazy var applicationDocumentsDirectory: URL = {
        
        
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return urls[urls.count-1]
        
    }()
    
    
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        
        let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        
        let modelURL = Bundle.main.url(forResource: appName, withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOf: modelURL)!
        
    }()
    
    
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            
        } catch {
            
            // Report any error we got.
            
            var dict = [String: AnyObject]()
            
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            
            
            dict[NSUnderlyingErrorKey] = error as NSError
            
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            // Replace this with code to handle the error appropriately.
            
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            
            abort()
            
        }
        
        
        
        return coordinator
        
    }()
    
    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        
        let coordinator = self.persistentStoreCoordinator
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
        
    }()
    
    
    
    // MARK: - Core Data Saving support
    
    
    
    func saveContext () {
        
        
        
        if #available(iOS 10.0, *) {
            
            
            
            let context = persistentContainer.viewContext
            
            if context.hasChanges {
                
                do {
                    
                    try context.save()
                    
                } catch {
                    
                    
                    
                    let nserror = error as NSError
                    
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    
                }
                
            }
            
        } else {
            
            // iOS 9.0 and below - however you were previously handling it
            
            if managedObjectContext.hasChanges {
                
                do {
                    
                    try managedObjectContext.save()
                    
                } catch {
                    
                    
                    
                    let nserror = error as NSError
                    
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    
                    abort()
                    
                }
                
            }
            
        }
        
    }
    
}
