// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "c5d85bcc2f360f990aa5e9980165abff"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Haircut.self)
    ModelRegistry.register(modelType: Client.self)
  }
}