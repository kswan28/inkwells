import SwiftUI
import SwiftData
import UserNotifications

@Model
final class Reminder {
    var daysOfWeek: [Int]?
    var hour: Int?
    var minute: Int?
    var isAM: Bool?
    var notificationStatus: String?
    var notificationScheduled: Bool?
    var notificationID: String?
    
    init(daysOfWeek: [Int] = [],
         hour: Int = 9,
         minute: Int = 0,
         isAM: Bool = true,
         notificationStatus: String = "",
         notificationScheduled: Bool = false,
         notificationID: String = "") {
        self.daysOfWeek = daysOfWeek
        self.hour = hour
        self.minute = minute
        self.isAM = isAM
        self.notificationStatus = notificationStatus
        self.notificationScheduled = notificationScheduled
        self.notificationID = notificationID
    }
}

struct RemindersView: View {
    @Environment (\.colorScheme) var colorScheme
    @Environment (\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var modelContext
    @Query private var reminders: [Reminder]
    @State private var refreshTrigger = false
    
    @State private var selectedDays: [Int] = []
    @State private var selectedHour = 9
    @State private var selectedMinute = 0
    @State private var isAM = true
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var notificationEnabled = false
    @State private var refreshData = UUID()
    
    @State private var selectedAMPM = "AM"
    let ampmOptions = ["AM", "PM"]
    
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let hours = Array(1...12)
    let minutes = Array(0...59)
    
    var body: some View {
        withAnimation {
            ZStack {
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundColor(.allwhite)
                
                VStack(alignment: .leading, spacing: 0) {

//Removed the Settings menu since it's now part of a navigation stack for preferences
//                    HStack {
//                        SettingsMenu()
//                        Spacer()
//                    }
//                    .padding(.top, 20)
                    
                    HStack{
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.gray)
                                .opacity(0.4)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Text("Inkwell reminders")
                        .font(.screenHeading)
                        .foregroundStyle(.darkNavy)
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                    
                    if !notificationEnabled {
                                      notificationDisabledWarning()
                                  }
                    
                    if let reminder = reminders.first, reminder.notificationScheduled ?? false {
                        reminderStatusView(reminder: reminder)
                            .padding()
                    } else {
                        reminderSetupView()
                    }
                    
                    Spacer()
                }
                .padding()
               
//Removed floating entry button so it follows that pattern that pages inside a navigation stack don't have it
//                if reminders.first?.notificationScheduled == true {
//                    FloatingEntryButton()
//                }
            }
            .onAppear {
                requestNotificationPermission()
            }
            .onChange(of: notificationEnabled) { _, _ in
                Task {
                    await updateNotificationStatus()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                refreshData = UUID()
                Task {
                    await updateNotificationStatus()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NewEntryAdded"))) { _ in
                refreshTrigger.toggle()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    primaryButton: .default(Text("OK"), action: {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }),
                    secondaryButton: .cancel()
                )
            }
        }
    }
        
    func reminderStatusView(reminder: Reminder) -> some View {
              VStack(alignment: .leading) {
                  
                  HStack {
                      Text(reminder.notificationStatus ?? "")
                          .font(.featuredText)
                          .foregroundStyle(.darkNavy)
                      
                      Spacer()
                      Spacer()
                      Button(action: {
                          deleteAllNotifications()
                          //deleteReminder(reminder)
                      }, label: {
                          ZStack {
                              RoundedRectangle(cornerRadius: 15)
                                  .frame(width: 72, height: 48)
                                  .foregroundColor(.gray)
                                  .opacity(0.4)
                              Text("Delete")
                                  .foregroundColor(.darkNavy)
                                  .font(.smallHeading)
                          }
                      })
                  }
              }
              .padding(.horizontal, 20)
              .padding(.top, 20)
              .padding(.bottom, 20)
              .background(
                  RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.darkNavy, lineWidth: 6)
                      .fill(.lavender))
          
      }
          
          private func deleteReminder(_ reminder: Reminder) {
              UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.notificationID ?? ""])
              modelContext.delete(reminder)
              do {
                  try modelContext.save()
              } catch {
                  print("Failed to delete reminder: \(error)")
              }
          }
    
    @ViewBuilder
    func reminderSetupView() -> some View {
        VStack {
            Text("Schedule your reminders")
                .font(.screenInstruct)
                .foregroundStyle(.darkNavy)
            
            
            HStack {
                ForEach(0..<days.count, id: \.self) { index in
                    Button(action: {
                        if selectedDays.contains(index) {
                            selectedDays.removeAll { $0 == index }
                        } else {
                            selectedDays.append(index)
                        }
                    }) {
                        Text(days[index])
                            .font(.dateHeader)
                            .foregroundStyle(.darkNavy)
                            .padding(.horizontal, 8)
                            .padding(.top, 8)
                            .padding(.bottom, 8)
                            .background(selectedDays.contains(index) ? Color.lavender : Color.gray)
                            .cornerRadius(4)
                    }
                }
            }
            .padding(.bottom, 24)
            
            HStack {
                Picker("Hour", selection: $selectedHour) {
                    ForEach(hours, id: \.self) { hour in
                        Text("\(hour)")
                            .tag(hour)
                            .font(.smallHeading)
                            .foregroundColor(.darkNavy)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 48)
                
                Picker("Minute", selection: $selectedMinute) {
                    ForEach(minutes, id: \.self) { minute in
                        Text(String(format: "%02d", minute))
                            .tag(minute)
                            .font(.smallHeading)
                            .foregroundColor(.darkNavy)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 48)
                
                HStack {
                                            ForEach(ampmOptions, id: \.self) { option in
                                                Button(action: {
                                                    selectedAMPM = option
                                                    isAM = (option == "AM")
                                                }) {
                                                    Text(option)
                                                        .font(.dateHeader)
                                                        .foregroundStyle(.darkNavy)
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 4)
                                                        .background(selectedAMPM == option ? Color.lavender : Color.gray)
                                                        .cornerRadius(4)
                                                }
                                            }
                                        }
                                        .frame(width: 100)
                
//                Picker("AM/PM", selection: $isAM) {
//                    Text("AM").tag(true)
//                        .font(.smallHeading)
//                        .foregroundColor(colorScheme == .dark ? .darkNavy : .darkNavy)
//                    Text("PM").tag(false)
//                        .font(.smallHeading)
//                        .foregroundColor(colorScheme == .dark ? .darkNavy : .darkNavy)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .frame(width: 100)
            }
            .padding(.bottom, 24)
            
            Button(action: {
                scheduleNotification()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 60)
                        .foregroundColor(.darkAccent)
                    Text("Set your reminders")
                        .foregroundColor(.allwhite)
                        .font(.screenInstruct)
                }
                .padding()
            })
            
            Spacer()
        }
        .padding()
        .padding(.top, 24)
    }
    
    @ViewBuilder
    func notificationDisabledWarning() -> some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Image(systemName: "exclamationmark.bubble")
                    .foregroundColor(colorScheme == .dark ? .white : .red) // Adjust color based on dark mode
                    .font(.system(size: 24))
                Button(action: {
                    showAlert = true
                    alertTitle = "Notifications disabled"
                    alertMessage = "Please enable notifications in App Settings to receive reminders."
                }) {
                    Text("Notifications for this app are disabled. \n To receive reminders, tap here.")
                        .foregroundColor(colorScheme == .dark ? .white : .red) // Adjust color based on dark mode
                        .font(.smallHeading)
                }
            }
            .padding()
            .padding(.leading, 12)
            Spacer()
        }
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Request authorization failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    showAlert = true
                    alertTitle = "Notification Permission Error"
                    alertMessage = error.localizedDescription
                }
            } else {
                DispatchQueue.main.async {
                    Task {
                        await updateNotificationStatus()
                    }
                }
            }
        }
    }
    
    @MainActor
    func updateNotificationStatus() async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        notificationEnabled = settings.authorizationStatus == .authorized
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "It's time to Inkwell!"
        content.body = ""
        
        // Set the sound to the milestone sound
            content.sound = UNNotificationSound(named: UNNotificationSoundName("milestone.wav"))
        
//        let textInputAction = UNTextInputNotificationAction(
//            identifier: "TEXT_INPUT_ACTION",
//            title: "Enter your achievement",
//            options: [],
//            textInputButtonTitle: "Save",
//            textInputPlaceholder: "Today I..."
//        )
//        
//        let category = UNNotificationCategory(
//            identifier: "REMINDER_CATEGORY",
//            actions: [textInputAction],
//            intentIdentifiers: [],
//            options: []
//        )
//        
//        UNUserNotificationCenter.current().setNotificationCategories([category])
//        content.categoryIdentifier = "REMINDER_CATEGORY"
        
        for day in selectedDays {
            var dateComponents = DateComponents()
            dateComponents.hour = (isAM ? selectedHour : selectedHour + 12) % 24
            dateComponents.minute = selectedMinute
            dateComponents.weekday = day + 1 // Sunday is 1, Monday is 2, etc.
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Failed to add notification request: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.alertTitle = "Failed to Schedule Notification"
                        self.alertMessage = error.localizedDescription
                    }
                } else {
                    DispatchQueue.main.async {
                        let daysList = self.selectedDays.map { self.days[$0] }
                        let daysString = formatDaysList(daysList)
                        let reminder = Reminder(
                            daysOfWeek: self.selectedDays,
                            hour: self.selectedHour,
                            minute: self.selectedMinute,
                            isAM: self.isAM,
                            notificationStatus: "You have a reminder scheduled on \(daysString) at \(self.selectedHour):\(String(format: "%02d", self.selectedMinute)) \(self.isAM ? "AM" : "PM").",
                            notificationScheduled: true,
                            notificationID: request.identifier
                        )
                        self.modelContext.insert(reminder)
                    }
                }
            }
        }
        
        print("Notification scheduled for \(selectedDays.map { days[$0] }.joined(separator: ", ")) at \(selectedHour):\(String(format: "%02d", selectedMinute)) \(isAM ? "AM" : "PM")")
    }
    
    func formatDaysList(_ days: [String]) -> String {
        switch days.count {
        case 0:
            return ""
        case 1:
            return days[0]
        case 2:
            return "\(days[0]) and \(days[1])"
        default:
            let allButLast = days.dropLast().joined(separator: ", ")
            return "\(allButLast), and \(days.last!)"
        }
    }
    
    func deleteAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        for reminder in reminders {
            modelContext.delete(reminder)
        }
        
        print("All notifications deleted")
    }
    
}
