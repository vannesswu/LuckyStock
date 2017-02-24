//
//  Service.swift
//  LuckyStock
//
//  Created by 吳建豪 on 2017/2/23.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UIKit

class Service: NSObject {
    
    
    typealias stockResult = ([LuckyStock], Error?) -> Void
    
    fileprivate var completionHandlers = [URL: stockResult]()
    fileprivate var urlSession: Foundation.URLSession
    
    fileprivate var backgroundSession: Foundation.URLSession!
    
    override init() {
        let configuration = URLSessionConfiguration.default
        let queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        urlSession = Foundation.URLSession(configuration: configuration, delegate: nil, delegateQueue: queue)
        super.init()
        urlSession = Foundation.URLSession(configuration: configuration, delegate: nil, delegateQueue: queue)
        let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: "com.razeware.flickrfeed")
        backgroundSession = Foundation.URLSession(configuration: backgroundConfiguration, delegate: self, delegateQueue: nil)
    }
    
    static let shareinstance = Service()
    
    func fetchWebStockData(baseurl:String , completion: @escaping ([LuckyStock],_ error:Error?) -> ()) {
        var luckyStocks = [LuckyStock]()
        guard let url = URL(string: baseurl) else {
            print("Error: \(baseurl) doesn't seem to be a valid URL")
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            do {
                if let data = data {
                    //      let myHTMLString = try String(contentsOf: data)
                    let myHTMLString = String(data: data, encoding: String.Encoding.utf8) as String!
                    
                    let separeString = myHTMLString?.components(separatedBy: "align=\"left\"")
                    for i in 1...10 {
                         let stock = LuckyStock((separeString?[i])!) 
                        luckyStocks.append(stock)
                     
                    }
                        DispatchQueue.main.async {
                            completion(luckyStocks, nil)
                        }
                }
            } catch let error as NSError {
                print("Error: \(error)")
            }
            
            
            
        }).resume()
        
        
    }
    
    func getStockInBackground(baseurl:String , completion: @escaping ([LuckyStock],_ error:Error?) -> ()) {
        guard let url = URL(string: baseurl) else {
            print("Error: \(baseurl) doesn't seem to be a valid URL")
            return
        }
        completionHandlers[url] = completion
        let request = URLRequest(url: url)
        let task = backgroundSession.downloadTask(with: request)
        task.resume()
        
    }
    
}


extension Service: URLSessionDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error, let url = task.originalRequest?.url, let completion = completionHandlers[url] {
            completionHandlers[url] = nil
            OperationQueue.main.addOperation {
            completion([LuckyStock](), error)
            }
        }
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // You must move the file or open it for reading before this closure returns or it will be deleted
        if let data = try? Data(contentsOf: location), let request = downloadTask.originalRequest, let response = downloadTask.response {
            let cachedResponse = CachedURLResponse(response: response, data: data)
            self.urlSession.configuration.urlCache?.storeCachedResponse(cachedResponse, for: request)
            if let url = downloadTask.originalRequest?.url, let completion = completionHandlers[url] {
                completionHandlers[url] = nil
                OperationQueue.main.addOperation {
                   var luckyStocks = [LuckyStock]()
                    let myHTMLString = String(data: data, encoding: String.Encoding.utf8) as String!
                    let separeString = myHTMLString?.components(separatedBy: "align=\"left\"")
                    for i in 1...10 {
                        let stock = LuckyStock((separeString?[i])!)
                        luckyStocks.append(stock)
                    }
                        completion(luckyStocks, nil)
                }
            }
        } else {
            if let url = downloadTask.originalRequest?.url, let completion = completionHandlers[url] {
                completionHandlers[url] = nil
                OperationQueue.main.addOperation {
                    completion([LuckyStock](), nil)
                }
            }
        }
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let completionHandler = appDelegate.backgroundSessionCompletionHandler {
            appDelegate.backgroundSessionCompletionHandler = nil
            completionHandler()
        }
    }
}
