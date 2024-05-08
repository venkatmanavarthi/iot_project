//
//  NetworkManager.swift
//  llm
//
//  Created by Venkat Manavarthi on 5/8/24.
//
import Foundation

class NetworkManager{
    func post<T: Codable>(url: String, data: T) async -> Message? {
        guard let url = URL(string: url) else {return nil}
        let decoder = JSONEncoder()
        guard let data = try? decoder.encode(data) else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            return try decoder.decode(Message.self, from: data)
        }catch{
            print("\(error.localizedDescription)")
        }
        return nil
    }
}
