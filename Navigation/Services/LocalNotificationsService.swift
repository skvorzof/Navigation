//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Dima Skvortsov on 01.11.2022.
//

import Foundation
import UserNotifications

final class LocalNotificationsService {
    static let shared = LocalNotificationsService()
    private init() {}

    func registerForLatestUpdatesIfPossible() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.sheduleNotification()
            }
        }
    }

    private func sheduleNotification() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Внимание"
        content.body = "Посмотрите последние обновления"
        content.badge = 1

        var components = DateComponents()
        components.hour = 19
        components.minute = 00
        components.second = 00

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: true)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)

        center.add(request)
    }
}
