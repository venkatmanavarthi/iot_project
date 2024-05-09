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
    @State private var isGenerating: Bool = false
    
    var networkManager = NetworkManager()
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(messages, id: \.created_at){message in
                        Text("\(message.model)\n\n" + message.response)
                }
            }
            .listRowSpacing(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack{
                ZStack{
                    TextField("Ask Anything", text: $message)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        .focused($isAskFocused)
                        .opacity(isGenerating ? 0 : 1)
                    Text("Generating .. 💤")
                        .opacity(isGenerating ? 1 : 0)
                }
                Button{
                    if message.count > 0{
                        Task{
                            isAskFocused = false
                            isGenerating = true
                            await askQuestion(prompt: message)
                            message.removeAll()
                        }
                    }
                }label: {
                    Image(systemName: "paperplane.fill")
                        .padding(.trailing)
                        .opacity(isGenerating ? 0 : 1)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("Chat")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func askQuestion(prompt: String) async {
        self.messages.append(Message(created_at: UUID().uuidString, response: prompt, model: "You"))
        let question = Question(model: model, prompt: prompt)
        let data = await networkManager.post(url: Constants.GENERATE, data: question)
        if let msg = data {
            print(msg.model)
            self.messages.append(msg)
        }
        isGenerating = false
    }
}

#Preview {
    ContentView()
}
