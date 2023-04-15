//
//  HTTPClient.swift
//  POST_sdk
//
//  Created by Apple on 15/04/23.
//

import Foundation
import Alamofire

typealias HttpClientSuccess = (Any?) -> Void
typealias HttpClientFailure = (Any?) -> Void

class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class HTTPClient {
    func JSONObjectWithData(data: NSData) -> Any? {
        do { return try JSONSerialization.jsonObject(with: data as Data, options: []) }
        catch { return .none }
    }

    func postRequest(withApi api: Router, success: @escaping HttpClientSuccess, failure: @escaping HttpClientFailure) {
        let fullPath = api.baseURL + api.route

        debugPrint("URL ==> ", fullPath)
        print("Post Parameters ==> ", convertDicTojson(dic: api.parameters ?? [:]))
        debugPrint("Headers ==> ", api.header)

        AF.request(fullPath, method: api.method, parameters: api.parameters, encoding: JSONEncoding.default, headers: api.header).responseJSON { response in

            switch response.result {
            case let .success(data):
                debugPrint("response ==> ", data)
                debugPrint("response_URL ==> ", fullPath)
                success(data)
            case let .failure(error):
                debugPrint("response ==> ", error)
                failure(error)
            }
        }
    }
    
    func patchRequesr(withApi api: Router, success: @escaping HttpClientSuccess, failure: @escaping HttpClientFailure) {
        let fullPath = api.baseURL + api.route

        debugPrint("URL ==> ", fullPath)
        print("Post Parameters ==> ", convertDicTojson(dic: api.parameters ?? [:]))
        debugPrint("Headers ==> ", api.header)

        AF.request(fullPath, method: api.method, parameters: api.parameters, encoding: JSONEncoding.default, headers: api.header).responseJSON { response in

            switch response.result {
            case let .success(data):
                debugPrint("response ==> ", data)
                debugPrint("response_URL ==> ", fullPath)

                success(data)
            case let .failure(error):
                debugPrint("response ==> ", error)
                failure(error)
            }
        }
    }

    func getRequest(withApi api: Router, success: @escaping HttpClientSuccess, failure: @escaping HttpClientFailure) {
        let fullPath = api.baseURL + api.route

        debugPrint("URL ==> ", fullPath)
        debugPrint("method ==> ", api.method)
        debugPrint("Parameters ==> ", convertDicTojson(dic: api.parameters ?? [:]))
        debugPrint("Headers ==> ", api.header)

        AF.request(fullPath, method: api.method, parameters: api.parameters, encoding: URLEncoding.default, headers: headerNeeded(api: api) ? api.header : nil).responseJSON { response in

            switch response.result {
            case let .success(data):
                debugPrint("response ==> ", data)
                debugPrint("response_URL ==> ", fullPath)

                success(data)
            case let .failure(error):
                debugPrint("response ==> ", error)
                failure(error)
            }
        }
    }

    func uploadImage(withApi api: Router, success: @escaping HttpClientSuccess, failure: @escaping HttpClientFailure) {
        let fullPath = api.baseURL + api.route

        debugPrint("URL ==> ", fullPath)
        debugPrint("Parameters ==> ", api.parameters)
        debugPrint("Headers ==> ", api.header)

        AF.request(fullPath, method: api.method, parameters: api.parameters, encoding: JSONEncoding.default, headers: headerNeeded(api: api) ? api.header : nil).responseJSON { response in

            switch response.result {
            case let .success(data):
                debugPrint("response ==> ", data)
                success(data)
            case let .failure(error):
                debugPrint("response ==> ", error)
                failure(error)
            }
        }
    }

    // upload media to server (mediaType 0 = photo, 1 = video)
    func uploadImage(api: Router, imgData: Data, success: @escaping HttpClientSuccess, failure: @escaping HttpClientFailure) {
        let fullPath = api.baseURL + api.route

        debugPrint("URL ==> ", fullPath)
        debugPrint("Parameters ==> ", api.parameters ?? "")
        debugPrint("Headers ==> ", api.header)

        var url = try! URLRequest(url: fullPath, method: api.method, headers: api.header)
        url.timeoutInterval = 300
        let imgMimeType = "image/jpeg"
        let imgFileName = "image.jpeg"

        AF.upload(multipartFormData: { formdata in
                      if let params = api.parameters {
                          for (key, value) in params {
                              if let text = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                                  formdata.append(text, withName: key)
                              }
                          }
                      }

                      formdata.append(imgData, withName: "image", fileName: imgFileName, mimeType: imgMimeType)

                  },
                  to: fullPath, method: api.method, headers: api.header).responseJSON { response in

            switch response.result {
            case let .success(data):
                debugPrint("response ==> ", data)
                success(data)
            case let .failure(error):
                debugPrint("response ==> ", error)
                failure(error)
            }
        }
    }

    // upload media to server (mediaType 0 = photo, 1 = video)
    func uploadImages(api: Router, imgData: [Data], fileType _: String, withName: String, success: @escaping HttpClientSuccess, failure: @escaping HttpClientFailure) {
        let fullPath = api.baseURL + api.route

        debugPrint("URL ==> ", fullPath)
        debugPrint("Parameters ==> ", api.parameters ?? "")
        debugPrint("Headers ==> ", api.header)

        var url = try! URLRequest(url: fullPath, method: api.method, headers: api.header)
        url.timeoutInterval = 300
        var imgMimeType = ""
        var imgFileName = ""
        if api.parameters!["media_type"] as! String == "video" {
            imgMimeType = "video/mp4"
            imgFileName = "video_\(Date()).mp4"
        } else {
            imgMimeType = "image/jpeg"
            imgFileName = "image_\(Date()).jpeg"
        }

        AF.upload(multipartFormData: { formdata in
                      if let params = api.parameters {
                          for (key, value) in params {
                              if let text = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                                  formdata.append(text, withName: key)
                              }
                          }
                      }
                      for imgdata in imgData {
                          formdata.append(imgdata, withName: withName, fileName: imgFileName, mimeType: imgMimeType)
                      }
                  },
                  to: fullPath, method: api.method, headers: api.header).responseJSON { response in

            switch response.result {
            case let .success(data):
                debugPrint("response ==> ", data)
                success(data)
            case let .failure(error):
                debugPrint("response ==> ", error)
                failure(error)
            }
        }
    }

    // Return false if headers are not required
    func headerNeeded(api: Router) -> Bool {
        switch api.route {
        default: return true
        }
    }

    func convertDicTojson(dic dicParm: [String: Any]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dicParm ?? "", options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }
}
