//
//  RepositorioViewController.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 01/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit
import SafariServices

class RepositorioViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var tituloRepositorioLabel: UILabel!
    @IBOutlet weak var numeroStarsLabel: UILabel!
    @IBOutlet weak var numeroForksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    @IBOutlet weak var descricaoCompletaLabel: UILabel!
    @IBOutlet weak var linguagemLabel: UILabel!
    @IBOutlet weak var dataCriacaoLabel: UILabel!
    @IBOutlet weak var AbrirNoGitHubButtonOutlet: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Variáveis
    let internet = CheckInternetConnectionHelper()
    var repositorio:Repositorio?
    
    // MARK: - Ciclo de vida
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupRespsitorio()
        
    }
    
    // MARK: - Funções
    
    func setup(){
        AbrirNoGitHubButtonOutlet.layer.cornerRadius = 15
        AbrirNoGitHubButtonOutlet.layer.masksToBounds = true
        scrollView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(mudaScrollView(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    
    @objc func mudaScrollView(_ notification:Notification){
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
           self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height + 100)
            scrollView.isScrollEnabled = true
        }else{
           self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height - 100)
            scrollView.isScrollEnabled = false

        }
    }
    
    func setupRespsitorio(){
        guard let repos = repositorio else {return}
        if let titulo = repos.nomeDoRepositorio{
            tituloRepositorioLabel.text = titulo
        }
        if let stars = repos.numeroDeStars{
            numeroStarsLabel.text = String(stars)
        }
        if let forks = repos.numeroDeForks{
            numeroForksLabel.text = String(forks)
        }
        if let issuesAbertas = repos.numeroDeIssuesAbertas{
            if let issuesFechadas = repos.numeroDeIssuesFechadas { //API do Github não retorna issues fechadas
                issuesLabel.text = "Issues: \(issuesAbertas) abertas" // Caso tivesse o numero de issues fechadas entraria nesta string
            }
            
        }
        if let descricao = repos.descricaoCompleta{
            descricaoCompletaLabel.text = descricao
        }
        if let linguagem = repos.linguagem{
            linguagemLabel.text = linguagem
        }
        if let dataCriacao = repos.dataDeCriacaoDoRepositorio{
            dataCriacaoLabel.text = DataFormatHelper().formata(dataCriacao)
        }
    }

    // MARK: - Action Buttons
    
    @IBAction func abrirNoGitHubButton(_ sender: UIButton) {
        if internet.checkInternet(){
            guard let repos = repositorio else {return}
            SafariHelper(controller: self).abrirNoSafari(URL: repos.urlDoRepositorio)
        }else{
            AlertDialogHelper(controller: self).show("Desculpe", message: "Estamos sem internet.")
        }
        
    }
}
