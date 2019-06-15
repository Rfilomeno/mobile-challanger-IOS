//
//  OrdenaListaRepositorioHelper.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 02/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit

class OrdenaListaRepositorioHelper: NSObject {

    func ordena(_ listaDesordenada:ListaRepositorio) -> ListaRepositorio{
        
        let listaOrd = listaDesordenada.sorted(by: { $0.numeroDeStars! > $1.numeroDeStars!})
        return listaOrd
    }
    
}
