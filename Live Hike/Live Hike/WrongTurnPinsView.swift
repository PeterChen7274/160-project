import SwiftUI
import MapKit

struct WrongTurnPinsView: View {
    let trail: Trail
    
    @State private var pins: [WrongTurnPin] = []
    @State private var showingAddPin = false
    @State private var selectedPin: WrongTurnPin?
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Map {
                ForEach(pins) { pin in
                    Marker("Wrong Turn", coordinate: pin.coordinate)
                        .tint(.orange)
                }
            }
            .mapStyle(.hybrid)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            
            VStack {
                Spacer()
                
                Button {
                    showingAddPin = true
                }
                label: {
                    Label("Mark Wrong Turn", systemImage: "exclamationmark.triangle")
                        .padding()
                        .background(Color(red: 0.259, green: 0.494, blue: 0.486)) // #427E7C
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .navigationTitle("Wrong Turn?")
    
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

#Preview {
    NavigationView {
        WrongTurnPinsView(trail: Trail(
            name: "Sample Trail",
            location: "Sample Location",
            difficulty: "Easy",
            length: "5 miles",
            elevation: "100 ft",
            imageName: "rainier",
            mapImageName: "rainier_map",
            hazards: []
        ))
    }
}
