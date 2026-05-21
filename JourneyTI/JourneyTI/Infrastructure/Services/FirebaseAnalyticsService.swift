import FirebaseAnalytics

final class FirebaseAnalyticsService: AnalyticsService {
    func track(_ event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }

    func setUserId(_ id: String?) {
        Analytics.setUserID(id)
    }

    func setUserProperty(_ value: String?, forName name: String) {
        Analytics.setUserProperty(value, forName: name)
    }
}
