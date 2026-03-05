import SwiftUI

struct ColorBlindSimulatorModifier: ViewModifier {
    @State private var selectedType: ColorBlindType?
    @State private var showingPicker = false

    func body(content: Content) -> some View {
        content
            .colorBlindSimulation(selectedType)
            .onTapGesture(count: 3) {
                showingPicker = true
            }
            .sheet(isPresented: $showingPicker) {
                ColorBlindPickerSheet(selectedType: $selectedType)
            }
    }
}

private struct ColorBlindPickerSheet: View {
    @Binding var selectedType: ColorBlindType?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Button {
                    selectedType = nil
                    dismiss()
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Normal Vision")
                                .font(.headline)
                            Text("No color blindness simulation")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        if selectedType == nil {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                        }
                    }
                }
                .tint(.primary)

                ForEach(ColorBlindType.allCases) { type in
                    Button {
                        selectedType = type
                        dismiss()
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(type.displayName)
                                    .font(.headline)
                                Text(type.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            if selectedType == type {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.tint)
                            }
                        }
                    }
                    .tint(.primary)
                }
            }
            .navigationTitle("Color Blind Simulator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

extension View {
    /// Adds a color blindness simulator to the view. Triple-tap to open a picker sheet
    /// that lets you select different types of color blindness simulation.
    public func colorBlindSimulator() -> some View {
        modifier(ColorBlindSimulatorModifier())
    }
}
