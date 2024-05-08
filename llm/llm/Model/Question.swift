//
//  Question.swift
//  llm
//
//  Created by Venkat Manavarthi on 5/8/24.
//

struct Question: Codable{
    let model: String
    let prompt: String
    var stream: Bool = false
}
