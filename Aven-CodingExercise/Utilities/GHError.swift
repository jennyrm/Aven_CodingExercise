//
//  GHError.swift
//  Aven-CodingExercise
//
//  Created by Jenny Morales on 12/17/21.
//

import Foundation

enum GHError: String, Error {
    case invalidURL = "The URL is invalid. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}
