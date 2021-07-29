//
//  SessionTypes.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 23/05/21.
//

// enum Sessions
enum SessionType: Int, CaseIterable {
    case promodoro25
    case promodoro50
    case session30
    case session45
    case session60
    case session120
    case customSession

    var title: String {
        switch self {
        case .promodoro25:
            return "Promodoro Session 25/5"
        case .promodoro50:
            return "Promodoro Session 50/10"
        case .session30:
            return "30 mins Session"
        case .session45:
            return "45 mins Session"
        case .session60:
            return "1 hr Session"
        case .session120:
            return "2 hrs Session"
        case .customSession:
            return "Custom Timed Session"
        }
    }
    // assigning time for each session
    var time: Int {
        switch self {
        case .promodoro25:
            return 5    // 5 for demonstration puurpose, otherwise 25*60
        case .promodoro50:
            return 50*60
        case .session30:
            return 1800
        case .session45:
            return 2700
        case .session60:
            return 3600
        case .session120:
            return 7200
        case .customSession:
            return 0
        }
    }
    
    // title for graph for each session
    var graphTitle: String {
        switch self {
        case .promodoro25:
            return "25/5"
        case .promodoro50:
            return "50/10"
        case .session30:
            return "30m"
        case .session45:
            return "45m"
        case .session60:
            return "1h"
        case .session120:
            return "2h"
        case .customSession:
            return "Cust"
        }
    }
}
