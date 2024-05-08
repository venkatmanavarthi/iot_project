//
//  Message.swift
//  llm
//
//  Created by Venkat Manavarthi on 5/8/24.
//

struct Message: Codable{
    let created_at: String
    let response: String
    let model: String
}
