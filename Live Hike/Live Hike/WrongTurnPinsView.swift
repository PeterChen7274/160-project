import SwiftUI
import MapKit

struct WrongTurnPinsView: View {
    @State private var pins: [WrongTurnPin] = []
    @State private var showingAddPin = false
    @State private var selectedPin: WrongTurnPin?
    
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
            pins = PinStorage.shared.loadPins()
        }
        .sheet(isPresented: $showingAddPin) {
            CreateWrongTurnPinView()
                .onDisappear {
                    
                    pins = PinStorage.shared.loadPins()
                }
        }
    }
}
