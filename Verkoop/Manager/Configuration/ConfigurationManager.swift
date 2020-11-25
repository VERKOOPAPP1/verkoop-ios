//
//  ConfigurationManager.swift
//  Mudarib
//
//  Created by Vijay's Macbook on 12/02/18.
//  Copyright © 2018 Mobilecoderz. All rights reserved.
//

import UIKit

class ConfigurationManager: NSObject {
    
    fileprivate enum AppEnvironment: String {
        case development = "Development"
        case production = "Production"
    }
    
    fileprivate struct AppConfiguration {
        var socketEndPoint: String
        var environment: AppEnvironment
    }
    
    fileprivate var activeConfiguration: AppConfiguration!
    
    // MARK: - Singleton Instance
    private static let _shared = ConfigurationManager()
    
    class func shared() -> ConfigurationManager {
        return _shared
    }
    
    private override init() {
        super.init()
        
        // Load application selected environment and its configuration
        if let environment = self.currentEnvironment() {
            
            self.activeConfiguration = self.configuration(environment: environment)
            
            if self.activeConfiguration == nil {
                assertionFailure(NSLocalizedString("Unable to load application configuration", comment: "Unable to load application configuration"))
            }
        } else {
            assertionFailure(NSLocalizedString("Unable to load application flags", comment: "Unable to load application flags"))
        }
    }
    
    private func currentEnvironment() -> AppEnvironment? {
        #if DEBUG
            return AppEnvironment.development
        #else
            return AppEnvironment.production
        #endif
    }
    
    /**
     Returns application active configuration
     
     - parameter environment: An application selected environment
     
     - returns: An application configuration structure based on selected environment
     */
    
    private func configuration(environment: AppEnvironment) -> AppConfiguration {
        
        switch environment {
        case .development:
            return debugConfiguration()
        case .production:
            return productionConfiguration()
        }
    }
    
    private func debugConfiguration() -> AppConfiguration {
        
        return AppConfiguration(
            socketEndPoint: "http://verkoopadmin.com:3000/",
            environment: .development)
    }
    
    private func productionConfiguration() -> AppConfiguration {
        return AppConfiguration(
            socketEndPoint: "http://verkoopadmin.com:3000/",
            environment: .production
        )
    }
}

extension ConfigurationManager {
    
    // MARK: - Public Methods
    
    func applicationEnvironment() -> String {
        return self.activeConfiguration.environment.rawValue
    }
    
    func socketEndPoint() -> String {
        return self.activeConfiguration.socketEndPoint
    }
}
