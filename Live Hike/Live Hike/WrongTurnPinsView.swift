import SwiftUI
import MapKit

struct WrongTurnPinsView: View {
    let trail: Trail 
    
    @State private var pins: [WrongTurnPin] = []
    @State private var showingAddPin = false
    @State private var isLoading = false 
    
    var body: some View {
        VStack {
            Text("Navigation Help")
                .font(.headline)
                .padding(.top)
            
            if pins.isEmpty {
                Text("No navigation markers available for this trail")
                    .foregroundColor(.secondary)
                    .padding()
                Spacer()
            } else {
                List(pins) { pin in
                    VStack(alignment: .leading) {
                        Text("Wrong Turn Alert")
                            .font(.headline)
                        Text(pin.description)
                            .padding(.top, 1)
                        Text("Posted: \(pin.createdAt.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Button {
                showingAddPin = true
            } label: {
                Label("Mark Wrong Turn", systemImage: "exclamationmark.triangle")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .onAppear {
            Task {
                await loadWrongTurnPins()
            }
        }
        .sheet(isPresented: $showingAddPin) {
            CreateWrongTurnPinView(trail: trail)
                .onDisappear {
                    Task {
                        await loadWrongTurnPins()
                    }
                }
        }
    }
    
    private func loadWrongTurnPins() async {
        isLoading = true
        pins = PinStorage.shared.loadPinsForTrail(trailId: trail.id.uuidString)
        isLoading = false
    }
}
