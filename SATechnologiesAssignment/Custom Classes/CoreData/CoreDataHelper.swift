//
//  CoreDataHelper.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 05/08/24.
//

import UIKit
import CoreData

class CoreDataHelper {
    //MARK: Store Inspection Data
    func storeInspectionResponseModel(_ model: InspectionResponseModel, context: NSManagedObjectContext) {
        guard let inspectionData = model.inspection else { return }
        
        let inspection = CDInspection(context: context)
        inspection.id = Int64(inspectionData.id ?? 0)
        
        if let areaData = inspectionData.area {
            let area = CDArea(context: context)
            area.id = Int64(areaData.id ?? 0)
            area.name = areaData.name
            inspection.area = area
        }
        
        if let inspectionTypeData = inspectionData.inspectionType {
            let inspectionType = CDInspectionType(context: context)
            inspectionType.id = Int64(inspectionTypeData.id ?? 0)
            inspectionType.name = inspectionTypeData.name
            inspectionType.access = inspectionTypeData.access
            inspection.inspectionType = inspectionType
        }
        
        if let surveyData = inspectionData.survey {
            let survey = CDSurvey(context: context)
            survey.id = Int64(surveyData.id ?? 0)
            
            if let categoriesData = surveyData.categories {
                for categoryData in categoriesData {
                    let category = CDCategory(context: context)
                    category.id = Int64(categoryData.id ?? 0)
                    category.name = categoryData.name
                    category.isSubmitted = categoryData.isSubmitted ?? false
                    
                    if let questionsData = categoryData.questions {
                        for questionData in questionsData {
                            let question = CDQuestion(context: context)
                            question.id = Int64(questionData.id ?? 0)
                            question.name = questionData.name
                            question.selectedAnswerChoiceId = Int64(questionData.selectedAnswerChoiceId ?? 0)
                            
                            if let answerChoicesData = questionData.answerChoices {
                                for answerChoiceData in answerChoicesData {
                                    let answerChoice = CDAnswerChoice(context: context)
                                    answerChoice.id = Int64(answerChoiceData.id ?? 0)
                                    answerChoice.name = answerChoiceData.name
                                    answerChoice.score = answerChoiceData.score ?? 0.0
                                    question.addToAnswerChoices(answerChoice)
                                }
                            }
                            category.addToQuestions(question)
                        }
                    }
                    survey.addToCategories(category)
                }
            }
            inspection.survey = survey
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    //MARK: Update Answers ID
    func updateSelectedAnswerChoiceId(for questionId: Int64, with answerChoiceId: Int64, in context: NSManagedObjectContext) {
        if let cdQuestion = fetchCDQuestion(by: questionId, in: context) {
            cdQuestion.selectedAnswerChoiceId = answerChoiceId
            
            // Save the context to persist the changes
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        } else {
            print("CDQuestion with id \(questionId) not found.")
        }
    }
    
    private func fetchCDQuestion(by id: Int64, in context: NSManagedObjectContext) -> CDQuestion? {
        let fetchRequest: NSFetchRequest<CDQuestion> = CDQuestion.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch CDQuestion: \(error)")
            return nil
        }
    }
    
    //MARK: Update Answers Submitted
    func updateCategoryScore(id: Int64, isSubmitted: Bool, score: Double, context: NSManagedObjectContext) {
        if let category = fetchCategoryById(id: id, context: context) {
            category.isSubmitted = isSubmitted
            category.totalScore = score
            // Save the context
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        } else {
            print("Category with ID \(id) not found")
        }
    }
    
    func fetchCategoryById(id: Int64, context: NSManagedObjectContext) -> CDCategory? {
        let fetchRequest: NSFetchRequest<CDCategory> = CDCategory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch category: \(error)")
            return nil
        }
    }
}
