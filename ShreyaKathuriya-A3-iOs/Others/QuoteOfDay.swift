//
//  QuoteOfDay.swift
//  ShreyaKathuriya-A3-iOs
//  Responsibility - Model to save quote of the day received from API
//  Created by Shreya Kathuriya on 20/05/21.
//

struct QuoteOfDay: Codable {
    let success: Success
    let contents: Contents
    let baseurl: String
    let copyright: Copyright
}

struct Success: Codable {
    let total: Int
}

struct Contents: Codable {
    let quotes: [Quote]
}

struct Quote: Codable {
    let quote, length, author: String
    let category, language, date: String
    let permalink: String
    let id: String
    let background: String
    let title: String
}

struct Copyright: Codable {
    let year: Int
    let url: String
}
