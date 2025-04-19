// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "7299ff3f4d0ec264c627fb47579bc826"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Haircut.self)
    ModelRegistry.register(modelType: Client.self)
  }
}