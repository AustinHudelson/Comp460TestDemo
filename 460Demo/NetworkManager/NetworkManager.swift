import Foundation

/*
    An object that manages sending and receiving msgs over AppWarp.
    This object sends & recevies data using a specific dictionary format (Dictionary<String, Array<AnyObject>>).
    An example of a dictionary that is passed over the network looks like this:
        data = {
            "Units":
                [Unit(player1), Unit(player2), Unit(enemy1), Unit(enemey2)]
            "Order":
                [Order(player1, Move(location)), Order(player2, Attack(enemy1))]
            "SentTime":
                ["3/3/15, 4:44:45 AM GMT"]
        }

    In regards to sending, user should construct his own 
    Functions should be added to this class & called in the processRecv

*/
class NetworkManager {
    
    /*
        send / receieve variables
    */
    var sendDict: Dictionary<String, Array<AnyObject>>? = nil
}
