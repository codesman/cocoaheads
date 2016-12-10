import Vapor
import VaporSQLite
import Foundation

let drop = Droplet()
try drop.addProvider(VaporSQLite.Provider.self)

drop.preparations += Topic.self

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

//drop.get("topic") { request in
//    
//    return try JSON(node: [
//        "title": topic.title,
//        "description": topic.description
//        ])
//}

drop.resource("topics", TopicController())

drop.run()
