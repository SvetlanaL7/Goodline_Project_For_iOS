//
//  Linux_Goodline_Project_for_iOS
//
import Foundation

public enum ManagerResult: Equatable {
    case search( _ keywords: Keys, dictionary: [String: [String: String]])
    case updateSuccess
    case deleteSuccess
}

public enum ManagerResultError: Error {
    case notFound
    case notFoundKey
    case notFoundLanguage
    case emptyDictionary
    case dbConectFailed
}

public enum Keys: Equatable {
    case keysNil
    case keyK
    case keyL
    case keysKL
}
