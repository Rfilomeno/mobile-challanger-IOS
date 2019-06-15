//
//  UsuarioViewController.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 31/05/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit

class UsuarioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    // MARK: - Outlets
    @IBOutlet weak var usuarioImageView: UIImageView!
    @IBOutlet weak var nomeUsuarioLabel: UILabel!
    @IBOutlet weak var tableViewRepositoriosUsuario: UITableView!
    @IBOutlet weak var numeroRepPublicosLabel: UILabel!
    @IBOutlet weak var numeroSeguidoresLabel: UILabel!
    @IBOutlet weak var numeroSeguindoLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var quantidadeListadaLabel: UILabel!
    @IBOutlet weak var plusButtonOutlet: UIButton!
    @IBOutlet weak var loadingOutlet: UIActivityIndicatorView!
    
    // MARK: - Variáveis
    let searchController = UISearchController(searchResultsController: nil)
    var usuario:Usuario?
    var lista:ListaRepositorio?
    
    lazy var listaOrdenada:ListaRepositorio = {
        guard let listaDesordenada = lista else {return []}
        return OrdenaListaRepositorioHelper().ordena(listaDesordenada)
    }()
    
    let internet = CheckInternetConnectionHelper()
    
    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configuraSearch()
        dadosUsuario()
    }
    
    // MARK: - Funções
    
    func setup(){
        tableViewRepositoriosUsuario.dataSource = self
        tableViewRepositoriosUsuario.delegate = self
        tableViewRepositoriosUsuario.register(UINib(nibName: "RepositoriosUsuarioTableViewCell", bundle: nil), forCellReuseIdentifier: "cellrepositoriousuario")
        edgesForExtendedLayout = []
        usuarioImageView.layer.cornerRadius = 25
        usuarioImageView.layer.masksToBounds = true
        loadingOutlet.isHidden = true
        
    }
   
    @objc func fechaTeclado(){
        view.endEditing(true)
    }
    
    func configuraSearch() {
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Pesquise pelo nome do repositório"
        
        let toolBar = UIToolbar()
        let okButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.fechaTeclado))
        toolBar.setItems([okButton], animated: true)
        toolBar.sizeToFit()
        searchBar.inputAccessoryView = toolBar
    }
    
    
    func dadosUsuario(){
        guard let usuario = usuario else {return}
        if let nomeUsuario = usuario.nome{
            nomeUsuarioLabel.text = nomeUsuario
        }
        if usuario.avatarFoto == nil{
            guard let urlAvatarUsuario = usuario.avatar else {return}
            let avatarUsuarioOP = try? Data(contentsOf: urlAvatarUsuario)
            if let avatarUsuario = avatarUsuarioOP{
                usuarioImageView.image = UIImage(data: avatarUsuario)
            }
        }else{
            if let avatarUsuario = usuario.avatarFoto as? UIImage{
             usuarioImageView.image = avatarUsuario
            }
        }
        if let numeroRepositorio = usuario.numeroDeRepositoriosPublicos{
            numeroRepPublicosLabel.text = "Rep. públicos: \(numeroRepositorio)"
            self.quantidadeListadaLabel.text = "Listando \(listaOrdenada.count) / \(numeroRepositorio) repositórios"
            if listaOrdenada.count == numeroRepositorio{
                plusButtonOutlet.isEnabled = false
            }else{
                plusButtonOutlet.isEnabled = true
            }
        }
        if let numeroSeguidores = usuario.seguidores{
            numeroSeguidoresLabel.text = "Seguidores: \(numeroSeguidores)"
        }
        if let numeroSeguindo = usuario.seguindo{
            numeroSeguindoLabel.text = "Seguindo: \(numeroSeguindo)"
        }
    }
    
    // MARK: - Funções da TableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? 60 : 85
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaOrdenada.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewRepositoriosUsuario.dequeueReusableCell(withIdentifier: "cellrepositoriousuario", for: indexPath) as! RepositoriosUsuarioTableViewCell
        guard let tituloRepositorio = listaOrdenada[indexPath.row].nomeDoRepositorio else {return cell}
        cell.tituloRepositorioLabel.text = tituloRepositorio
        let descricao = listaOrdenada[indexPath.row].descricaoCompleta
        if descricao == nil {
            cell.descricaoTruncadaLabel.text = "Sem descrição"
        }else{
            let descricaoTruncada = descricao!.prefix(15) + " ..."
            cell.descricaoTruncadaLabel.text = String(descricaoTruncada)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repositorioSelecionado = listaOrdenada[indexPath.row]
        let repositorioViewController = RepositorioViewController()
        repositorioViewController.repositorio = repositorioSelecionado
        self.searchBar.endEditing(true)
        navigationController?.pushViewController(repositorioViewController, animated: true)
    }
 
    // MARK: - Action Buttons
    
    @IBAction func gitHubButton(_ sender: UIButton) {
        if internet.checkInternet(){
            guard let user = usuario else {return}
            SafariHelper(controller: self).abrirNoSafari(URL: user.urlDoUsuario)
        }else{
            AlertDialogHelper(controller: self).show("Desculpe", message: "Estamos sem internet.")
        }
        
    }
    @IBAction func plusButton(_ sender: UIButton) {
        if internet.checkInternet(){
            plusButtonOutlet.isEnabled = false
            loadingOutlet.isHidden = false
            loadingOutlet.startAnimating()
            let pageCounter = Int(listaOrdenada.count / 100) + 1
            GitHubApi().recuperaListaUsuario(usuario!.user!, String(pageCounter)) { (listaRecuperada) in
                guard let listaDesordenada = listaRecuperada else {return}
                guard let id = self.usuario?.id else {return}
                if let usuarioDataModel = UsuarioDAO().recuperaUsuario(id: id){
                    RepositorioDAO().salvarListaDeRepositorios(listaDesordenada, usuario: usuarioDataModel)
                }
                self.listaOrdenada.append(contentsOf: listaDesordenada)
                self.listaOrdenada = OrdenaListaRepositorioHelper().ordena(self.listaOrdenada)
                self.dadosUsuario()
                self.loadingOutlet.isHidden = true
                self.loadingOutlet.stopAnimating()
                self.tableViewRepositoriosUsuario.reloadData()
                
            }
        }else{
            AlertDialogHelper(controller: self).show("Desculpe", message: "Estamos sem internet.")
        }
        
    }
    
    // MARK: - Search Bar

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let listaAuxiliar = self.lista else {return}
        if let texto = searchBar.text{
            if texto.isEmpty{
                self.listaOrdenada = self.lista!
                tableViewRepositoriosUsuario.reloadData()
            }else{
                listaOrdenada = Filtro().filtraRepositorios(listaDeRepositorio: listaAuxiliar, nomeDoRepositorio: texto)
                 tableViewRepositoriosUsuario.reloadData()
            }
            
        }
        
}
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.listaOrdenada = self.lista!
        tableViewRepositoriosUsuario.reloadData()

    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fechaTeclado()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        fechaTeclado()
    }
    
}
