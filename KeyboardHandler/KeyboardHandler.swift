
//
//  Created by Alexey Ivankov on 15.07.16.
//  Copyright © 2016 Ivankov Alexey. All rights reserved.
//

import Foundation
import UIKit

open class KeyboardHandler {
    
    //MARK: Handlers
    
    private var willShowHandler:((
    _ keyboardFrame:CGRect?,
    _ animationDuration:Double?,
    _ animationCurve:UIView.AnimationOptions?)->Void)?
    
    private var animateWillShowHandler:((
    _ keyboardFrame:CGRect?)->Void)?
    
    private var willHideHandler:((
    _ animationDuration:Double?,
    _ animationCurve:UIView.AnimationOptions?)->Void)?

    private var animateWillHideHandler:(()->Void)?
    
    private var didShowHandler:(()->Void)?
    private var didHideHandler:(()->Void)?
    
    //MARK: Notifications
    private var willShowNotification:NSObjectProtocol?;
    private var didShowNotification:NSObjectProtocol?;
    private var willHideNotification:NSObjectProtocol?;
    private var didHideNotification:NSObjectProtocol?;
    
    
    public init(){
        subscribeNotifications();
    }
    
    deinit{
        unsubscribeNotifications();
        destroyNotifications();
    }
    
    public func setWillShowHandler(handler:@escaping (_ keyboardFrame:CGRect?, _ animationDuration:Double?, _ animationCurve:UIView.AnimationOptions?)->Void){
        willShowHandler = handler;
    }
    
    public  func setDidShowHandler(handler:@escaping ()->Void){
        didShowHandler = handler;
    }
    
    public func setWillHideHandler(handler:@escaping (_ animationDuration:Double?, _ animationCurve:UIView.AnimationOptions?)->Void){
        willHideHandler = handler;
    }
    
    public func setDidHideHandler(handler:@escaping ()->Void){
        didHideHandler = handler;
    }
    
    public func setAnimateWillShowHandler(handler:@escaping (_ keyboardFrame:CGRect?)->Void){
        self.animateWillShowHandler = handler
    }
    
    public func setAnimateWillHideHandler(handler:@escaping()->Void){
        self.animateWillHideHandler = handler
    }
    
    private func subscribeNotifications()
    {
        willShowNotification = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main)  { [weak self]  (notification:Notification)  in
            
            let userInfo = notification.userInfo;
            let keyboardFrame:CGRect? = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue;
            let animationDuration:Double? = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue;
            
            var animationCurve:UIView.AnimationOptions? = nil
            let curve = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            
            if curve != nil {
                animationCurve = UIView.AnimationOptions(rawValue: curve!.uintValue)
            }
            
            if self != nil && self!.willShowHandler != nil{
                self!.willShowHandler!(keyboardFrame, animationDuration, animationCurve);
            }
            
            
            if self != nil &&
                self!.animateWillShowHandler != nil &&
                animationDuration != nil &&
                animationCurve != nil{
                
                UIView.animate(withDuration: animationDuration!,
                               delay: 0.0,
                               options: animationCurve!,
                               animations:
                    {
                        self?.animateWillShowHandler!(keyboardFrame)
                },
                               completion: nil)
            }
        }
        
        didShowNotification = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: OperationQueue.main) { [weak self]  (notification:Notification) in
            
            if self != nil && self!.didShowHandler != nil{
                self!.didShowHandler!();
            }
        }
        
        willHideNotification = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main) { [weak self] (notification:Notification) in
            
            let userInfo = notification.userInfo;
            let animationDuration:Double? = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue;
            
            var animationCurve:UIView.AnimationOptions? = nil
            let curve = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            
            if curve != nil {
                animationCurve = UIView.AnimationOptions(rawValue: curve!.uintValue)
            }
            
            if self != nil && self!.willHideHandler != nil{
                self!.willHideHandler!(animationDuration, nil);
            }
            
            
            if self != nil &&
                self!.animateWillHideHandler != nil &&
                animationDuration != nil &&
                animationCurve != nil{
                
                UIView.animate(withDuration: animationDuration!,
                               delay: 0.0,
                               options: animationCurve!,
                               animations:
                    {
                        self?.animateWillHideHandler!()
                },
                               completion: nil)
            }
        }
        
        didHideNotification = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: OperationQueue.main) { [weak self] (notification:Notification) in
            
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

