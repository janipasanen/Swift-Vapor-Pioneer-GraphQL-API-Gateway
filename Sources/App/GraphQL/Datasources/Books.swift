//
//  Books.swift
//  
//
//  Created by Jani Pasanen on 2024-02-24.
//

// https://pioneer-graphql.netlify.app/getting-started/
actor Books {
    private var books: [Book.ID: Book] = [:]

    func create(book: Book) -> Book? {
        guard case .none = books[book.id] else {
            return nil
        }
        books[book.id] = book
        return book
    }

    func all() -> [Book] {
        return books.values.map { $0 }
    }

    enum Errors: Error {
        case duplicate(id: Book.ID)
    }

    static let shared: Books = .init()
}
