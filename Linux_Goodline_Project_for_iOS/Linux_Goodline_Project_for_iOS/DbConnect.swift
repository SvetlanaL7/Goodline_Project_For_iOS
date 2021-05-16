//
//  Linux_Goodline_Project_for_iOS
//
import Foundation
   
class DbConnect: DbProtocol  {
    
    private var dictionaryValue: [String: [String: String]] = [:]
    private let pathUrl: String
    
    init() {
        //объявляем путь к файлу с данными из словаря
        self.pathUrl = Bundle.main.path(forResource: "dictionary", ofType: "json") ?? ""
    }

    func GetValueFromDb() -> [String: [String: String]]? {
        //считывание данных (словаря) из файла -------------------------
        let fileManager = FileManager.default
        
        if let dataFile = fileManager.contents(atPath: pathUrl) {
            dictionaryValue = (try? JSONDecoder().decode([String: [String: String]].self, from: dataFile)) ?? [:]
            return dictionaryValue
        }
        else {
            return nil
        }
    }
}
