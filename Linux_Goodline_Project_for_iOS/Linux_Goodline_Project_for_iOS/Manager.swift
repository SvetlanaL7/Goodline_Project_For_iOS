//
//  Linux_Goodline_Project_for_iOS
//
import Foundation
   
class ManagerGetValue: ManagerProtocol  {
    private var dictionaryValue: [String: [String: String]] = [:]
    private lazy var dictionaryForWrite: [String: [String: String]] = [:]
    public var status = false
    private var keywords: String? = nil
    var dataDb: DbProtocol
    var dataFromDb: [String: [String: String]]? = nil
    private var dictKey: String = ""

    init(dictionaryProtocol: DbProtocol) {
        self.dataDb = dictionaryProtocol
        dataFromDb = dataDb.GetValueFromDb()
       
        guard let db = dataFromDb else {
           return
        }

        dictionaryValue = db
    }

    func managerValueForSearch(key: String?, language: String?) -> Result<ManagerResult, ManagerResultError> {
        guard dataFromDb != nil else {
            return .failure(.dbConectFailed)
        }

        dictionaryForWrite = [:]

        if key != nil || language != nil {
            if let keyValue = key, let languageValue = language {
                Calculation3(key: keyValue, language: languageValue)
                
                guard status else {
                    return .failure(.notFound)
                }

                return .success(.search(.keysKL, dictionary: dictionaryForWrite))
            }
            else {
                if let keyValue = key {
                    Calculation2_Key_K(keys: keyValue)
                    
                    guard status else {
                        return .failure(.notFoundKey)
                    }

                    return .success(.search(.keyK, dictionary: dictionaryForWrite))
                }
                else {
                    if let languageValue = language {
                        Calculation2_Key_L(language: languageValue)
                    }

                    guard status else {
                        return .failure(.notFoundLanguage)
                    }

                    return .success(.search(.keyL, dictionary: dictionaryForWrite))
                }
            }
        }
        else {
            guard dictionaryValue != [:] else {
                return .failure(.emptyDictionary)
            }

            dictionaryForWrite = dictionaryValue
            return .success(.search(.keysNil, dictionary: dictionaryForWrite))
        }
    }

    func Calculation2_Key_K (keys: String) {
        for dictionary in dictionaryValue {
            if let dictstr = dictionary.value[keys] {
                if dictionaryForWrite[dictionary.key] != nil {
                    dictionaryForWrite[dictionary.key]?.updateValue(dictstr,forKey:keys)
                }
                else {
                    dictionaryForWrite.updateValue([keys:dictstr],forKey:dictionary.key)
                    status = true
                }
            }
        }
    }

    func Calculation2_Key_L (language: String) {
        for dictionary in dictionaryValue {
            if dictionary.key == language {
                dictionaryForWrite.updateValue(dictionary.value,forKey:language)
                status = true
            }
        }
    }

    func Calculation3(key: String, language: String) {
        for dictionary in dictionaryValue {
            if dictionary.key == language {
                for dictElement in dictionary.value {
                    if dictElement.key == key {
                        status = true
                        dictionaryForWrite.updateValue([key:dictElement.value],forKey:language)

                    }
                }
            }
        }
    }
}    
