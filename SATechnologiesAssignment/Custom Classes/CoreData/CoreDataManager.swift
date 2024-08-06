//
//  CoreDataManager.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 05/08/24.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private let coreDataHelper = CoreDataHelper()
    private let mapCoreDataModels = MapCoreDataModels()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SATechnologiesAssignment")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    //MARK: Save Inspection Model
    func storeInspectionResponseModel(_ model: InspectionResponseModel) {
        coreDataHelper.storeInspectionResponseModel(model, context: persistentContainer.viewContext)
    }
    
    //MARK: Update Methods
    func updateQuestionModel(_ questionId: Int, answerId: Int) {
        coreDataHelper.updateSelectedAnswerChoiceId(for: Int64(questionId), with: Int64(answerId), in: persistentContainer.viewContext)
    }
    
    func updateCategoryScore(id: Int64, isSubmitted: Bool, score: Double) {
        coreDataHelper.updateCategoryScore(id: id, isSubmitted: isSubmitted, score: score, context: persistentContainer.viewContext)
    }
    
    //MARK: Fetch Methods
    func fetchAllInspections() -> InspectionData? {
        let fetchRequest: NSFetchRequest<CDInspection> = CDInspection.fetchRequest()
        
        do {
            let results = (try persistentContainer.viewContext.fetch(fetchRequest).first)
            return mapCoreDataModels.mapCDInspectionToInspectionData(cdInspection: results ?? CDInspection())
        } catch {
            print("Failed to fetch inspections: \(error)")
            return nil
        }
    }
    
    func isInspectionDataPresent() -> Bool {
        let fetchRequest: NSFetchRequest<CDInspection> = CDInspection.fetchRequest()
        fetchRequest.fetchLimit = 1 // Only need to check if there is at least one record
        
        do {
            let count = try persistentContainer.viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to fetch inspection data count: \(error)")
            return false
        }
    }
}

