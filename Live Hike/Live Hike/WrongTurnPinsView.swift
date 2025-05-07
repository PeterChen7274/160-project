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
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            
            VStack {
                Spacer()
                
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
        }
        .navigationTitle("Navigation Help")
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

