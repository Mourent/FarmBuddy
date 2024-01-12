//
//  Persistence.swift
//
//
//  Created by MacBook Pro on 11/01/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.name = "nama"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        let viewContext = container.viewContext
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        if isFirstLaunch() {
                loadInitialData(context: viewContext)
            }
        else {
            print("gagal")
//            resetCoreDataEntity(entityName: "Item")

        }
        func resetCoreDataEntity(entityName: String) {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try viewContext.execute(deleteRequest)
                try viewContext.save()
                print("All data in \(entityName) has been reset")
            } catch let error as NSError {
                print("Error resetting \(entityName): \(error), \(error.userInfo)")
            }
        }

    }
    
    
}
func isFirstLaunch() -> Bool {
    let defaults = UserDefaults.standard
    if defaults.bool(forKey: "hasLaunchedBefore") == false {
        defaults.set(true, forKey: "hasLaunchedBefore")
        defaults.synchronize()
        return true
    }
    return false
}

//func loadInitialData(context: NSManagedObjectContext) {
////    let itemData = [
////        ItemData(id_item: "1", name: "Apple", image_path: "apple"),
////        ItemData(id_item: "2", name: "BeetRoot", image_path: "df-beetroot-1")
////        // Tambahkan item lainnya sesuai kebutuhan
////    ]
//
////    for data in itemData {
////        let newItem = Item(context: context)
////        newItem.id_item = data.id_item
////        newItem.name = data.name
////        newItem.image_path = data.image_path
////    }
//    for _ in 0..<10 {
//        let newItem = Item(context: context)
//        newItem.timestamp = Date()
//    }
//
//    do {
//        try context.save()
//    } catch {
//        let nsError = error as NSError
//        fatalError("Failure to save context: \(nsError), \(nsError.userInfo)")
//    }
//}

func loadInitialData(context: NSManagedObjectContext) {
    print(Bundle.main.bundlePath)

    if let url = Bundle.main.url(forResource: "Items", withExtension: "json") {
        if let content = try? String(contentsOf: url) {
            print(content)
        } else {
            print("Failed to read content of the JSON file.")
        }
    } else {
        print("Failed to locate Items.json in bundle.")
    }
//    if let url = Bundle.main.url(forResource: "Items", withExtension: "json", subdirectory: "vifim") {
//        // Lanjutkan dengan membaca data dan parsing JSON
//    } else {
//        fatalError("Failed to locate Items.json in bundle.")
//    }


    guard let url = Bundle.main.url(forResource: "Items", withExtension: "json") else {
        fatalError("Failed to locate items.json in bundle.")
    }
//    guard let url = Bundle.main.url(forResource: "items", withExtension: "json") else {
//        fatalError("Failed to locate items.json in bundle.")
//    }

    guard let data = try? Data(contentsOf: url) else {
        fatalError("Failed to load items.json from bundle.")
    }

//    let decoder = JSONDecoder()
//    guard let jsonItems = try? decoder.decode([ItemData].self, from: data) else {
//        fatalError("Failed to decode items.json")
//    }
    let decoder = JSONDecoder()
    
    do {
        let jsonItems = try decoder.decode([ItemData].self, from: data)
        // Lanjutkan dengan mengelola `jsonItems`
        for jsonData in jsonItems {
            let newItem = Item(context: context)
            newItem.id_item = jsonData.id_item
            newItem.name = jsonData.name
            newItem.image_path = jsonData.image_path
            newItem.count=Int32(jsonData.count)
        }

        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    } catch {
        print("Error decoding JSON: \(error)")
        fatalError("Failed to decode items.json: \(error.localizedDescription)")
    }


    
}


struct ItemData: Codable {
    var id_item: String
    var name: String
    var image_path: String
    var count : Int
}
