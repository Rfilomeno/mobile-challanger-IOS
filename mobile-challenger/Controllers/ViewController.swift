//
//  ViewController.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 31/05/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    // MARK: - Outlets
    @IBOutlet weak var buscaTextField: UITextField!
    @IBOutlet weak var buttonBuscarOutlet: UIButton!
    @IBOutlet weak var loadingOutlet: UIActivityIndicatorView!
    @IBOutlet weak var scrollViewPrincipal: UIScrollView!
    @IBOutlet weak var helpButtonOutlet: UIButton!
    
    let internet = CheckInternetConnectionHelper()
    
    
    // MARK: - Ciclo de Vida
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupToolBar()
        
        
    }
    
    // MARK - Funções
    
    func setupToolBar(){
        let toolBar = UIToolbar()
        let okButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.fechaTeclado))
        toolBar.setItems([okButton], animated: true)
        toolBar.sizeToFit()
        buscaTextField.inputAccessoryView = toolBar
        buscaTextField.returnKeyType = .search
        
    }
    @objc func fechaTeclado(){
        view.endEditing(true)
    }
    func setup(){
        //setup do botão de help
        helpButtonOutlet.layer.cornerRadius = helpButtonOutlet.frame.height/2
        helpButtonOutlet.layer.masksToBounds = true
        
        
        // setup do botao buscar
        buttonBuscarOutlet.layer.cornerRadius = 15
        buttonBuscarOutlet.layer.masksToBounds = true
        buttonBuscarOutlet.layer.add(BotaoAnimadoHelper().animacao(),forKey: nil)
        
        // setup do textFild de busca
        buscaTextField.delegate = self
        buscaTextField.leftViewMode = .always
        let imagemBusca = UIImageView()
        imagemBusca.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imagemBusca.backgroundColor = .purple
        imagemBusca.layer.cornerRadius = 5
        imagemBusca.layer.masksToBounds = true
        let imagem = #imageLiteral(resourceName: "search.png")
        imagemBusca.image = imagem
        buscaTextField.leftView = imagemBusca
        loading(false)
        
        scrollViewPrincipal.isScrollEnabled = false
        // setup de notificações para ajustar scrollview e permitir scroll quando necessario
        NotificationCenter.default.addObserver(self, selector: #selector(aumentarScrollView(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(diminuiScrollView(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(mudaScrollView(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)

    }
    @objc func mudaScrollView(_ notification:Notification){
        
        if UIDevice.current.orientation == .portrait {
            diminuiScrollView(notification)
        }else{
            aumentarScrollView(notification)
        }
    }
    
    @objc func aumentarScrollView(_ notification:Notification) {
        scrollViewPrincipal.isScrollEnabled = true
        self.scrollViewPrincipal.contentSize = CGSize(width: self.scrollViewPrincipal.frame.width, height: self.scrollViewPrincipal.frame.height + 200)
    }
    @objc func diminuiScrollView(_ notification:Notification) {
        scrollViewPrincipal.isScrollEnabled = false
        self.scrollViewPrincipal.contentSize = CGSize(width: self.scrollViewPrincipal.frame.width, height: self.scrollViewPrincipal.frame.height - 200)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // função que define o que será feito ao apartar search no teclado.
        actionButtonBuscar(nil)
        return true
    }
    
    func loading(_ status:Bool){
        //função que define outlet de loading
        loadingOutlet.isHidden = !status
        buttonBuscarOutlet.isEnabled = !status
        
        if status{
            buttonBuscarOutlet.backgroundColor = .lightGray
            loadingOutlet.startAnimating()
        } else {
            loadingOutlet.stopAnimating()
            buttonBuscarOutlet.backgroundColor = .purple
        }
    }
    
    // MARK: - Action Buttons
    
    @IBAction func actionButtonBuscar(_ sender: UIButton?) {
        fechaTeclado()
        if internet.checkInternet(){
            loading(true)
            guard var user = buscaTextField.text else {return}
            user = user.trimmingCharacters(in: .whitespacesAndNewlines)
            GitHubApi().recuperaUsuario(user) { (usuario) in
                    if usuario == nil{
                        AlertDialogHelper(controller: self).show("Usuário não Encontrado", message: "Desculpe, não conseguimos localizar o usuário solicitado")
                        self.loading(false)
                    }else{
                        GitHubApi().recuperaListaUsuario(user, completion: { (lista) in
                            let usuarioViewController = UsuarioViewController()
                            guard let usuarioNaoSalvo = usuario else {return}
                            guard let listaNaoSalva = lista else {return}
                            UsuarioDAO().salvaUsuario(usuarioNaoSalvo, lista: listaNaoSalva)
                            usuarioViewController.usuario = usuario
                            usuarioViewController.lista = lista
                            self.loading(false)
                            self.navigationController?.pushViewController(usuarioViewController, animated: true)
                        })
                    }
            }
        }else{
            guard var user = buscaTextField.text else {return}
            user = user.trimmingCharacters(in: .whitespacesAndNewlines)
            if let usuarioEncontrado = UsuarioDAO().recuperaUsuario(user: user){
                guard let nome = usuarioEncontrado.nome else {return}
                let message = "No momento estamos sem conexão,\nporém encontramos o usuário \(nome.uppercased())\n em sua base de dados.\n gostaria de vizualiza-lo?"
                let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: UIAlertController.Style.alert)
                let cancelar = UIAlertAction(title: "Não", style: UIAlertAction.Style.destructive, handler: nil)
                let ok = UIAlertAction(title: "Sim", style: UIAlertAction.Style.default) { (action) in
                    let listaEncontrada = RepositorioDAO().recuperaRepositoriosDoUsuario(usuario: usuarioEncontrado)
                    let usuario = ConversorHelper().converteUsuario(usuarioEncontrado)
                    let lista = ConversorHelper().converteListaRepositorio(listaEncontrada)
                    let usuarioViewController = UsuarioViewController()
                    usuarioViewController.usuario = usuario
                    usuarioViewController.lista = lista
                    self.navigationController?.pushViewController(usuarioViewController, animated: true)
                }
                alert.addAction(ok)
                alert.addAction(cancelar)
                present(alert, animated: true, completion: nil)
                
            }else{
                AlertDialogHelper(controller: self).show("Desculpe", message: "Estamos sem internet.")
            }
            
        }
    }
    
    
    @IBAction func openHelp(_ sender: Any) {
        let pdfViewController = PDFViewController()
        navigationController?.pushViewController(pdfViewController, animated: true)
    }
}

