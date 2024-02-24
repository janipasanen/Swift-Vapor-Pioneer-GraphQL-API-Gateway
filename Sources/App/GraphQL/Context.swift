//
//  Context.swift
//  
//
//  Created by Jani Pasanen on 2024-02-24.
//

import class Vapor.Request
import class Vapor.Response

struct Context {
    var req: Request
    var res: Response
}
