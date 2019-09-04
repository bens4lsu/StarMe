//
//  MyJWT.swift
//  StarMe
//
//  Created by Ben Schultz on 8/29/19.
//  Copyright © 2019 com.concordbusinessservicesllc. All rights reserved.
//

import Foundation
import SwiftJWT

enum AppleMusicAuthorization {
    static let keyID = "84MV92D26B"
    static let issuer = "4YE7E9G4GE"
    static let privateKeyFileName = "AuthKey_84MV92D26B"
    static let privateKeyFileExt = "p8"
    static let tokenExpirationSeconds = 3600.0
}

struct JWTClaim: Claims {
    let iss: String
    let iat: String
    let exp: String
}
