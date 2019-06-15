//
//  BotaoAnimadoHelper.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 08/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit

class BotaoAnimadoHelper: NSObject {
    
    func animacao()->CASpringAnimation{
        let click = CASpringAnimation(keyPath: "transform.scale")
        click.duration = 0.1
        click.fromValue = 1.0
        click.toValue = 0.95
        click.autoreverses = true
        click.repeatCount = 1
        click.initialVelocity = 0.5
        click.damping = 1.0
        return click
    }
    

}
