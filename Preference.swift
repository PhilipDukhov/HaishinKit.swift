import Foundation

struct Preference {
    static let defaultInstance:Preference = Preference()
    
    var uri:String? = "rtmp://test:test@192.168.11.9/live"
    var streamName:String? = "live"
}
