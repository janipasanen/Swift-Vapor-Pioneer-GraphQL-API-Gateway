import Vapor
import Logging
import Pioneer

@main
enum Entrypoint {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        
        let app = Application(env)
    
        let server = try Pioneer(
            schema: schema(),
            resolver: Resolver(),
            httpStrategy: .csrfPrevention,
            // Enabling GraphQL over WebSocket
            websocketProtocol: .graphqlWs,
            introspection: true,
            playground: .sandbox
        )
    
        defer { app.shutdown() }
    
        // Apply Pioneer to Vapor as a middleware
        app.middleware.use(
            server.vaporMiddleware(
                at: "graphql",
                context: { req, res in
                    Context(req: req, res: res)
                },
                websocketContext: { req, payload, gql in
                    Context(req: req, res: .init())
                }
            )
        )
        
        do {
            try await configure(app)
        } catch {
            app.logger.report(error: error)
            throw error
        }
        try await app.execute()
    }
}
