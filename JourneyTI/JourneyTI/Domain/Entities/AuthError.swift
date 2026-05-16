import Foundation

enum AuthError: LocalizedError, Equatable {
    case invalidCredentials
    case networkUnavailable
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidCredentials: "Email o contraseña incorrectos"
        case .networkUnavailable: "Sin conexión. Comprueba tu red e inténtalo de nuevo"
        case .unknown: "Ha ocurrido un error inesperado"
        }
    }
}
