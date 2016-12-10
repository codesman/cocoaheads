import Vapor
import Fluent

final class Topic: Model {
    
    var id: Node?
    var title: String
    var description: String
    var submitter: String?
    var votes: Int?
    var presenter: String?
    var approved: Bool?
    var exists: Bool?
    
    init(
        id: Node?,
        title: String,
        description: String,
        submitter: String?,
        votes: Int?,
        presenter: String?,
        approved: Bool?,
        exists: Bool?
        
        ) {
        self.id = id
        self.title = title
        self.description = description
        self.submitter = submitter
        self.votes = votes
        self.presenter = presenter
        self.approved = approved
        self.exists = exists
    }
    
    required init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        title = try node.extract("title")
        description = try node.extract("description")
        submitter = try node.extract("submitter")
        votes = try node.extract("votes")
        presenter = try node.extract("presenter")
        approved = try node.extract("approved")
        exists = try node.extract("exists")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "title": title,
            "description": description,
            "submitter": submitter,
            "votes": votes,
            "presenter": presenter,
            "approved": approved,
            "exists": exists
            ])
    }
}

extension Topic: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("topics") { topic in
            topic.id()
            topic.string("title")
            topic.string("description")
            topic.string("submitter", optional: true)
            topic.int("votes", optional: true)
            topic.string("presenter")
            topic.bool("approved", optional: true)
            topic.bool("exists", optional: true)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("topics")
    }
}
