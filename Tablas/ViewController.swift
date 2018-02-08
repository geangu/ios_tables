//
//  ViewController.swift
//  Tablas
//
//  Created by ggutierrez on 8/02/18.
//  Copyright © 2018 qwerty. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    // Fuente de datos inicial
    var usuarios = [
        [
            "nombre": "Presto",
            "ubicacion_txt": "",
            "categorias": "Hamburguesas y Perros Calientes",
            "logo_path": "http://corporate.la/wp-content/uploads/2015/05/LOGO-GORDO_cuaderno-de-marcas-corporate.jpg",
            "url_detalle": "",
            "tiempo_domicilio": 45,
            "rating": 3,
            "domicilio": 4300.00
        ]
    ]
    
    // Metodo del ciclo de vida de la aplicación que inicializa los componentes
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Asociacion de protocolos
        table.dataSource = self
        table.delegate = self
        
        // Constantes de url y petición
        let url = URL(string: "https://api.myjson.com/bins/4l602")
        let request = URLRequest(url: url!)
        
        // Definición de tarea asincrona para carga de fuente de datos
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                // Envia datos de manera asyncrona al hilo de ejecucion principal
                DispatchQueue.main.async {
                    
                    // Conversión de datos a objetos JSON
                    do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: data!, options : .allowFragments) as? [Dictionary<String,Any>]{
                            self.usuarios = jsonArray
                            self.table.reloadData()
                        } else {
                            print("bad json")
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
        }
        
        // Inicia la tarea asincrona
        task.resume()
    }
    
    // Informa al manejador de vistas la cantidad del resultados a mostrar
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    // Se encarga de alimentar cada una de las celdas a partir de la fuente de datos
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = (usuarios[indexPath.row]["nombre"] as! String)
        cell.detailTextLabel?.text = (usuarios[indexPath.row]["categorias"] as! String)
        return cell
    }
    
    // Ejecuta una acción cuando se toca sobre una celda
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        print("Selecciono el item: \(usuarios[indexPath.row])")
    }

}

