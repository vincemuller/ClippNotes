// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "25fc7a3d72b2e13f67480bbc023c153f"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Haircut.self)
    ModelRegistry.register(modelType: Customer.self)
  }
}