//
//  CustomerListScreen.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/14/25.
//
import SwiftUI


struct ClientListScreen: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var navigation = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigation) {
            GeometryReader { geometry in
                ZStack {
                    Color.clippnotesDarkBlue
                        .ignoresSafeArea()
                    
                    VStack(spacing: 15) {
                        Text("ClippNotes")
                            .font(Font.custom("anta-regular", size: 16))
                            .foregroundStyle(Color.clippnotesYellow)
                        
                        HStack {
                            Text("Clients")
                                .font(Font.custom("anta-regular", size: 25))
                                .foregroundStyle(Color.clippnotesYellow)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.clippnotesLightBlue)
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                .padding(.horizontal)
                            
                            ScrollView {
                                LazyVStack(alignment: .leading, spacing: 10) {
                                    ForEach(viewModel.customers, id: \.id) { customer in
                                        Text(customer.name)
                                            .foregroundStyle(Color.white)
                                            .onTapGesture {
                                                navigation.append("go")
                                                viewModel.selectedCustomer = customer
                                                Task {
                                                    await viewModel.getCustomerHaircuts()
                                                    try await viewModel.fetchImageURLs()
                                                }
                                            }
                                        
                                        Rectangle()
                                            .fill(Color.white.opacity(0.3))
                                            .frame(height: 1)
                                    }
                                }
                                .padding()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationDestination(for: String.self) { _ in
                ProfileScreen()
            }
        }
    }
}

#Preview {
    ClientListScreen()
}
