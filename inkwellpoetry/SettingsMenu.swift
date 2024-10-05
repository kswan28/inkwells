//
//  SettingsMenu.swift
//  somethingGreat
//
//  Created by Kristen Swanson on 5/27/24.
//

import SwiftUI
import StoreKit
import SwiftData

struct SettingsMenu: View {
    
    @Environment(\.colorScheme) private var colorScheme

    
    @Environment(\.openURL) var openURL
    @State var askForAttachment = false
    @State var showFeedbackEmail = false
    @State var showSupportEmail = false
    @State private var emailFeedback = SupportEmail(toAddress: "tinyappsfeedback@gmail.com",
                                                    subject: "Inkwells Feedback -- Case:\(UUID())",
                                     messageHeader: "Thanks for spending time with this tiny app. How can we make it better?")
    @State private var emailSupport = SupportEmail(toAddress: "tinyappsfeedback@gmail.com",
                                     subject: "Inkwells Support Ticket -- Case:\(UUID())",
                                     messageHeader: "We're sorry you're having a problem. Tell us how we can help.")
    
    
    
    @State var showFAQPage = false
    @State var showPrivacyPage = false
    @State var showWhatsNewPage = false
    @State var showRemindersPage = false
    @State var showOnboarding = false
    @AppStorage("showPresentIcon1") private var showPresentIcon1 = true
    @AppStorage("onboarding") var needsOnboarding = false
    
    @Environment(\.modelContext) var modelContext
    @Query private var entries: [InkwellEntryModel]
    
    
    
    
    var body: some View {
        
        HStack(spacing: 8){
            Menu {
                
                //First section
                Button (action: {
                    
                    emailFeedback.send(openURL: openURL)
                })
                {Label("Give feedback", systemImage: "envelope")
                }
                
                Button (action: {
                    
                    emailSupport.send(openURL: openURL)
                })
                {Label("Get help", systemImage: "lifepreserver")
                }
                
                //Second section -- Add this section after the app is live in the App Store
                // Divider()
                
                //                Button(action: {
                //                    requestAppReview()
                //                }) {
                //                    Label("Rate the app", systemImage: "star")
                //                }
                //
                //                ShareLink(item: URL(string: "populate with link")!, subject:Text("Inkwells App"), message: Text("Check out the Inkwells Poetry App!"))
                //                {
                //                    Label("Share the app", systemImage: "square.and.arrow.up")
                //                }
                
                Divider()
                
                
                //Third section
                Button(action: {
                    showFAQPage = true
                }) {
                    Label("About this app", systemImage: "doc.questionmark")
                }
                Button(action: {
                    showPrivacyPage = true
                }) {
                    Label("Privacy policy & terms", systemImage: "lock")
                }
                
                
            } label: {
            Image(systemName: "gearshape.fill")
                    .font(.system(size: 18)) // Adjust the size as needed
                    .foregroundColor(colorScheme == .dark ? Color.allwhite : Color.darkNavy)
            }
            .menuStyle(.borderlessButton)
            .tint(.darkNavy)
            .sheet(isPresented: $showFeedbackEmail) {
                MailView(supportEmail: $emailFeedback) { result in
                    switch result {
                    case .success:
                        print("Email sent")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            .sheet(isPresented: $showSupportEmail) {
                MailView(supportEmail: $emailSupport) { result in
                    switch result {
                    case .success:
                        print("Email sent")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            .sheet(isPresented: Binding(
                get: { showFAQPage },
                set: { showFAQPage = $0 }
            ))  {
                TextModalComponent(modalTitle: "About this app", modalHeaderIcon: "doc.questionmark", modalHeading1: "What is the Inkwells app?", modalText1: "Inkwells are daily word puzzles that spark your creativity and make writing easier.", modalHeading2: "Why did you create this app?", modalText2: "Words are magical. By putting words together in unexpected ways, it can bring joy, delight, and a bit of whimsy to your life.", modalHeading3: "What are the different Inkwell styles?", modalText3: "The Inkwell style you choose determines the words you get. A classic style is standard words. A spooky style has words with ghosts, tricks, and treats. A swifty style makes you feel like you're writing songs with a red-lip classic songstress.", modalHeading4: "Who can see what I post?", modalText4: "Unless you choose to share a post, what you create is just for you. This app will store data either locally on your device or in iCloud (if you have iCloud turned on for the app). Your app data is not stored or shared anywhere else.", modalHeading5: "What happens if I delete this app?", modalText5: "If you have iCloud turned on for this app, your Inkwells will be saved even if you delete the app and reinstall it later. However, if you're not using iCloud, all of your data will be deleted when you delete the app. This is by design -- you are fully in control of your Inkwells.", modalHeading6: "Will this app work across all of my devices?", modalText6: "This app does have iCloud sync capabilities. If you turn on iCloud for this app, you'll be able to keep your great things in sync between any iOS devices using the same iCloud account.",modalHeading7: "Notifications aren't working.",modalText7:"Make sure notifications are turned on in your iOS app settings. For further help, contact us at tinyappsfeedback@gmail.com",modalHeading8: "When I try to give feedback or get help, the app asks me to restore the Mail App.",modalText8: "Sorry about that! The Inkwells App requires the Apple Mail client to send messages to the team. If you use another email client, that's no problem. You can drop us a note anytime at tinyappsfeedback@gmail.com.", modalHeading9: "Who made this app?", modalText9: "This app was made by Tiny App Studio, an organization that likes building software for humans. They were inspired to create the app because, well, they had writer's block a lot. This little game made it a bit better. The team sincerely hopes it makes your day a little easier or more expressive.",modalHeading10: "",modalText10: "",modalHeading11: "",modalText11: "")
                    .presentationBackground(.thinMaterial)
            }
            .sheet(isPresented: Binding(
                get: { showPrivacyPage },
                set: { showPrivacyPage = $0 }
            ))  {
                TextModalComponent(modalTitle: "Privacy policy & terms", modalHeaderIcon: "lock",
                                   modalHeading1: "Overview",
                                   modalText1: "Inkwells (the 'Service') is a Freemium app by Kristen Swanson of Tiny App Studio ('We,' 'Our,' or 'Us'). This policy explains how we collect, use, and protect your personal information.\n\nBy using our Service, you agree to the Privacy Policy and associated terms.",
                                   modalHeading2: "Information collection and use",
                                   modalText2: "This app uses services provided by Apple and Telemetry Deck to collect information and improve the app. This helps us understand how our users are using our app and how we can improve it. Personally identifiable information or user-entered data (like your poems) are NOT collected.\n\nLottie Packages is used to deliver animations in the app, but no data is collected by the service. All Lottie Animations are used under the Lottie License. Thank you to the talented animators that shared their art to make this app a little better!\n\nAlso, thank you to sadgrlonline for sharing her magnetic-poetry project on github to make putting together my word lists a bit easier.",
                                   modalHeading3: "Paid user data retention and charge changes",
                                   modalText3: "We and the Apple App Store retain transaction data for paid users to comply with financial and tax regulations. Personal content can be deleted in the app, but transactional data may be retained as required by law.\n\nWe may modify the app or its charges at any time. Users will be notified of any new charges.",
                                   modalHeading4: "App data security",
                                   modalText4: "You are responsible for keeping your device and app secure. Avoid jailbreaking or rooting your device.\n\nYour data is either saved directly on your device or within your iCloud account, depending on your device settings. No method of digital storage is 100% secure.iCloud does not guarantee local data residency if you use the service to back up your app data. The app makers do not have access to your app data at any time, and you can delete your data at any time.\n\nWe cannot guarantee absolute security and are not liable for unauthorized access.",
                                   modalHeading5: "Privacy for users under 13",
                                   modalText5: "This service is not for children under 13. If you believe a child has provided us with app or transactional data, please contact us to remove it at tinyappsfeedback@gmail.com.",
                                   modalHeading6: "App performance, internet connectivity, and compatibility",
                                   modalText6: "App performance may be affected by your internet connection. Data charges may apply based on your service provider.\n\nWe may release updates and cannot guarantee compatibility with all devices. We reserve the right to terminate the app at any time.\n\nWe are not liable for any losses related to app functionality. We rely on Apple for certain information and cannot ensure continuous operation.",
                                   modalHeading7: "Intellectual property constraints",
                                   modalText7: "All intellectual property related to the Inkwells app belongs to Kristen Swanson and Tiny App Studio. You may not copy, modify, or create derivative versions of the app.",
                                   modalHeading8: "Changes to ownership",
                                   modalText8: "If our ownership changes, your information may be transferred. You will be notified of any such changes.",
                                   modalHeading9: "Governing law or jurisdiction",
                                   modalText9: "These terms are governed by USA. Disputes will be resolved in USA courts.",
                                   modalHeading10: "Changes to these terms",
                                   modalText10: "We may update this policy. Changes will be posted on this page. Last updated on September 8, 2024.",
                                   modalHeading11: "Contact us",
                                   modalText11: "For questions, contact us at tinyappsfeedback@gmail.com.")
                .presentationBackground(.thinMaterial)
            }
            
            Button {
                showRemindersPage = true
            } label: {
                Image(systemName: "bell.fill")
                    .font(.system(size: 18)) // Adjust the size as needed
                    .foregroundColor(colorScheme == .dark ? Color.allwhite : Color.darkNavy) // Set the color as needed
                
            }.fullScreenCover(isPresented: $showRemindersPage, content: { RemindersView() })

            //Temporary button to delete entries if you need to update the SwiftData Model
//            Button {
//                
//                deleteAllEntries()
//                
//            } label: {
//                Image(systemName: "xmark")
//                    .font(.system(size: 18))
//                    .foregroundColor(colorScheme == .dark ? Color.allwhite :Color.darkNavy)
//            }
            
            Spacer()
            
            Button{
                showOnboarding = true
            } label: {
                Text("How to play")
                    .font(.screenInstruct)
                    .foregroundColor(colorScheme == .dark ? Color.allwhite : Color.darkNavy)
            }.fullScreenCover(isPresented: $showOnboarding, content: { OnboardingView(needsOnboarding: $needsOnboarding) })
            
        
            
            
            
            //Activate if you want to show What's New Page
            //            if showPresentIcon1 == true {
            //                Image(systemName: "gift.fill")
            //                    .symbolEffect(.pulse)
            //                    .font(.system(size:24))
            //                    .foregroundColor(.standardIcon)
            //                    .onTapGesture {
            //                        showWhatsNewPage = true
            //                        showPresentIcon1 = false
            //                    }
            //            }
            
        }
        //Activate if you want to show What's New Page
        //        .sheet(isPresented: $showWhatsNewPage, content: {
        //            WhatsNewPhoto()
        //        })
        
        
        

    }
    
    private func requestAppReview() {
           if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
               SKStoreReviewController.requestReview(in: scene)
           }
       }
    
//    private func deleteAllEntries() {
//        for entry in entries {
//            modelContext.delete(entry)
//        }
//        try? modelContext.save() // Ensure changes are saved after deletion
//    }
        
    }

#Preview {
    SettingsMenu()
}
