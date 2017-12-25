//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/23/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        GetStudentLocationsRequest.get(limit: 3, skip: nil, order: nil) { result in
//            switch result {
//
//            case .success(let studentResults):
//                print(studentResults)
//            case .errorRequest:
//                print("errorRequest")
//            case .errorDataDecoding:
//                print("errorDataDecoding")
//            case .errorJsonDecoding:
//                print("errorJsonDecoding")
//            case .errorInvalidStatusCode:
//                print("errorInvalidStatusCode")
//            case .errorNoStatusCode:
//                print("errorNoStatusCode")
//            }
//        }
//
//        GetSingleStudentRequest.get(uniqueKey: "1234") { result in
//            switch result {
//
//            case .success(let studentResults):
//                print(studentResults)
//            case .errorRequest:
//                print("errorRequest")
//            case .errorDataDecoding:
//                print("errorDataDecoding")
//            case .errorJsonDecoding:
//                print("errorJsonDecoding")
//            case .errorInvalidStatusCode:
//                print("errorInvalidStatusCode")
//            case .errorNoStatusCode:
//                print("errorNoStatusCode")
//            }
//        }
        
//        let student = NewStudentLocation(uniqueKey: "123456789", firstName: "Test", lastName: "User", mapString: "Bogota Colombia", mediaURL: "https://www.linkedin.com/in/rsaenzi/", latitude: 12.3456, longitude: -98.765)
//
//        NewStudentLocationRequest.post(newStudent: student) { result in
//            switch result {
//
//            case .success:
//                print("success")
//            case .errorRequest:
//                print("errorRequest")
//            case .errorDataDecoding:
//                print("errorDataDecoding")
//            case .errorInvalidStatusCode:
//                print("errorInvalidStatusCode")
//            case .errorJsonDecoding:
//                print("errorJsonDecoding")
//            case .errorNoStatusCode:
//                print("errorNoStatusCode")
//            }
//        }
        
//        let objectId = "n375b6vja"
//        let fieldsToEdit = ["firstName": "John"]
//
//        EditStudentLocationRequest.put(objectId: objectId, fieldsToEdit: fieldsToEdit) { result in
//            switch result {
//
//            case .success:
//                print("success")
//            case .errorRequest:
//                print("errorRequest")
//            case .errorDataDecoding:
//                print("errorDataDecoding")
//            case .errorInvalidStatusCode:
//                print("errorInvalidStatusCode")
//            case .errorJsonDecoding:
//                print("errorJsonDecoding")
//            case .errorNoStatusCode:
//                print("errorNoStatusCode")
//            }
//        }
        
//        GetSessionIdRequest.post(username: "rsaenzi", password: "atlanta") { result in
//            switch result {
//
//            case .success(let session):
//                print(session)
//            case .errorRequest:
//                print("errorRequest")
//            case .errorDataDecoding:
//                print("errorDataDecoding")
//            case .errorInvalidStatusCode:
//                print("errorInvalidStatusCode")
//            case .errorNoStatusCode:
//                print("errorNoStatusCode")
//            case .errorJsonDecoding:
//                print("errorJsonDecoding")
//            }
//        }
        
//        DeleteSessionRequest.post { result in
//            switch result {
//
//            case .success(let session):
//                print(session)
//            case .errorRequest:
//                print("errorRequest")
//            case .errorDataDecoding:
//                print("errorDataDecoding")
//            case .errorInvalidStatusCode:
//                print("errorInvalidStatusCode")
//            case .errorNoStatusCode:
//                print("errorNoStatusCode")
//            case .errorJsonDecoding:
//                print("errorJsonDecoding")
//            }
//        }
        
//        GetUserDataRequest.get(userId: "rdfs3g") { result in
//            switch result {
//
//            case .success(let userData):
//                print(userData)
//            case .errorRequest:
//                print("errorRequest")
//            case .errorDataDecoding:
//                print("errorDataDecoding")
//            case .errorInvalidStatusCode:
//                print("errorInvalidStatusCode")
//            case .errorNoStatusCode:
//                print("errorNoStatusCode")
//            case .errorJsonDecoding:
//                print("errorJsonDecoding")
//            }
//        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

