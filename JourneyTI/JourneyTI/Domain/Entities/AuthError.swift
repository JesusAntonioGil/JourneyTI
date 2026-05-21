import Foundation

enum AuthError: LocalizedError, Equatable {
    case invalidCredentials
    case userNotFound
    case emailAlreadyInUse
    case weakPassword
    case networkUnavailable
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidCredentials: "Email o contraseña incorrectos"
        case .userNotFound: "No existe ninguna cuenta con ese email"
        case .emailAlreadyInUse: "Ya existe una cuenta con ese email"
        case .weakPassword: "La contraseña debe tener al menos 6 caracteres"
        case .networkUnavailable: "Sin conexión. Comprueba tu red e inténtalo de nuevo"
        case .unknown: "Ha ocurrido un error inesperado"
        }
    }
}
