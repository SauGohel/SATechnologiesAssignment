//
//  InspectionResponseModel.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 05/08/24.
//

import Foundation


// MARK: - Welcome
struct InspectionResponseModel: Codable {
    let inspection: InspectionData?
    
    enum CodingKeys: CodingKey {
        case inspection
    }
    
    init(inspection: InspectionData?) {
        self.inspection = inspection
    }
}

// MARK: - Inspection
struct InspectionData: Codable {
    let area: Area?
    let id: Int?
    let inspectionType: InspectionType?
    let survey: Survey?
    
    enum CodingKeys: CodingKey {
        case area
        case id
        case inspectionType
        case survey
    }
    
    init(area: Area?, id: Int?, inspectionType: InspectionType?, survey: Survey?) {
        self.area = area
        self.id = id
        self.inspectionType = inspectionType
        self.survey = survey
    }
}

// MARK: - Area
struct Area: Codable {
    let id: Int?
    let name: String?
    
    enum CodingKeys: CodingKey {
        case id
        case name
    }
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}

// MARK: - InspectionType
struct InspectionType: Codable {
    let access: String?
    let id: Int?
    let name: String?
    
    enum CodingKeys: CodingKey {
        case access
        case id
        case name
    }
    
    init(access: String?, id: Int?, name: String?) {
        self.access = access
        self.id = id
        self.name = name
    }
}

// MARK: - Survey
struct Survey: Codable {
    let categories: [Category]?
    let id: Int?
    
    enum CodingKeys: CodingKey {
        case categories
        case id
    }
    
    init(categories: [Category]?, id: Int?) {
        self.categories = categories
        self.id = id
    }
   
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name: String?
    var questions: [Question]?
    var isSubmitted: Bool? = false
    var totalScore: Double?
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case questions
        case isSubmitted
        case totalScore
    }
    
    init(id: Int?, name: String?, questions: [Question]?, isSubmitted: Bool?, totalScore: Double?) {
        self.id = id
        self.name = name
        self.questions = questions
        self.isSubmitted = isSubmitted
        self.totalScore = totalScore
    }
}

// MARK: - Question
struct Question: Codable {
    let answerChoices: [AnswerChoice]?
    let id: Int?
    let name: String?
    var selectedAnswerChoiceId: Int? = nil

    enum CodingKeys: CodingKey {
        case answerChoices
        case id
        case name
        case selectedAnswerChoiceId
    }
    
    init(answerChoices: [AnswerChoice]?, id: Int?, name: String?, selectedAnswerChoiceId: Int?) {
        self.answerChoices = answerChoices
        self.id = id
        self.name = name
        self.selectedAnswerChoiceId = selectedAnswerChoiceId
    }
}

// MARK: - AnswerChoice
struct AnswerChoice: Codable {
    let id: Int?
    let name: String?
    let score: Double?
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case score
    }
    
    init(id: Int?, name: String?, score: Double?) {
        self.id = id
        self.name = name
        self.score = score
    }
}
