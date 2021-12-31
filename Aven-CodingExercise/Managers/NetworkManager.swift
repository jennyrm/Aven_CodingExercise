//
//  NetworkManager.swift
//  Aven-CodingExercise
//
//  Created by Jenny Morales on 12/17/21.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let cache = NSCache<NSString, UIImage>()
    
    private let baseURL = "https://api.github.com/"
    private let organizationsListEndpoint = "organizations"
    private let organizationEndpoint = "orgs/"
    private let headers = [
        "accept" : "application/vnd.github.v3+json"
    ]
    
    //class cant be initialized anywhere else in the codebase
    private init() {}
    
    func getOrganizationsList(since: Int, completed: @escaping (Result<[Organization], GHError>) -> Void) {
        guard let url = URL(string: baseURL + organizationsListEndpoint) else { return completed(.failure(.invalidURL)) }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let paginationQuery = URLQueryItem(name: "per_page", value: "12")
        let sinceQuery = URLQueryItem(name: "since", value: String(since))
        components?.queryItems = [paginationQuery, sinceQuery]
        
        guard let completeURL = components?.url else { return completed(.failure(.invalidURL)) }
        
        var request = URLRequest(url: completeURL)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: completeURL) { data, response, error in
            if let _ = error { return completed(.failure(.unableToComplete)) }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return completed(.failure(.invalidResponse)) }
            
            guard let data = data else { return completed(.failure(.invalidData)) }
            
            do {
                let decoder = JSONDecoder()
                let organizations = try decoder.decode([Organization].self, from: data)
                
                completed(.success(organizations))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func getOrganization(name: String, completed: @escaping (Result<Organization, GHError>) -> Void) {
        guard let url = URL(string: baseURL + organizationEndpoint + name) else { return completed(.failure(.invalidURL)) }
    
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error { return completed(.failure(.unableToComplete)) }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return completed(.failure(.invalidResponse)) }
            
            guard let data = data else { return completed(.failure(.invalidData)) }
            
            do {
                let decoder = JSONDecoder()
                let organization = try decoder.decode(Organization.self, from: data)
                
                completed(.success(organization))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
}
