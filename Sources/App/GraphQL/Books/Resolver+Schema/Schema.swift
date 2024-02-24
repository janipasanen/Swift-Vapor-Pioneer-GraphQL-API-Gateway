//
//  Schema.swift
//  
//
//  Created by Jani Pasanen on 2024-02-24.
//

import Graphiti
import struct Pioneer.ID

func schema() throws -> Schema<Resolver, Context> {
    try .init {
        // Adding ID as usable scalar for Graphiti
        Scalar(ID.self)

        // The Book as a GraphQL type with all its properties as fields
        Type(Book.self) {
            Field("id", at: \.id)
            Field("title", at: \.title)
        }

        Query {
            // The root query field to fetch all books
            Field("books", at: Resolver.books)
        }

        Mutation {
            // The root mutation field to create a new book
            Field("newBook", at: Resolver.newBook) {
                // Argument for this field
                Argument("title", at: \.title)
            }
        }
        
        Subscription {
            SubscriptionField("bookAdded", as: Book.self, atSub: Resolver.bookAdded)
        }
    }
}
