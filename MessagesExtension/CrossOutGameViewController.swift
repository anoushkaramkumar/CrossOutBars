import Foundation
import UIKit

class CrossOutGameViewController: UIViewController {
    static let storyboardIdentifier = "GameViewController"
    
    public var game: CrossOutGame?
    public var message = "Cross Out Game: Your turn."
    
    override func viewDidLoad() {
        for row1bar in (game?.row1)! {
            self.view.addSubview(row1bar)
        }
        
        for row2bar in (game?.row2)! {
            self.view.addSubview(row2bar)
        }
        
        for row3bar in (game?.row3)! {
            self.view.addSubview(row3bar)
        }
    }
    
    
    
    
}
