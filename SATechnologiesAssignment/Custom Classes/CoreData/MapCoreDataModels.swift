//
//  MapCoreDataModels.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 05/08/24.
//

import Foundation

class MapCoreDataModels {
    
    //MARK: Convert CodeData Models into Model
    func mapAllCDInspectionsToInspectionData(cdInspections: [CDInspection]) -> [InspectionData] {
        return cdInspections.compactMap { mapCDInspectionToInspectionData(cdInspection: $0) }
    }
    
    func mapCDInspectionToInspectionData(cdInspection: CDInspection?) -> InspectionData {
        let inspectionData = InspectionData(
            area: mapCDAreaToArea(cdArea: cdInspection?.area), id: Int(cdInspection?.id ?? -111),
            inspectionType: mapCDInspectionTypeToInspectionType(cdType: cdInspection?.inspectionType),
            survey: mapCDSurveyToSurvey(cdSurvey: cdInspection?.survey)
        )
        
        return inspectionData
    }
    
    func mapCDInspectionTypeToInspectionType(cdType: CDInspectionType?) -> InspectionType? {
        guard let cdType = cdType else { return nil }
        
        return InspectionType(
            access: cdType.access, id: Int(cdType.id),
            name: cdType.name
        )
    }
    
    func mapCDAreaToArea(cdArea: CDArea?) -> Area? {
        guard let cdArea = cdArea else { return nil }
        
        return Area(
            id: Int(cdArea.id),
            name: cdArea.name
        )
    }
    
    func mapCDSurveyToSurvey(cdSurvey: CDSurvey?) -> Survey? {
        guard let cdSurvey = cdSurvey else { return nil }
        
        return Survey(
            categories: cdSurvey.categories?.compactMap { mapCDCategoryToCategory(cdCategory: $0 as! CDCategory) }, id: Int(cdSurvey.id)
        )
    }
    
    func mapCDCategoryToCategory(cdCategory: CDCategory) -> Category {
        return Category(
            id: Int(cdCategory.id),
            name: cdCategory.name,
            questions: cdCategory.questions?.compactMap { mapCDQuestionToQuestion(cdQuestion: $0 as! CDQuestion) }, isSubmitted: cdCategory.isSubmitted, totalScore: cdCategory.totalScore
        )
    }
    
    func mapCDQuestionToQuestion(cdQuestion: CDQuestion) -> Question {
        return Question(
            answerChoices: cdQuestion.answerChoices?.compactMap { mapCDAnswerChoiceToAnswerChoice(cdAnswerChoice: $0 as! CDAnswerChoice) }, id: Int(cdQuestion.id),
            name: cdQuestion.name,
            selectedAnswerChoiceId: Int(cdQuestion.selectedAnswerChoiceId)
        )
    }
    
    func mapCDAnswerChoiceToAnswerChoice(cdAnswerChoice: CDAnswerChoice) -> AnswerChoice {
        return AnswerChoice(
            id: Int(cdAnswerChoice.id),
            name: cdAnswerChoice.name,
            score: cdAnswerChoice.score
        )
    }
}
