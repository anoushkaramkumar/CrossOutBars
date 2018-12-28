import Foundation
import UIKit
import Messages

class CrossOutGame {
    //row 1
    public var row1: [Bar] = [
        Bar(frame: CGRect(origin: CGPoint(x: (UIScreen.main.bounds.width-85)/2, y: 150),size: CGSize(width: 15, height: 103))),
        Bar(frame: CGRect(origin: CGPoint(x: (UIScreen.main.bounds.width-85)/2 + 35, y: 150), size: CGSize(width: 15, height: 103))),
        Bar(frame: CGRect(origin: CGPoint(x: (UIScreen.main.bounds.width-85)/2 + 70, y: 150), size: CGSize(width: 15, height: 103)))
    ]
    
    //row 2
    
    public var row2: [Bar] = [
        Bar(frame: CGRect( origin: CGPoint(x: (UIScreen.main.bounds.width-120)/2, y: 280), size: CGSize(width: 15, height: 103))),
        Bar(frame: CGRect( origin: CGPoint(x: (UIScreen.main.bounds.width-120)/2 + 35, y: 280), size: CGSize(width: 15, height: 103))),
        Bar(frame: CGRect( origin: CGPoint(x: (UIScreen.main.bounds.width-120)/2 + 70, y: 280), size: CGSize(width: 15, height: 103))),
        Bar(frame: CGRect( origin: CGPoint(x: (UIScreen.main.bounds.width-120)/2 + 105, y: 280), size: CGSize(width: 15, height: 103)))
    ]
    
    //row 3
    
    public var row3: [Bar] = [
        Bar(frame: CGRect( origin: CGPoint(x: (UIScreen.main.bounds.width-155)/2, y: 410), size: CGSize(width: 15, height: 103))),
        Bar(frame: CGRect( origin: CGPoint(x: (UIScreen.main.bounds.width-155)/2 + 35, y: 410), size: CGSize(width: 15, height: 103))),
        Bar(frame: CGRect( origin: CGPoint(x: (UIScreen.main.bounds.width-155)/2 + 70, y: 410), size: CGSize(width: 15, height: 103))),
        Bar(frame: CGRect( origin: CGPoint(x: (UIScreen.main.bounds.width-155)/2 + 105, y: 410), size: CGSize(width: 15, height: 103))),
        Bar(frame: CGRect( origin: CGPoint(x: (UIScreen.main.bounds.width-155)/2 + 140, y: 410), size: CGSize(width: 15, height: 103)))
    ]
    
    var startPoint : CGPoint = CGPoint()
    var endPoint : CGPoint = CGPoint()
    
    public var game_over : Bool
    public var new_game = false
    public var cur_color = UIColor.black
    public var cant_play : Bool = false
    
    // existing game
    init?(message: MSMessage) {
        
        guard let messageURL = message.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else { return nil }
        new_game = false
        
        let colors_json_arr = queryItems[1].value!
        let player_color_string = queryItems[0].value!
        print("current color: " + player_color_string)
        
        let game_over_str = queryItems[2].value!
        if game_over_str == "true" {
            game_over = true
        }
        else {
            game_over = false
        }
        
        let next_color = queryItems[3].value!
        print("next: " + next_color)
        
        if player_color_string == "red" {
            cur_color = UIColor(red:0.00, green:0.06, blue:1.00, alpha:1.0)
            if next_color == "blue" {
                cant_play = true
            }
        }
        else if player_color_string == "blue" {
            cur_color = UIColor(red:1.00, green:0.00, blue:0.06, alpha:1.0)
            if next_color == "red" {
                cant_play = true
            }
        }
        
        populate_colors(json_string: colors_json_arr)
    }
    
    // new game
    init(cur_player_id : String, opponent_id : String) {
        //        make_player_arr(player_arr)
        game_over = false
        new_game = true
        cur_color = UIColor(red:0.00, green:0.06, blue:1.00, alpha:1.0)
    }
    
    private func populate_colors(json_string : String) {
        if let data = json_string.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String]
                
                for (bar_str, color_str) in json! {
                    var color = UIColor.black
                    
                    switch color_str {
                    case "red":
                        //                        color = UIColor(red:1.00, green:0.00, blue:0.06, alpha:1.0)
                        color = UIColor.red
                    case "blue":
                        //                        color = UIColor(red:0.00, green:0.06, blue:1.00, alpha:1.0)
                        color = UIColor.blue
                    default:
                        break
                    }
                    let index = bar_str.index(bar_str.startIndex, offsetBy: 3)
                    let bar_num_str_v = bar_str.substring(from: index)
                    
                    if let bar_num = Int(bar_num_str_v) {
                        switch bar_num {
                        case 1:
                            row1[0].backgroundColor = color
                        case 2:
                            row1[1].backgroundColor = color
                        case 3:
                            row1[2].backgroundColor = color
                        case 4:
                            row2[0].backgroundColor = color
                        case 5:
                            row2[1].backgroundColor = color
                        case 6:
                            row2[2].backgroundColor = color
                        case 7:
                            row2[3].backgroundColor = color
                        case 8:
                            row3[0].backgroundColor = color
                        case 9:
                            row3[1].backgroundColor = color
                        case 10:
                            row3[2].backgroundColor = color
                        case 11:
                            row3[3].backgroundColor = color
                        case 12:
                            row3[4].backgroundColor = color
                        default:
                            break
                        }
                    }
                    
                    
                }
                
            } catch let error as NSError {
                fatalError("JSON PARSING ERROR: " + error.description)
            }
        } else {
            fatalError("populate colors error, unkown error")
        }
    }
    
    public func checkOneLeft() -> Bool {
        var count = 0
        
        for row1bar in row1 {
            if (row1bar.backgroundColor == UIColor.black) {
                count += 1
            }
        }
        
        for row2bar in row2 {
            if (row2bar.backgroundColor == UIColor.black) {
                count += 1
            }
        }
        
        for row3bar in row3 {
            if (row3bar.backgroundColor == UIColor.black) {
                count += 1
            }
        }
        
        if count == 1 {
            return true
        }
        else {
            return false
        }
    }
    
    
    public func get_string_from_color (color: UIColor) -> String {
        if (color == UIColor(red:1.00, green:0.00, blue:0.06, alpha:1.0) || color == UIColor.red) {
            return "red"
        }
        else if (color == UIColor(red:0.00, green:0.06, blue:1.00, alpha:1.0) || color == UIColor.blue) {
            return "blue"
        }
        else {
            return "black"
        }
    }
    
    func colors_to_json() -> String? {
        
        var color_dictionary = [String: String]()
        
        //TODO
        
        var index = 1
        
        for row1bar in row1 {
            let string_idx = "bar" + String(index)
            color_dictionary[string_idx] = get_string_from_color(color: row1bar.backgroundColor ?? UIColor.black)
            
            index += 1
        }
        
        for row2bar in row2 {
            let string_idx = "bar" + String(index)
            
            color_dictionary[string_idx] = get_string_from_color(color: row2bar.backgroundColor ?? UIColor.black)
            
            index += 1
        }
        
        for row3bar in row3 {
            let string_idx = "bar" + String(index)
            
            color_dictionary[string_idx] = get_string_from_color(color: row3bar.backgroundColor ?? UIColor.black)
            
            index += 1
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: color_dictionary, options: .prettyPrinted)
            
            return NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            return nil
        }
    }
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        let color_str = get_string_from_color(color: cur_color)
        var game_over_str = "false"
        
        if game_over {
            game_over_str = "true"
        }
        
        var next_color = "red"
        if color_str == "red" {
            next_color = "blue"
        }
        
        items.append(URLQueryItem(name: "Players", value: color_str))
        items.append(URLQueryItem(name: "Colors", value: colors_to_json()))
        items.append(URLQueryItem(name: "Game Over", value: game_over_str))
        items.append(URLQueryItem(name: "Next Col", value: next_color))
        
        return items
    }
}

class Player {
    public let player_id : String
    public let player_color : UIColor
    
    init(user_id: String, player_color: UIColor) {
        self.player_id = user_id
        self.player_color = player_color
    }
    
    var description: String {
        var color_string = ""
        
        if (player_color == UIColor(red:1.00, green:0.00, blue:0.06, alpha:1.0) || player_color == UIColor.red) {
            color_string = "red"
        }
        else if (player_color == UIColor(red:0.00, green:0.06, blue:1.00, alpha:1.0) || player_color == UIColor.blue) {
            color_string = "blue"
        }
        return color_string
    }
}

class Bar: UIView {
    
    public static var barcount = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bar.barcount += 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let h = rect.height
        let w = rect.width
        let x = rect.minX
        let y = rect.minY
        let color:UIColor = UIColor.yellow
        
        let drect = CGRect(x: x, y: y + 500, width: w, height: h)
        let bpath:UIBezierPath = UIBezierPath(rect: drect)
        
        color.set()
        bpath.stroke()
        bpath.fill()
    }
}
