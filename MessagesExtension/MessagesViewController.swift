import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    var controller: CrossOutGameViewController?
    var conversation: MSConversation?
    public var lose : Bool? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        super.willBecomeActive(with: conversation)
        
        // Use this method to configure the extension and restore previously stored state.
        createView(conversation: conversation, presentationStyle: presentationStyle)
        
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        
        // Use this method to prepare for the change in presentation style.
        createView(conversation: conversation, presentationStyle: presentationStyle)
        
    }
    
    
    private func createView(conversation: MSConversation, presentationStyle: MSMessagesAppPresentationStyle) {
        // Determine the controller to present.
        self.conversation = conversation
        //controller = instantiateGameHistoryViewController()
        let opponent_id = conversation.remoteParticipantIdentifiers[0]
        
        let game : CrossOutGame
        if conversation.selectedMessage != nil {
            game = CrossOutGame(message: conversation.selectedMessage!)!
            if opponent_id != conversation.selectedMessage?.senderParticipantIdentifier {
                let alert = UIAlertController(title: "Waiting for opponent...", message: "It's not your turn.", preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            game = CrossOutGame(cur_player_id : conversation.localParticipantIdentifier.uuidString, opponent_id : opponent_id.uuidString)
        }
        
        controller = createViewController(game: game)
        
        lose = (controller?.game?.checkOneLeft())!
        
        if (controller?.game?.game_over)! == true {
            let alert = UIAlertController(title: "Game is over.", message: "Create new game.", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.swipeFunction(sender:)))
            self.view.addGestureRecognizer(panRecognizer)
        }
        
        // Remove any existing child controllers.
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        // Embed the new controller.
        addChildViewController(controller!)
        
        controller?.view.frame = view.bounds
        controller?.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview((controller?.view)!)
        
        controller?.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller?.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller?.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller?.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        controller?.didMove(toParentViewController: self)
        
        
    }
    
    public func createViewController(game: CrossOutGame) -> CrossOutGameViewController {
        // Instantiate a `BuildIceCreamViewController` and present it.
        let controller = CrossOutGameViewController()
        
        controller.game = game
        
        return controller
    }
    
    // MARK: Convenience
    
    func swipeFunction(sender:UIPanGestureRecognizer){
        
        if sender.state == .began {
            controller?.game?.startPoint = sender.location(in: view)
        }
        else if sender.state == .ended {
            
            controller?.game?.endPoint = sender.location(in: view)
            
            let startx = Double((controller?.game?.startPoint.x)!)
            let starty = Double((controller?.game?.startPoint.y)!)
            let endx = Double((controller?.game?.endPoint.x)!)
            let endy = Double((controller?.game?.endPoint.y)!)
            
            var startbar = -1;
            var endbar = -1;
            var rownum = 0;
            let w = UIScreen.main.bounds.width
            
            if (starty >= 150 && starty <= 253 && endy >= 150 && endy <= 253) {
                rownum = 1
                
                if (startx <= Double((w-85)/2)) {
                    startbar = 0
                }
                else if (startx > Double((w-85)/2) && startx <= Double((w-85)/2 + 35)) {
                    startbar = 1
                }
                else if (startx > Double((w-85)/2 + 35) && startx <= Double((w-85)/2 + 70)) {
                    startbar = 2
                }
                
                if (endx <= Double((w-85)/2 + 35)) {
                    endbar = 0
                }
                else if (endx > Double((w-85)/2 + 35) && endx <= Double((w-85)/2 + 70)) {
                    endbar = 1
                }
                else if (endx > Double((w-85)/2 + 70)) {
                    endbar = 2
                }
            }
            
            if (starty >= 280 && starty <= 383 && endy >= 280 && endy <= 383) {
                rownum = 2
                if (startx <= Double((w-120)/2)) {
                    startbar = 0
                }
                else if (startx > Double((w-120)/2) && startx <= Double((w-120)/2 + 35)) {
                    startbar = 1
                }
                else if (startx > Double((w-120)/2 + 35) && startx <= Double((w-120)/2 + 70)) {
                    startbar = 2
                }
                else if (startx > Double((w-120)/2 + 70) && startx <= Double((w-120)/2 + 105)) {
                    startbar = 3
                }
                
                if (endx <= Double((w-120)/2 + 35)) {
                    endbar = 0
                }
                else if (endx > Double((w-120)/2 + 35) && endx <= Double((w-120)/2 + 70)) {
                    endbar = 1
                }
                else if (endx > Double((w-120)/2 + 70) && endx <= Double((w-120)/2 + 105)) {
                    endbar = 2
                }
                else if (endx > Double((w-120)/2 + 105)) {
                    endbar = 3
                }
            }
            
            if (starty >= 410 && starty <= 513 && endy >= 410 && endy <= 513) {
                rownum = 3
                if (startx <= Double((w-155)/2)) {
                    startbar = 0
                }
                else if (startx > Double((w-155)/2) && startx <= Double((w-155)/2 + 35)) {
                    startbar = 1
                }
                else if (startx > Double((w-155)/2 + 35) && startx <= Double((w-155)/2 + 70)) {
                    startbar = 2
                }
                else if (startx > Double((w-155)/2 + 70) && startx <= Double((w-155)/2 + 105)) {
                    startbar = 3
                }
                else if (startx > Double((w-155)/2 + 105) && startx <= Double((w-155)/2 + 140)) {
                    startbar = 4
                }
                
                if (endx <= Double((w-155)/2 + 35)) {
                    endbar = 0
                }
                else if (endx > Double((w-155)/2 + 35) && endx <= Double((w-155)/2 + 70)) {
                    endbar = 1
                }
                else if (endx > Double((w-155)/2 + 70) && endx <= Double((w-155)/2 + 105)) {
                    endbar = 2
                }
                else if (endx > Double((w-155)/2 + 105) && endx <= Double((w-155)/2 + 140)) {
                    endbar = 3
                }
                else if (endx > Double((w-155)/2 + 140)) {
                    endbar = 4
                }
            }
            
            
            if (startbar <= endbar && startbar != -1 && endbar != -1) {
                for row1bar in (controller?.game?.row1)! {
                    if (row1bar.backgroundColor == controller?.game?.cur_color) {
                        row1bar.backgroundColor = UIColor.black
                    }
                    self.view.addSubview(row1bar)
                }
                
                for row2bar in (controller?.game?.row2)! {
                    if (row2bar.backgroundColor == controller?.game?.cur_color) {
                        row2bar.backgroundColor = UIColor.black
                    }
                    self.view.addSubview(row2bar)
                }
                
                for row3bar in (controller?.game?.row3)! {
                    if (row3bar.backgroundColor == controller?.game?.cur_color) {
                        row3bar.backgroundColor = UIColor.black
                    }
                    self.view.addSubview(row3bar)
                }
                
                let alert = UIAlertController(title: "Uh oh!", message: "Selected too many bars!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Oops, my bad", style: UIAlertActionStyle.default, handler: nil))
                
                
                switch rownum {
                case 1:
                    if (startbar == 0 && endbar == 2) {
                        controller?.present(alert, animated: true, completion: nil)
                    }
                    else {
                        for index in startbar...endbar {
                            let curbar = controller?.game?.row1[index]
                            if curbar?.backgroundColor == UIColor.black || (controller?.game?.new_game)! {
                                curbar?.backgroundColor = controller?.game?.cur_color
                                UIView.transition(with: curbar!, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {self.view.addSubview(curbar!)}, completion: nil)
                            }
                        }
                    }
                    
                case 2:
                    if (startbar == 0 && endbar == 3) {
                        controller?.present(alert, animated: true, completion: nil)
                    }
                    else {
                        for index in startbar...endbar {
                            let curbar = controller?.game?.row2[index]
                            if curbar?.backgroundColor == UIColor.black || (controller?.game?.new_game)! {
                                curbar?.backgroundColor = controller?.game?.cur_color
                                UIView.transition(with: curbar!, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {self.view.addSubview(curbar!)}, completion: nil)
                            }
                        }
                    }
                    
                case 3:
                    if (startbar == 0 && endbar == 4) {
                        controller?.present(alert, animated: true, completion: nil)
                    }
                    else {
                        for index in startbar...endbar {
                            let curbar = controller?.game?.row3[index]
                            if curbar?.backgroundColor == UIColor.black || (controller?.game?.new_game)!
                            {
                                curbar?.backgroundColor = controller?.game?.cur_color
                                UIView.transition(with: curbar!, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {self.view.addSubview(curbar!)}, completion: nil)
                            }
                        }
                    }
                    
                    
                default:
                    break;
                }
                
                if lose! {
                    controller?.game?.game_over = true
                    controller?.message = "You win!"
                    let alert = UIAlertController(title: "You Lose!", message: "Better luck next time!", preferredStyle: UIAlertControllerStyle.alert)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
        
        
        
        let message_to_insert = composeMessage(game: (controller?.game!)!, caption: (controller?.message)!, session: conversation?.selectedMessage?.session)
        
        conversation?.insert(message_to_insert) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    public func composeMessage(game: CrossOutGame, caption: String, session: MSSession? = nil) -> MSMessage {
        var components = URLComponents()
        components.queryItems = game.queryItems
        
        let layout = MSMessageTemplateLayout()
        
        layout.caption = caption
        
        let message = MSMessage(session: session ?? MSSession())
        message.url = components.url!
        message.layout = layout
        
        return message
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        
        // Use this to clean up state related to the deleted message.
    }
    
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    
}
