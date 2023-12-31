//
//  PetsView.swift
//  Pet Planner
//
//  Created by Yusuf Kaan USTA on 9.10.2023.
//

import SwiftUI

struct PetsView: View {
    
    @FetchRequest(sortDescriptors: [])
    private var myListResults: FetchedResults<Animals>
    
    @FetchRequest(sortDescriptors: [])
    private var myAnimalResults: FetchedResults<Animals>
    
    private var taskStatBuilder = TaskStatsBuilder()
    @State private var taskStatsValues = TaskStatsValues()
    
    @FetchRequest(fetchRequest: AnimalService.tasksByStatType(statType: .all))
    private var allResults: FetchedResults<Task>
    
    @FetchRequest(fetchRequest: AnimalService.tasksByStatType(statType: .allCompleted))
    private var allCompletedResults: FetchedResults<Task>
    
    @State private var isPresented: Bool = false
    @State private var isAddButtonTapped: Bool = false
    @State private var isButtonScaled = false
    
    let emptyIcon = UIImage(named: "Empty")
    
    var body: some View {
        NavigationStack {
            
            Text("Pets")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 24))
                .fontWeight(.semibold)
                .padding(.leading, 24)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    if myAnimalResults.isEmpty {
                        Image(uiImage: UIImage(named: "News") ?? UIImage(systemName: "photo")!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        
                        Text("No pets here...")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor((Color(.sRGB, red: 210/255, green: 211/255, blue: 213/255, opacity: 1.0)))
                            .padding(.vertical, 24)
                    } else {
                        HStack {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]){ ForEach(myAnimalResults, id: \.self) { animal in
                                NavigationLink(destination: PetDetailView(animal: animal)) {
                                    let animalUncompletedTasks = allResults.filter { $0.animals == animal }
                                    
                                    if let imageData = animal.picture {
                                        Image(uiImage: UIImage(data: imageData) ?? UIImage(systemName: "photo")!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 42, height: 42)
                                            .cornerRadius(25)
                                    }  else {
                                        Image(uiImage: emptyIcon!)
                                            .resizable()
                                            .frame(width: 42, height: 42)
                                            .cornerRadius(25)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(animal.name ?? "Unknown")
                                            .font(.system(size: 16))
                                            .foregroundColor(.black)
                                            .fontWeight(.medium)
                                        
                                        Text("Have \(animalUncompletedTasks.count) task")
                                            .font(.system(size: 14))
                                            .foregroundColor(.black.opacity(0.5))
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 70)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(.sRGB, red: 224/255, green: 224/255, blue: 224/255, opacity: 1.0), lineWidth: 1)
                                )
                                .foregroundColor(Color.black)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical , 8)
                            }.padding(.horizontal, 8)
                                .padding(.top, 1)
                        }
                    }
                }
                
                if !allResults.isEmpty {
                    HStack(alignment: .bottom) {
                            
                    Text("Task List")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        
                        
                        NavigationLink {
                            AllCompleteView().padding(.horizontal, 24)
                        } label: {
                            TaskStatView( title: "All Completed Tasks", count: taskStatsValues.allCompletedCount, icon: "checkmark.circle")
                        }.opacity(0.8)

                    }.padding(.leading, 24)
                        .padding(.trailing, 16)
                        .padding(.top, 24)
                    
                    TaskListView(tasks: allResults).padding(.horizontal, 24).padding(.top, 8)
                    
                } else {
                    HStack(alignment: .bottom) {
                            
                    Text("Task List")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        
                        
                        NavigationLink {
                            AllCompleteView().padding(.horizontal, 24)
                        } label: {
                            TaskStatView( title: "All Completed Tasks", count: taskStatsValues.allCompletedCount, icon: "checkmark.circle")
                        }.opacity(0.8)

                    }.padding(.leading, 24)
                        .padding(.trailing, 16)
                        .padding(.top, 24)
                    
                    Image(uiImage: UIImage(named: "Bored") ?? UIImage(systemName: "photo")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                    Text("There is nothing we can do.")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor((Color(.sRGB, red: 210/255, green: 211/255, blue: 213/255, opacity: 1.0)))
                        .padding(.top, 12)
                    Spacer()
                }
            }
            
            HStack {
                NavigationLink(destination: AddPetView { name, picture  in
                    do {
                        let imageData = picture?.jpegData(compressionQuality: 0.8)
                        try AnimalService.saveAnimal(name, picture: imageData)
                    } catch {
                        print(error)
                    }
                }) {
                    Text("+ Add New Pet")
                        .frame(maxWidth: .infinity)
                }
                .font(.system(size: 16))
                .padding(.vertical, 12)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(.sRGB, red: 24/255, green: 6/255, blue: 20/255, opacity: 1.0), Color(.sRGB, red: 24/255, green: 6/255, blue: 20/255, opacity: 0.50)]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(8)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    PetsView()
}

