//
//  AnimalService.swift
//  Pet Planner
//
//  Created by Yusuf Kaan USTA on 6.10.2023.
//

import Foundation
import CoreData

class AnimalService {
    
    static var viewContext: NSManagedObjectContext {
        CoreDataProvider.shared.persistentContainer.viewContext
    }
    
    static func save() throws {
        try viewContext.save()
    }
    
    static func saveAnimal(_ name: String, picture: Data?) throws {
        let animal = Animals(context: viewContext)
        animal.name = name
        animal.picture = picture
        do {
            try save()
            print("Animal saved successfully")
        } catch {
            print("Error saving animal: \(error)")
        }
    }
    
    
    static func updateAnimal(animals: Animals, editConfig: AnimalEditConfig) throws -> Bool {
        
        animals.name = editConfig.name
        animals.picture = editConfig.picture
        
        try save()
        return true
    }
    
    static func deleteAnimal(_ animal: Animals) throws {
        viewContext.delete(animal)
        try save()
    }
    
    
    static func deleteTask(_ task: Task) throws {
        viewContext.delete(task)
        try save()
    }
    
    static func updateTask(task: Task, editConfig: TaskEditConfig) throws -> Bool {
        
        let taskToUpdate = task
        taskToUpdate.isDone = editConfig.isDone
        taskToUpdate.title = editConfig.title
        taskToUpdate.notes = editConfig.notes
        taskToUpdate.taskDate = editConfig.hasDate ? editConfig.taskDate: nil
        taskToUpdate.taskTime = editConfig.hasTime ? editConfig.taskTime: nil
        
        try save()
        return true
    }
    
    static func saveTaskToMyAnimal(animal: Animals, taskNotes: String? ,taskTitle: String, taskDate: Date?, taskTime: Date?) throws {
        let task = Task(context: viewContext)
        task.title = taskTitle
        task.notes = taskNotes
        task.taskDate = taskDate
        task.taskTime = taskTime
        animal.addToTasks(task)
        try save()
    }
    
    
    
    static func tasksByStatType(statType: TaskStatType) -> NSFetchRequest<Task> {
        
        let request = Task.fetchRequest()
        request.sortDescriptors = []
        
        let calendar = Calendar.current
        var startOfDay: Date
        var endOfDay: Date
        
        switch statType {
        case .all:
            request.predicate = NSPredicate(format: "isDone = false")
        case .allCompleted:
            request.predicate = NSPredicate(format: "isDone = true")
        case .today:
            let today = Date()
            startOfDay = calendar.startOfDay(for: today)
            endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: today)!
            request.predicate = NSPredicate(format: "(taskDate >= %@) AND (taskDate <= %@) AND isDone = false", startOfDay as NSDate, endOfDay as NSDate)
        case .todayCompleted:
            let today = Date()
            startOfDay = calendar.startOfDay(for: today)
            endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: today)!
            request.predicate = NSPredicate(format: "(taskDate >= %@) AND (taskDate <= %@) AND isDone = true", startOfDay as NSDate, endOfDay as NSDate)
        }
        
        return request
    }
    
    
    static func getTasksByList(animal: Animals) -> NSFetchRequest<Task> {
        let request = Task.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "animals == %@ AND isDone == false", animal)
        return request
    }
    
}

