//
//  Лу.swift
//  OEK
//
//  Created by Alexey Ivankov on 15.07.16.
//  Copyright © 2016 Ivankov Alexey. All rights reserved.
//

import Foundation
import UIKit

class KeyboardHandler {
 
    //MARK: Handlers
    private var willShowHandler:((_ keyboardFrame:CGRect?, _ animationDuration:Double?, _ animationCurve:UIViewAnimationCurve?)->Void)?;
    
    private var didShowHandler:(()->Void)?;
    private var willHideHandler:((_ animationDuration:Double?, _ animationCurve:UIViewAnimationCurve?)->Void)?;
    private var didHideHandler:(()->Void)?;
    
    //MARK: Notifications
    private var willShowNotification:NSObjectProtocol?;
    private var didShowNotification:NSObjectProtocol?;
    private var willHideNotification:NSObjectProtocol?;
    private var didHideNotification:NSObjectProtocol?;
    

    init()
    {
        subscribeNotifications();
    }
    
    deinit
    {
        unsubscribeNotifications();
        destroyNotifications();
    }
    
    func setWillShowHandler(handler:@escaping (_ keyboardFrame:CGRect?, _ animationDuration:Double?, _ animationCurve:UIViewAnimationCurve?)->Void){
        willShowHandler = handler;
    }
    
    func setDidShowHandler(handler:@escaping ()->Void){
        didShowHandler = handler;
    }
    
    func setWillHideHandler(handler:@escaping (_ animationDuration:Double?, _ animationCurve:UIViewAnimationCurve?)->Void){
        willHideHandler = handler;
    }
    
    func setDidHideHandler(handler:@escaping ()->Void){
        didHideHandler = handler;
    }
    
    private func subscribeNotifications()
    {
       willShowNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main)  { [weak self]  (notification:Notification)  in
            
            let userInfo = notification.userInfo;
            let keyboardFrame:CGRect? = (userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue;
            let animationDuration:Double? = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue;
            let animationCurve:UIViewAnimationCurve? = userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UIViewAnimationCurve;
        
            if self != nil && self!.willShowHandler != nil{
                self!.willShowHandler!(keyboardFrame, animationDuration, animationCurve);
            }
        }
        
        didShowNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: OperationQueue.main) { [weak self]  (notification:Notification) in
            
            if self != nil && self!.didShowHandler != nil{
                self!.didShowHandler!();
            }
        }
        
        willHideNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [weak self] (notification:Notification) in
            
            let userInfo = notification.userInfo;
            let animationDuration:Double? = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue;
            let animationCurve:UIViewAnimationCurve? = userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UIViewAnimationCurve;
            
            if self != nil && self!.willHideHandler != nil{
                self!.willHideHandler!(animationDuration, animationCurve);
            }
        }
        
        didHideNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidHide, object: nil, queue: OperationQueue.main) { [weak self] (notification:Notification) in
            
            if self != nil && self!.didHideHandler != nil{
                self!.didHideHandler!();
            }
        }
    }
    
    private func unsubscribeNotifications()
    {
        NotificationCenter.default.removeObserver(willShowNotification!);
        NotificationCenter.default.removeObserver(didShowNotification!);
        NotificationCenter.default.removeObserver(willHideNotification!);
        NotificationCenter.default.removeObserver(didHideNotification!);
    }
    
    private func destroyNotifications()
    {
        willShowNotification = nil;
        didShowNotification = nil;
        willHideNotification = nil;
        didHideNotification = nil;
    }

}
