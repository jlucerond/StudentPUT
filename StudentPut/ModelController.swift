//
//  ModelController.swift
//  StudentPut
//
//  Created by Joe Lucero on 8/2/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import Foundation

class StudentController {
    
    // DataSource
    static var students: [Student] = []
    
    // Base URL
    static let baseURL = URL(string: "https://survey-ios14.firebaseio.com/students")
    
    // Fetch Students
    static func fetchStudents(completion: @escaping () -> Void) {
        
        guard let url = baseURL?.appendingPathExtension("json") else { completion() ; return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error { NSLog(error.localizedDescription) ; completion() ; return }
            
            guard let data = data else { completion() ; return }
            
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : [String : String]] else { completion() ; return }

            let students = jsonDictionary.flatMap{ (key: String, value: [String : String]) -> Student? in
                
                let student = Student(dictionary: value)
                
                return student
            }
            
            self.students = students
        
            completion()
        }
        task.resume()
    }
    
    
}
