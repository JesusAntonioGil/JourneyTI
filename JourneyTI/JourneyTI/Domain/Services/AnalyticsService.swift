protocol AnalyticsService {
    func track(_ event: AnalyticsEvent)
    func setUserId(_ id: String?)
    func setUserProperty(_ value: String?, forName name: String)
}
