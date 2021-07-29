//
//  DatabaseProtocol.swift
//  SHREYAKATHURIYA-A02
//
//  Created by Shreya Kathuriya on 21/04/21.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case quote
    case promodoro25
    case promodoro50
    case mins30
    case mins45
    case mins60
    case mins120
    case tasksForSession
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onQuotesChange(change: DatabaseChange, savedQuotes: [Quotes])
}

protocol DatabaseProtocol: AnyObject {
    // Quote feature

    func createNewQuotes(_ quote: String,_ author: String)
    func fetchAllSavedQuotes() -> [Quotes]
    func deleteQuote(for id: String)

    func saveChanges()
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)

    // Task feature

    func createTask(_ task: String,_ session: String,_ completed: Bool)
    func deleteTask(for taskId: String)
    func fetchAllTasks() -> [Task]
    func getFilteredTasks(for sessionId: String) -> [Task]
    func updateTaskStatus(_ taskId: String, _ status: Bool)
    func verifyMarkStatus(_ sessionName: String) -> Bool

    func startSession(completed: Bool, sessionType: String, sessionId: Int16, sessionCompleted: Bool, numberOfTasks: Int16, numberOfTasksCompleted: Int16) -> Session
    func finishSession(completed: Bool, sessionType: String, sessionId: Int16, sessionCompleted: Bool, numberOfTasks: Int16, numberOfTasksCompleted: Int16)

    // Note feature

    func createANote(_ title: String,_ createdAt: Date,_ completionStatus: Bool,_ sessionId: String,_ audioFileName: String?)
    func getAllNotes() -> [Note]
    func getFilteredNotes(for sessionId: String) -> [Note]
    func deleteNote(for noteId: String)
    func findQuote(for quote: String) -> Bool

    // Todo feature

    func createATodo(_ title: String)
    func getAllTodos() -> [Todo]
    func deleteTodo(for todoId: String)
    func updateTodoStatus(_ todoId: String, _ status: Bool)

    // Feedback feature

    func saveFeedback(_ levels: FeedbackLevels, _ session: String)
    func getFilteredFeedback(_ session: String) -> [Feedback]

}
