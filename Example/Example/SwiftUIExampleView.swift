import SwiftUI
import Colorblinds

struct SwiftUIExampleView: View {
    private let colors: [(String, Color)] = [
        ("Red", .red),
        ("Green", .green),
        ("Blue", .blue),
        ("Yellow", .yellow),
        ("Orange", .orange),
        ("Purple", .purple),
        ("Pink", .pink),
        ("Mint", .mint),
        ("Teal", .teal),
        ("Cyan", .cyan),
        ("Brown", .brown),
        ("Indigo", .indigo),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Triple-tap to open the color blindness picker")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                    ], spacing: 12) {
                        ForEach(colors, id: \.0) { name, color in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(color)
                                .frame(height: 80)
                                .overlay {
                                    Text(name)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                        .shadow(radius: 2)
                                }
                        }
                    }
                    .padding(.horizontal)

                    LinearGradient(
                        colors: [.red, .orange, .yellow, .green, .blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)

                    HStack(spacing: 0) {
                        ForEach(0..<12) { i in
                            Color(hue: Double(i) / 12, saturation: 0.8, brightness: 0.9)
                        }
                    }
                    .frame(height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .colorBlindSimulator()
            }
            .navigationTitle("SwiftUI")
        }
    }
}

#Preview {
    SwiftUIExampleView()
}
