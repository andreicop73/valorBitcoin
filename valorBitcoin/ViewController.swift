//
//  ViewController.swift
//  valorBitcoin
//
//  Created by mac ssd on 08/09/17.
//  Copyright © 2017 andruino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var valorBrasil: UILabel!
    
        
    @IBOutlet weak var btnatualizar: UIButton!
    
   @IBAction func Atualizar(_ sender: Any) {
    
    self.recuperarValorBitcoin()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.recuperarValorBitcoin()
    }
    
    func formatarValor(valor: NSNumber) -> String{
       
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_BR")
        
        if let valorFinal = nf.string(from: valor){
            return valorFinal
        }
        
        return "0,00"
        
    }
    
    func recuperarValorBitcoin() {
        
        
        self.btnatualizar.setTitle("Atualizando...", for: .normal)
        if let url = URL(string: "https://blockchain.info/pt/ticker") {
            
            
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                
                if erro == nil {
                    
                    if let dadosRetorno = dados {
                        
                        do{
                            
                            if let objetoJason = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: Any] {
                                
                                
                                if let valorBrl = objetoJason["BRL"] as? [String: Any] {
                                    
                                    if let valorCompra = valorBrl["buy"] as? Double {
                                        
                                        let valorFormatado = self.formatarValor(valor: NSNumber(value: valorCompra))
                                        
                                        DispatchQueue.main.async(execute: {
                                            self.valorBrasil.text = "R$" + valorFormatado
                                            self.btnatualizar.setTitle("Atualizar", for: .normal)
                                            
                                        })
                                    }
                                }
                                
                                
                            }
                        }catch let erro as NSError{
                            print("Erro ao formatar retorno Erro: \(erro.description)")
                            
                        }
                        
                    }
                    
                }else {
                    print(erro as Any)
                }
            }
            tarefa.resume()
        }//fim do if
    }
}



