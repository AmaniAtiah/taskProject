//
//  Math.swift
//  Week5Lesson1
//
//  Created by Amani Atiah on 26/04/1443 AH.
//

import Foundation
import UIKit

class DivBy0Error: Error{
    
}

class Math {
    func divide(num1: Int, num2: Int)throws -> Int{
        if num2 == 0 {
            let error = DivBy0Error()
            throw error
        }
        return num1 / num2
    }
}

