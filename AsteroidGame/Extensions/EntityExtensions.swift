//
//  EntityExtensions.swift
//  AsteroidGame
//
//  Created by Cris on 19/07/20.
//  Copyright © 2020 Ingrid Guerrero. All rights reserved.
//

import Foundation
import GameplayKit

extension GKEntity {
    func destroyAfter(entity: EntityManager?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let strongSelf = self else { return }
            entity?.delete(strongSelf)
        }
    }
}
