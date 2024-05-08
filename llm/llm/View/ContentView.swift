//
//  ContentView.swift
//  llm
//
//  Created by Venkat Manavarthi on 5/8/24.
//

import SwiftUI

struct ContentView: View {
    @State private var messages: [Message] = []
    @State private var message = ""
    @State private var model = "phi3"
    @FocusState private var isAskFocused: Bool
    var networkManager = NetworkManager()
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(messages, id: \.created_at){message in
                    Text(message.response)
                }
            }
            .listRowSpacing(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack{
                TextField("Ask Anything", text: $message)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .focused($isAskFocused)
                Button{
                    if message.count > 0 {
                        Task{
                            isAskFocused = false
                            await askQuestion(prompt: message)
                            message = ""
                        }
                    }
                }label: {
                    Image(systemName: "paperplane.fill")
                        .padding(.trailing)
                }
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("Chat")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func askQuestion(prompt: String) async {
        let question = Question(model: model, prompt: prompt)
        let data = await networkManager.post(url: Constants.GENERATE, data: question)
        if let msg = data {
            self.messages.append(msg)
        }
    }
}

#Preview {
    ContentView()
}
