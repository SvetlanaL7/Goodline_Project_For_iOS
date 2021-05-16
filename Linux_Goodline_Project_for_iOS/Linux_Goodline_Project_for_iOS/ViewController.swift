//
//  ViewController.swift
//  Linux_Goodline_Project_for_iOS
//
import UIKit

class ViewController: UIViewController {

    private var resultString: String = ""
    
    @IBOutlet weak var keyTextField: UITextField!
    
    @IBOutlet weak var languageTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resultLabel.text = ""
        searchButton.setTitle("Search", for: .normal)
        keyTextField.placeholder = "Введите ключ"
        languageTextField.placeholder = "Введите язык"
    }

    @IBAction func searchDictionaryButton(_ sender: Any) {
        resultLabel.text = ""
        
        var key: String? = nil
        var language: String? = nil
        
        if keyTextField.text != "" {
            key = keyTextField.text
        }
        
        if languageTextField.text != "" {
            language = languageTextField.text
        }
        
        let managerResult = AppContainer.Container().managerProtocol.managerValueForSearch(key: key, language: language)
        
        switch managerResult {
            case .success(let value):
                if case .search(let keywords, let dictionary) = value {
                    resultString = ""
                    switch keywords {
                        case .keysKL:
                            resultLabel.text = PrintResultKeysKL(dictionary:dictionary)
                        case .keyK, .keysNil:
                            resultLabel.text = PrintResult(dictionary: dictionary)
                        case .keyL:
                            resultLabel.text = PrintResultKeyL(dictionary: dictionary)
                    }
                }
                else {
                    resultLabel.text = "Error in the class operation" //пришел результат не из того класса (выполнилась не та подкоманда)
                }
                
            case .failure(let value):
                resultLabel.text = "Error! Dictionary not found."
                switch value {
                    case .notFound:
                        resultLabel.text =  "Not Found"
                    case .notFoundKey:
                        resultLabel.text =  "Ключ не найден"
                    case .notFoundLanguage:
                        resultLabel.text =  "Такого языка для перевода в словаре нет"
                    case .emptyDictionary:
                        resultLabel.text =  "Словарь пуст!"
                    case .dbConectFailed:
                        resultLabel.text =  "Ошибка соединения с базой данных!"
                }
        }
    }
    
    func PrintResultKeyL(dictionary: [String: [String: String]]) -> String {
        for dict in dictionary {
            for dictionaryValue in dict.value {
               resultString = resultString + dictionaryValue.key + " = " + dictionaryValue.value + " "
            }
        }
        return resultString
    }

    func PrintResultKeysKL(dictionary: [String: [String: String]]) -> String {
        for dict in dictionary {
            for dictionaryValue in dict.value {
                resultString = dictionaryValue.value
            }
        }
        return resultString
    }

    func PrintResult(dictionary: [String: [String: String]]) -> String {
        
        var keyLanguage: [String] = []
            
        for dict in dictionary {  //ищет значение словаря среди значений словарей в массиве словарей и выводит язык (ru/en/pt)
            for dictionaryValue in dict.value {
                 keyLanguage.append(String(dictionaryValue.key))
            }
        }

        keyLanguage = Array(Set(keyLanguage))
        
        for i in 0...keyLanguage.count-1 {
            resultString = resultString + keyLanguage[i] + ": "
            for dict in dictionary {
                if let dictStr = dict.value[keyLanguage[i]] {
                    resultString = resultString + dict.key + " - " + dictStr + ", "
                }
            }
        }
        return resultString
    }
}
