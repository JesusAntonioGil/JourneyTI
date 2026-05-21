enum AnalyticsEvent {
    case view(Screen)
    case action(Screen, Element)
    case request(RequestName, RequestResult)

    var name: String {
        switch self {
        case .view: return "VIEW"
        case .action: return "ACTION"
        case .request: return "REQUEST"
        }
    }

    var parameters: [String: String] {
        switch self {
        case .view(let screen):
            return ["screen": screen.rawValue]
        case .action(let screen, let element):
            return ["screen": screen.rawValue, "element": element.rawValue]
        case .request(let requestName, let result):
            var params = ["name": requestName.rawValue]
            switch result {
            case .success:
                params["result"] = "success"
            case .failure(let errorCode):
                params["result"] = "failure"
                params["error_code"] = errorCode
            }
            return params
        }
    }
}

enum Screen: String {
    case login
    case register
    case forgotPassword = "forgot_password"
    case content
}

enum Element: String {
    case loginButton = "login_button"
    case forgotPassword = "forgot_password"
    case register
    case submitRegister = "submit_register"
    case submitResetPassword = "submit_reset_password"
    case logout
}

enum RequestName: String {
    case login
    case register
    case logout
    case resetPassword = "reset_password"
}

enum RequestResult {
    case success
    case failure(errorCode: String)
}
