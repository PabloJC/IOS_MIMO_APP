

import Foundation
import AFNetworking

class MyAPIClient: AFHTTPSessionManager {
    
    
    init() {
		super.init(baseURL: NSURL(string: "http://aqueous-beyond-94598.herokuapp.com/")!,
			sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
    }
    
    func getUsersPage(
        recipes: ((String,Int) -> ())?,
		finished: (() -> ())?,
		failure:  (NSError -> ())?) {
            self.requestSerializer = AFJSONRequestSerializer()
            self.responseSerializer = AFJSONResponseSerializer()

        let url = "/recipes"
        self.GET(url,
			parameters: nil,
			progress: nil,
			success: { operation, responseObject in
	            
    	            let result = responseObject! as! [[String:AnyObject]]
                for recipe in result {
                    let id = recipe["id"]!
                    let nombre = recipe["name"]!
                    recipes!(nombre as! String, id as! Int)
                }
                
	                finished?()
				
            },
			failure:  { operation, error in
				failure?(error)
			})
    }
    
}