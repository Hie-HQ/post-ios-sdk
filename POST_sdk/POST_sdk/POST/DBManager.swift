//
//  DBManager.swift
//  POST_sdk
//
//  Created by Apple on 15/04/23.
//

import Foundation
import UIKit

class DBManager: NSObject {
    
    class func accessUserDefaultsForKey(keyStr: String) -> Any? {
        let data: NSData? = UserDefaults.standard.object(forKey: keyStr as String) as? NSData

        if data != nil {
            var retrivedVal = NSKeyedUnarchiver.unarchiveObject(with: data! as Data)

            if retrivedVal is NSDictionary {
                return retrivedVal!
            } else if retrivedVal is NSArray {
                retrivedVal = retrivedVal as! NSArray
            } else if retrivedVal is String {
                retrivedVal = retrivedVal as! String
            }
            return retrivedVal
        } else {
            return nil
        }
    }

    class func setValueInUserDefaults(value: Any, forKey keyStr: String) {
        do {
            let data: NSData = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false) as NSData
            UserDefaults.standard.set(data, forKey: keyStr as String)
            UserDefaults.standard.synchronize()
        } catch let error as NSError {
            debugPrint(error.debugDescription)
        }
    }

    // MARK: GetFolderPathOfDocumentDirectory

    class func getFolderPathForSource(source: String) -> String {
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentDirectoryPath: String = paths.object(at: 0) as! String
        let folderPath = "\(documentDirectoryPath)" + "\(source)"
        let manager = FileManager.default
        if !manager.fileExists(atPath: folderPath) {
            do {
                try manager.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        }
        return folderPath as String
    }

    // MARK: <Get Image From Document Directory>

    class func getImageFromDocumentDirectory(imageName: String) -> String {
        let filePath: String = getFolderPathForSource(source: "/images").appending((imageName as String) as String) as String
        let manager = FileManager.default

        if manager.fileExists(atPath: filePath as String) {
            return filePath
        }
        return ""
    }

    // MARK: <Save Image To Document Directory>

    class func saveImageToDocumentDirectory(img: UIImage, forImageName imageName: String) {
        let filePath: String = getFolderPathForSource(source: "/images").appending((imageName as String) as String) as String
        let imageData = img.jpegData(compressionQuality: 0.7)

        do {
            try imageData?.write(to: URL(fileURLWithPath: filePath as String), options: .atomic)
        } catch {
            print(error)
        }
    }

    // MARK: <Remove Image From Document Directory>

    class func removeImageFromDocumentDirectory(imageName: String) {
        let filePath: String = getFolderPathForSource(source: "/images").appending((imageName as String) as String) as String
        let manager = FileManager.default
        if manager.fileExists(atPath: filePath as String) {
            do {
                try manager.removeItem(atPath: filePath as String)
            } catch {
                print(error)
            }
        }
    }

    // MARK: RemoveDataFromUserDefaults

    class func cleanUpUserDefaults() {
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: Constants.UserDefultKey.kAccessToken)
            defaults.removeObject(forKey: Constants.UserDefultKey.kRefreshToken)
            defaults.removeObject(forKey: Constants.UserDefultKey.kAccessTokenExpire)
        }
       
    }
}
