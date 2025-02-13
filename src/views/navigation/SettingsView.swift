//
//  SettingsView.swift
//  Helium UI
//
//  Created by lemin on 10/19/23.
//

import Foundation
import SwiftUI

let buildNumber: Int = 0
let DEBUG_MODE_ENABLED = false

// MARK: Settings View
// TODO: This
struct SettingsView: View {
    // Debug Variables
    @State var sideWidgetSize: Int = 100
    @State var centerWidgetSize: Int = 100
    
    // Preference Variables
    @State var updateInterval: Double = 1.0
    
    var body: some View {
        NavigationView {
            List {
                // App Version/Build Number
                Section {
                    
                } header: {
                    Label("Version \(Bundle.main.releaseVersionNumber ?? "UNKNOWN") (\(buildNumber != 0 ? "\(buildNumber)" : "Release"))", systemImage: "info")
                }
                
                // Preferences List
                Section {
                    HStack {
                        Text("Update Interval (seconds)")
                            .bold()
                        Spacer()
                        TextField("Seconds", value: $updateInterval, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .submitLabel(.done)
                            .onSubmit {
                                if updateInterval <= 0 {
                                    updateInterval = 1
                                }
                                UserDefaults.standard.setValue(updateInterval, forKey: "updateInterval")
                            }
                            .onAppear {
                                updateInterval = UserDefaults.standard.double(forKey: "updateInterval")
                                if updateInterval <= 0 {
                                    updateInterval = 1
                                }
                            }
                    }
                } header: {
                    Label("Preferences", systemImage: "gear")
                }
                
                // Debug Settings
                if DEBUG_MODE_ENABLED {
                    Section {
                        HStack {
                            Text("Side Widget Size")
                                .bold()
                            Spacer()
                            TextField("Side Size", value: $sideWidgetSize, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .submitLabel(.done)
                                .onSubmit {
                                    UserDefaults.standard.setValue(sideWidgetSize, forKey: "DEBUG_sideWidgetSize")
                                }
                                .onAppear {
                                    sideWidgetSize = UserDefaults.standard.integer(forKey: "DEBUG_sideWidgetSize")
                                }
                        }
                        
                        HStack {
                            Text("Center Widget Size")
                                .bold()
                            Spacer()
                            TextField("Center Size", value: $centerWidgetSize, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .submitLabel(.done)
                                .onSubmit {
                                    UserDefaults.standard.setValue(centerWidgetSize, forKey: "DEBUG_centerWidgetSize")
                                }
                                .onAppear {
                                    centerWidgetSize = UserDefaults.standard.integer(forKey: "DEBUG_centerWidgetSize")
                                }
                        }
                    } header: {
                        Label("Debug Preferences", systemImage: "ladybug")
                    }
                }
                
                // Credits List
                Section {
                    LinkCell(imageName: "leminlimez", url: "https://github.com/leminlimez", title: "LeminLimez", contribution: NSLocalizedString("Main Developer", comment: "leminlimez's contribution"), circle: true)
                    LinkCell(imageName: "lessica", url: "https://github.com/Lessica/TrollSpeed", title: "Lessica", contribution: NSLocalizedString("TrollSpeed & Assistive Touch Logic", comment: "lessica's contribution"), circle: true)
                } header: {
                    Label("Credits", systemImage: "wrench.and.screwdriver")
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    // Link Cell code from Cowabunga
    struct LinkCell: View {
        var imageName: String
        var url: String
        var title: String
        var contribution: String
        var systemImage: Bool = false
        var circle: Bool = false
        
        var body: some View {
            HStack(alignment: .center) {
                Group {
                    if systemImage {
                        Image(systemName: imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        if imageName != "" {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
                .cornerRadius(circle ? .infinity : 0)
                .frame(width: 24, height: 24)
                
                VStack {
                    HStack {
                        Button(action: {
                            if url != "" {
                                UIApplication.shared.open(URL(string: url)!)
                            }
                        }) {
                            Text(title)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal, 6)
                        Spacer()
                    }
                    HStack {
                        Text(contribution)
                            .padding(.horizontal, 6)
                            .font(.footnote)
                        Spacer()
                    }
                }
            }
            .foregroundColor(.blue)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
