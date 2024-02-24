//
//  Resolver.swift
//  
//
//  Created by Jani Pasanen on 2024-02-24.
//

import struct Graphiti.NoArguments
import struct Vapor.Abort

struct Resolver {
    // Subscription resolver; https://pioneer-graphql.netlify.app/getting-started/
    private let pubsub: PubSub = AsyncPubSub()
    private let trigger = "*:book-added"
    
    func books(ctx: Context, args: NoArguments) async -> [Book] {
        await Books.shared.all()
    }

    struct NewArgs: Decodable {
        var title: String
    }

    func newBook(ctx: Context, args: NewArgs) async throws -> Book {
        let book = await Books.shared.create(
            book: Book(id: .uuid(), title: args.title)
        )
        guard let book else {
            throw Abort(.internalServerError)
        }
        await pubsub.publish(for: trigger, payload: book)
        return book
    }
    
    // Subscription resolver
    func bookAdded(ctx: Context, args: NoArguments) -> EventStream<Book> {
        pubsub.asyncStream(Book.self, for: trigger).toEventStream()
    }
}
