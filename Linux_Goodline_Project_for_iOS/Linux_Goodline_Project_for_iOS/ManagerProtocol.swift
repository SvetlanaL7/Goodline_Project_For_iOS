//
//  Linux_Goodline_Project_for_iOS
//
public protocol ManagerProtocol {
   func managerValueForSearch(key: String?, language: String?) -> Result<ManagerResult, ManagerResultError>
}
