//
//  DataController.swift
//  SHREYAKATHURIYA-A02
//
//  Created by Shreya Kathuriya on 21/04/21.
//

import Foundation
import CoreData

class DataController: NSObject, DatabaseProtocol {

    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    private let helper = Helpers.sharedInstance

    override init() {
        persistentContainer = NSPersistentContainer(name: "ShreyaKathuriya_A3_iOs")
        persistentContainer.loadPersistentStores() { (description, error ) in
            if let error = error {
                fatalError("Failed to load Core Data Stack with error: \(error)")
            } }
        super.init()
    }
    
    /* reference from lab 4 */
    func cleanup() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
    }
    
    //MARK: create new meal method
    /* creates a meal and returns it */
    
    //MARK: Quotes
    func createNewQuotes(_ quote: String,_ author: String) {
        let newQuote = NSEntityDescription.insertNewObject(forEntityName: "Quotes", into: persistentContainer.viewContext) as! Quotes
        newQuote.author = author
        newQuote.quote = quote
        newQuote.quoteId = UUID().uuidString    //uniqueue ID for each quote
        saveChanges()
    }

    func findQuote(for quote: String) -> Bool {
        var status: Bool = false
        let request: NSFetchRequest<Quotes> = Quotes.fetchRequest()
        let predicate = NSPredicate(format: "quote == %@", quote)
        request.predicate = predicate
        do {
            let quote = try persistentContainer.viewContext.fetch(request)
            if quote.count > 0 {
                status = true
            }
        } catch{
            print("Fetch Request failed with error: \(error.localizedDescription)")
        }
        return status
    }

    func fetchAllSavedQuotes() -> [Quotes] {
        var quotes = [Quotes]()
        let request: NSFetchRequest<Quotes> = Quotes.fetchRequest()
        do {
            try quotes = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request failed with error: \(error.localizedDescription)")
        }
        return quotes
    }
    
    func deleteQuote(for id: String) {
        let context = persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Quotes")
        let predicate = NSPredicate(format: "quoteId == %@", id)
        deleteFetch.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Fetch Request failed with error: \(error.localizedDescription)")
        }
    }
    
    //MARK: Tasks
    func fetchAllTasks() -> [Task] {
        var tasks = [Task]()
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            try tasks = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request failed with error: \(error.localizedDescription)")
        }
        return tasks
    }
    
    func createTask(_ task: String,_ session: String,_ completed: Bool){
        let newTask = NSEntityDescription.insertNewObject(forEntityName:"Task", into: persistentContainer.viewContext) as! Task
        newTask.completed = completed
        newTask.date = Date()
        newTask.task = task
        newTask.sessionName = session
        newTask.taskId = UUID().uuidString
        saveChanges()
    }


    func deleteTask(for taskId: String) {
        let context = persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let predicate = NSPredicate(format: "taskId == %@", taskId)
        deleteFetch.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Fetch Request failed with error: \(error.localizedDescription)")
        }
    }
    
    func getFilteredTasks(for sessionId: String) -> [Task] {
        var tasks = [Task]()
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "sessionName == %@", sessionId), NSPredicate(format: "completed == NO")])
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = predicate
        do {
            try tasks = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request failed with error: \(error.localizedDescription)")
        }
        return tasks
    }
    
    func updateTaskStatus(_ taskId: String, _ status: Bool) {
        let predicate = NSPredicate(format: "taskId == %@", taskId)
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = predicate
        do {
            let task = try persistentContainer.viewContext.fetch(request).first
            task?.completed = status
            saveChanges()
        } catch {
            print("Fetch Request failed with error: \(error.localizedDescription)")
        }
    }

    //MARK: Feedback
    func saveFeedback(_ levels: FeedbackLevels, _ session: String) {
        let newFeedback = NSEntityDescription.insertNewObject(forEntityName:"Feedback", into: persistentContainer.viewContext) as! Feedback
        newFeedback.sessionName = session
        newFeedback.type = levels.type
        newFeedback.feedbackLevel = levels.level
        saveChanges()
    }

    func getFilteredFeedback(_ session: String) -> [Feedback] {
        var feedback = [Feedback]()
        let predicate = NSPredicate(format: "sessionName == %@", session)
        let request: NSFetchRequest<Feedback> = Feedback.fetchRequest()
        request.predicate = predicate
        do {
            try feedback = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request failed with error: \(error.localizedDescription)")
        }
        return feedback
    }


    func verifyMarkStatus(_ sessionName: String) -> Bool {
        var status: Bool = false
        let predicate = NSPredicate(format: "sessionName == %@", sessionName)
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = predicate
        do {
            let tasks = try persistentContainer.viewContext.fetch(request)
            for task in tasks {
                status = task.completed
                if status {
                    break
                }
            }
        } catch {
            print("Fetch Request failed with error: \(error.localizedDescription)")
        }
        return status
    }

    //MARK: Todo
    func createATodo(_ title: String) {
        let newTodo = NSEntityDescription.insertNewObject(forEntityName:"Todo", into: persistentContainer.viewContext) as! Todo
        newTodo.title = title
        newTodo.createdAt = helper.getDateString(from: Date())
        newTodo.id = UUID().uuidString
        newTodo.completionStatus = false
    }

    func getAllTodos() -> [Todo] {
        var todos = [Todo]()
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        do {
            try todos = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request failed with error: \(error.localizedDescription)")
        }
        return todos
    }

    func updateTodoStatus(_ todoId: String, _ status: Bool) {
        let predicate = NSPredicate(format: "id == %@", todoId)
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        request.predicate = predicate
        do {
            let todo = try persistentContainer.viewContext.fetch(request).first
            todo?.completionStatus = status
            saveChanges()
        } catch {
            print("Fetch Request failed with error: \(error.localizedDescription)")
        }
    }

    func deleteTodo(for todoId: String) {
        let context = persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        let predicate = NSPredicate(format: "id == %@", todoId)
        deleteFetch.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Fetch Request failed with error: \(error.localizedDescription)")
        }
    }

    //MARK: Note
    func createANote(_ title: String,_ createdAt: Date,_ completionStatus: Bool,_ sessionId: String,_ audioFileName: String?) {
        let newNote = NSEntityDescription.insertNewObject(forEntityName:"Note", into: persistentContainer.viewContext) as! Note
        newNote.title = title
        newNote.createdAt = createdAt
        newNote.completionStatus = completionStatus
        newNote.sessionId = sessionId
        newNote.noteId = UUID().uuidString

        if let name = audioFileName {
            newNote.audioNoteUrl = name
        } else {
            newNote.audioNoteUrl = ""
        }
        saveChanges()
    }

    func getAllNotes() -> [Note] {
        var notes = [Note]()
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            try notes = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request failed with error: \(error.localizedDescription)")
        }
        return notes
    }

    func getFilteredNotes(for sessionId: String) -> [Note] {
        var notes = [Note]()
        let predicate = NSPredicate(format: "sessionId == %@", sessionId)
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = predicate
        do {
            try notes = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request failed with error: \(error.localizedDescription)")
        }
        return notes
    }

    func deleteNote(for noteId: String) {
        let context = persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let predicate = NSPredicate(format: "noteId == %@", noteId)
        deleteFetch.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Fetch Request failed with error: \(error.localizedDescription)")
        }
    }
    
    //MARK: Session

    func startSession(completed: Bool, sessionType: String, sessionId: Int16, sessionCompleted: Bool, numberOfTasks: Int16, numberOfTasksCompleted: Int16) -> Session {
        let newSession = NSEntityDescription.insertNewObject(forEntityName:"Session", into: persistentContainer.viewContext) as! Session
        newSession.numberOfTasks = numberOfTasks
        newSession.numberOfTasksCompleted = numberOfTasksCompleted
        newSession.sessionCompleted = sessionCompleted
        newSession.sessionId = sessionId
        newSession.sessionType = sessionType
        return newSession
    }
    
    func finishSession( completed: Bool, sessionType: String, sessionId: Int16, sessionCompleted: Bool, numberOfTasks: Int16, numberOfTasksCompleted: Int16) {
        let newSession = NSEntityDescription.insertNewObject(forEntityName:"Session", into: persistentContainer.viewContext) as! Session
        newSession.numberOfTasks = numberOfTasks
        newSession.numberOfTasksCompleted = numberOfTasksCompleted
        newSession.sessionCompleted = sessionCompleted
        newSession.sessionId = sessionId
        newSession.sessionType = sessionType
    }

    func saveChanges() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save to CoreData: \(error)")
            }
        }
    }

    /* reference: week 4 lab */
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .all || listener.listenerType == .all {
            listener.onQuotesChange(change: .update, savedQuotes: fetchAllSavedQuotes())
        }
    }

    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
}

