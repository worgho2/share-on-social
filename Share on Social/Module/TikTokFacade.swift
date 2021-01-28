//
//  TikTokFacade.swift
//  Share on Social
//
//  Created by otavio on 27/01/21.
//

// Videos with brand logo or watermark will lead to the videos being deleted or the respective accounts disabled. Make sure your application shares content without a watermark.

/** Project Info.plist
 
 1 - Configure Info.plist
 In Xcode, right-click your project's Info.plist file and select Open As -> Source Code.
 
 2 - Here are 3 keys need to configuration:
 2.1 - LSApplicationQueriesSchemes: Use to Open TikTop App
 2.2 - TikTokAppID: Use to config TikTok OpenSDK
 2.3 - CFBundleURLTypes : Use TikTok App callback your App Insert the following XML snippet into the body of your file just before the final </dict> element.
 
 <key>LSApplicationQueriesSchemes</key>
 <array>
 <string>tiktoksharesdk</string>
 <string>snssdk1180</string>
 <string>snssdk1233</string>
 </array>
 <key>TikTokAppID</key>
 <string>$TikTokAppID</string>
 <key>CFBundleURLTypes</key>
 <array>
 <dict>
 <key>CFBundleURLName</key>
 <string>tiktok</string>
 <key>CFBundleURLSchemes</key>
 <array>
 <string>aw8aahnrd0xkxaft</string>
 </array>
 </dict>
 </array>
 
 3 - Replace $TikTokAppID with your App's Client Key
 3.1 - tiktoksharesdk is used for sharing.
 3.2 - snssdk1233, snssdk1180 are used to check if the TikTok application is installed.
 3.3 - The TikTok Open SDK auto-registers your Client Key when your App launches.
 */

/** Setup App Delegate
 
 */

import TikTokOpenSDK
import Photos

class TikTokFacade: NSObject {
    static let instance = TikTokFacade()
    
    private override init() {
        super.init()
        self.setup()
    }
    
    private func setup() {
        TikTokOpenSDKApplicationDelegate.sharedInstance().logDelegate = self
    }
    
    func shareImages(_ images: [UIImage], completion: @escaping (TikTokOpenSDKShareRespState, String?) -> ()) {
        let datas = images.map { $0.pngData()! } //tratar force unwrapping
        var identifiers: [String] = []
        
        PHPhotoLibrary.shared().performChanges {
            for data in datas {
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .photo, data: data, options: nil)
                identifiers.append(request.placeholderForCreatedAsset!.localIdentifier)
            }
        } completionHandler: { (success, error) in
            DispatchQueue.main.async {
                
                let request = TikTokOpenSDKShareRequest()
                request.mediaType = .image
                request.state = UUID().uuidString
                request.localIdentifiers = identifiers

                request.send { (response) in
                    completion(response.shareState, response.state)
                }
            }
        }
        
        
    }
    

    
//    func shareVideos(_ videos: , completion: @escaping (TikTokOpenSDKShareRespState, String?) -> ()) {
//        //TODO
//    }
}

extension TikTokFacade: TikTokOpenSDKLogDelegate {
    func onLog(_ logInfo: String) {
        print("[TIKTOK-LOGGER] - \(logInfo)")
    }
}
