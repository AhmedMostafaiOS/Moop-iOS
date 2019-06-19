//
//  ShortcutManager.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/06/18.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

class ShortcutManager {
    enum MoopShortcutItem: CaseIterable {
        case current
        case future
        case setting
        
        init(item: UIApplicationShortcutItem) {
            switch item.type {
            case "CurrentAction": self = .current
            case "FutureAction": self = .future
            case "SettingAction": self = .setting
            default: self = .current
            }
        }
        
        var type: String {
            switch self {
            case .current: return "CurrentAction"
            case .future: return "FutureAction"
            case .setting: return "SettingAction"
            }
        }
        
        var localizedTitle: String {
            switch self {
            case .current: return "현재상영"
            case .future: return "개봉예정"
            case .setting: return "설정"
            }
        }
        
        var icon: UIApplicationShortcutIcon {
            switch self {
            case .current: return UIApplicationShortcutIcon(templateImageName: "movie")
            case .future: return UIApplicationShortcutIcon(templateImageName: "plan")
            case .setting: return UIApplicationShortcutIcon(templateImageName: "setting")
            }
        }
    }
    
    static let shared = ShortcutManager()
    
    /// Temporary variable to hold a shortcut item from the launching or activation of the app.
    private var shortcutItemToProcess: UIApplicationShortcutItem?
    
    public func application(didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // If launchOptions contains the appropriate launch options key, a Home screen quick action
        // is responsible for launching the app. Store the action for processing once the app has
        // completed initialization.
        guard let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem else { return }
        self.shortcutItemToProcess = shortcutItem
    }
    
    public func application(performActionFor shortcutItem: UIApplicationShortcutItem) {
        // Alternatively, a shortcut item may be passed in through this delegate method if the app was
        // still in memory when the Home screen quick action was used. Again, store it for processing.
        self.shortcutItemToProcess = shortcutItem
    }
    
    public func applicationDidBecomeActive(rootViewController: UIViewController?) {
        // Is there a shortcut item that has not yet been processed?
        guard let shortcutItem = shortcutItemToProcess,
            let rootViewController = rootViewController as? MainTabBarController else { return }
            // In this sample an alert is being shown to indicate that the action has been triggered,
            // but in real code the functionality for the quick action would be triggered.
        
        let moopShortcutItem = MoopShortcutItem(item: shortcutItem)
        switch moopShortcutItem {
        case .current:
            rootViewController.selectedIndex = 0
        case .future:
            rootViewController.selectedIndex = 1
        case .setting:
            rootViewController.selectedIndex = 2
        }
        if let navi = rootViewController.selectedViewController as? UINavigationController {
            navi.popToRootViewController(animated: true)
        }
        // Reset the shorcut item so it's never processed twice.
        shortcutItemToProcess = nil
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        // Transform each favorite contact into a UIApplicationShortcutItem.
        application.shortcutItems = MoopShortcutItem.allCases.map { item -> UIApplicationShortcutItem in
            return UIApplicationShortcutItem(type: item.type,
                                             localizedTitle: item.localizedTitle,
                                             localizedSubtitle: nil,
                                             icon: item.icon,
                                             userInfo: nil)
        }
    }
}
