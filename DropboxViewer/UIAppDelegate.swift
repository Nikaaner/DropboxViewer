//
//  UIAppDelegate.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 25.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    func swizzling(forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(forClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        
        let didAddMethod = class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
}
