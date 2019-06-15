//
//  HistoricoViewController.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 31/05/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit
import CoreData

class HistoricoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    // MARK: - Outlets
    @IBOutlet weak var tableViewHistorico: UITableView!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    //MARK: - variaveis
    var listaDeUsuarios:Array<UsuarioDataModel>?
    var listaAuxiliar:[UsuarioDataModel]?
    
    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupToolBar()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadTableView()
    }
    
    // MARK: - Funções
    func setupToolBar(){
        let toolBar = UIToolbar()
        let okButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.fechaTeclado))
        toolBar.setItems([okButton], animated: true)
        toolBar.sizeToFit()
        searchBarOutlet.inputAccessoryView = toolBar
    }
    
    func reloadTableView(){
        listaDeUsuarios = UsuarioDAO().recuperaUsuarios()
        listaAuxiliar = listaDeUsuarios
        tableViewHistorico.reloadData()
    }
    
    func setup(){
        tableViewHistorico.dataSource = self
        tableViewHistorico.delegate = self
        searchBarOutlet.delegate = self
    }
    
    // MARK: - funções da tableview 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? 60 : 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let lista = listaDeUsuarios else {return 0}
        return lista.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historicocell", for: indexPath) as! HistoricoTableViewCell
        guard let lista = listaDeUsuarios else {return cell}
        cell.qntdRepositoriosLabel.text = "\(lista[indexPath.row].numeroRepositoriosPublicos) repositórios públicos"
        cell.nomeUsuarioLabel.text = lista[indexPath.row].nome
        if let avatarUsuario = lista[indexPath.row].avatar as? UIImage {
            cell.avatarImageView.image = avatarUsuario
        }
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.width / 2
        cell.avatarImageView.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let usuario = listaDeUsuarios?[indexPath.row] else {return}
        let listaRepositorios = RepositorioDAO().recuperaRepositoriosDoUsuario(usuario: usuario)
        let usuarioViewController = UsuarioViewController()
        usuarioViewController.lista = ConversorHelper().converteListaRepositorio(listaRepositorios)
        usuarioViewController.usuario = ConversorHelper().converteUsuario(usuario)
        navigationController?.pushViewController(usuarioViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            AutenticacaoHelper().autorizaUsuario { (autenticado) in
                if autenticado{
                    DispatchQueue.main.async {
                        guard let lista = self.listaDeUsuarios else {return}
                        UsuarioDAO().deletaUsuario(usuario: lista[indexPath.row])
                        self.listaDeUsuarios?.remove(at: indexPath.row)
                        self.tableViewHistorico.deleteRows(at: [indexPath], with: .fade)
                        
                    }
                    
                }
            }
        }
    }
    
    // MARK: - Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let texto = searchBar.text{
            if texto.isEmpty{
                self.listaDeUsuarios = listaAuxiliar
                tableViewHistorico.reloadData()
            }else{
                self.listaDeUsuarios = Filtro().filtraUsuarios(listaDeUsuario: listaAuxiliar!, nomeDoUsuario: texto)
                tableViewHistorico.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.listaDeUsuarios = self.listaAuxiliar
        fechaTeclado()
        tableViewHistorico.reloadData()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fechaTeclado()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        fechaTeclado()
    }
    @objc func fechaTeclado(){
        //searchBarOutlet.endEditing(true)
        view.endEditing(true)
    }

    
}
