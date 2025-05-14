import SwiftUI

struct HikeView: View {
    let trail: Trail
    @ObservedObject var trailStore: TrailStore
    @EnvironmentObject var historyStore: HikeHistoryStore
    @State private var elapsedTime: TimeInterval = 0
    @State private var isTimerRunning = false
    @State private var timer: Timer?
    @State private var showingHazardReport = false
    @State private var newHazardType = ""
    @State private var newHazardSeverity = "Medium"
    @State private var newHazardDescription = ""
    @Environment(\.dismiss) private var dismiss
    
    let severityOptions = ["Low", "Medium", "High"]
    
    var body: some View {
        VStack(spacing: 20) {
            // Trail Title
            Text(trail.name)
                .font(.largeTitle)
                .bold()
                .padding()
            
            // Timer Display
            Text(timeString(from: elapsedTime))
                .font(.system(size: 60, weight: .bold, design: .monospaced))
                .padding()
            
            // Timer Controls
            HStack(spacing: 20) {
                Button(action: {
                    if isTimerRunning {
                        pauseTimer()
                    } else {
                        startTimer()
                    }
                }) {
                    Image(systemName: isTimerRunning ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                Button(action: endHike) {
                    Image(systemName: "stop.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                }
            }
            
            // Action Buttons
            VStack(spacing: 15) {
                // Report Hazard Button
                Button(action: { showingHazardReport = true }) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("Report Hazard")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                // Wildlife Scanner Button
                NavigationLink(destination: WildlifeScannerView()) {
                    HStack {
                        Image(systemName: "camera.viewfinder")
                        Text("Wildlife Scanner")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .accessibilityLabel("Wildlife Scanner")
                .accessibilityHint("Double tap to scan and identify wildlife")
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showingHazardReport) {
            NavigationView {
                Form {
                    Section(header: Text("Hazard Details")) {
                        TextField("Hazard Type", text: $newHazardType)
                        Picker("Severity", selection: $newHazardSeverity) {
                            ForEach(severityOptions, id: \.self) { severity in
                                Text(severity)
                            }
                        }
                        TextEditor(text: $newHazardDescription)
                            .frame(height: 100)
                    }
                }
                .navigationTitle("Report Hazard")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingHazardReport = false
                    },
                    trailing: Button("Submit") {
                        submitHazard()
                        showingHazardReport = false
                    }
                )
            }
        }
    }
    
    private func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
        }
    }
    
    private func pauseTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func endHike() {
        pauseTimer()
        
        // Create and save the completed hike
        let completedHike = CompletedHike(
            trailName: trail.name,
            duration: elapsedTime,
            date: Date(),
            distance: trail.length,
            elevation: trail.elevation
        )
        
        historyStore.addHike(completedHike)
        dismiss() // Return to previous view
    }
    
    private func submitHazard() {
        let newHazard = Hazard(
            type: newHazardType,
            severity: newHazardSeverity,
            description: newHazardDescription,
            reportedDate: Date().formatted(date: .abbreviated, time: .shortened),
            status: "Active",
            trailName: trail.name
        )
        
        trailStore.addHazard(newHazard, to: trail.name)
        
        // Reset the form
        newHazardType = ""
        newHazardSeverity = "Medium"
        newHazardDescription = ""
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
} 