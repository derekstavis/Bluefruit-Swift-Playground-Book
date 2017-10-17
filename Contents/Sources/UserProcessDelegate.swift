//
//  UserProcessDelegate.swift
//  
//
//  Created by Trevor Beaton on 9/20/17.
//

import Foundation
import PlaygroundSupport


public class UserProcessDelegate: PlaygroundRemoteLiveViewProxyDelegate {
    
    public var pauseHandler: CommandPauseDelegate?
    
    public init(pauseHandler: CommandPauseDelegate?) {
        self.pauseHandler = pauseHandler
    }
    
    public var onAssessment:((PlaygroundValue)->Bool)?
    
    public init() {
        
    }
    
    //On live view connection closed
    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {
        // Kill user process if LiveView process closed.
        //PlaygroundPage.current.finishExecution()
    }
    
    //Receive message from live view
    public func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        if case let .string(text) = message {
            if text.isEqual(Constants.COMMAND_FINISHED){
                // Indicate that the handler is ready for more commands.
                pauseHandler?.isReadyForMoreCommands = true
            }
        }
 
        // Update Hints and Assessments
        if case let .array(commands) = message {
            let result:Bool = (onAssessment?(message))!
            //Send Result to live view
            let resultValue: PlaygroundValue = .boolean(result)
            remoteLiveViewProxy.send(resultValue)
        }
        // Kill user process if LiveView process closed.
        if case let .string(text) = message {
            if text.isEqual(Constants.PROGRAM_FINISHED){
                PlaygroundPage.current.finishExecution()
            }
        }
    }
}

    
    
    

