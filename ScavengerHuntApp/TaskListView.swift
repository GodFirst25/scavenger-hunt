//
//  TaskListView.swift
//  ScavengerHunt
//
//  Created by gllaptops on 9/15/25.
//

import SwiftUI


struct TaskListView: View {
    @State private var tasks: [Task] = [
        Task(title: "Find a flower", description: "Take a photo of a flower near you."),
        Task(title: "Spot a yellow color", description: "Take a photo of anything that has yellow."),
        Task(title: "Discover art", description: "Take a photo of something creative.")
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tasks.indices, id: \.self) { index in
                    NavigationLink(destination: TaskDetailView(task: $tasks[index])) {
                        HStack {
                            Text(tasks[index].title)
                                .strikethrough(tasks[index].isCompleted, color: .gray)
                            Spacer()
                            
                            if tasks[index].isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Scavenger Hunt")
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
