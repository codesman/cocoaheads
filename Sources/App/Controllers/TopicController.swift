import Vapor
import HTTP

final class TopicController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try Topic.all().makeNode().converted(to: JSON.self)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var topic = try request.topic()
        try topic.save()
        return topic
    }
    
    func show(request: Request, topic: Topic) throws -> ResponseRepresentable {
        return topic
    }
    
    func delete(request: Request, topic: Topic) throws -> ResponseRepresentable {
        try topic.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        try Topic.query().delete()
        return JSON([])
    }
    
    func update(request: Request, topic: Topic) throws -> ResponseRepresentable {
        let new = try request.topic()
        var topic = topic
        topic.title = new.title
        try topic.save()
        return topic
    }
    
    func replace(request: Request, topic: Topic) throws -> ResponseRepresentable {
        try topic.delete()
        return try create(request: request)
    }
    
    func makeResource() -> Resource<Topic> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func topic() throws -> Topic {
        guard let json = json else { throw Abort.badRequest }
        return try Topic(node: json)
    }
}
