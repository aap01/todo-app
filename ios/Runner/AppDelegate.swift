import UIKit
import Flutter
import workmanager

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
        // Registry in this case is the FlutterEngine that is created in Workmanager's
        // performFetchWithCompletionHandler or BGAppRefreshTask.
        // This will make other plugins available during a background operation.
        GeneratedPluginRegistrant.register(with: registry)
    }
    // Register a background task
    // WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "task-identifier")

    // Register a periodic task in iOS 13+
    WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "database-sync", frequency: NSNumber(value: 6 * 60 * 60)) // period is 6 hours
    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(15*60))

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
