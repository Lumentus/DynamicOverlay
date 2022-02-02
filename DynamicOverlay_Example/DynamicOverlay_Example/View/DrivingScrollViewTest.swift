//
//  DrivingScrollViewTest.swift
//  DynamicOverlay_Example
//
//  Created by Lukas Hansen on 20.01.22.
//  Copyright © 2022 Fabernovel. All rights reserved.
//

import DynamicOverlay
import SwiftUI

extension DrivingScrollViewTest {
    enum Notch: CaseIterable, Equatable {
        case min
        case max
    }
}

struct DrivingScrollViewTest: View {
    @State var notch: Notch = .min
    @State var hidden = true

    @ObservedObject var viewModel: ViewModel

    init() {
        viewModel = ViewModel()
    }

    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                map.overlay {
                    NavigationLink(destination: ZStack {
                        Color.red
                        Text("Something")
                    },
                    isActive: $viewModel.linkActive) {
                        EmptyView()
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }.onAppear {
            viewModel.viewInitialized = true
        }
    }

    @ViewBuilder
    var map: some View {
        if !viewModel.linkActive && viewModel.viewInitialized {
            ZStack {
                Color.red // map
                    .ignoresSafeArea()
                    .navigationTitle("Test")
                    .navigationBarHidden(hidden)
                    .dynamicOverlay(overlayView)
                    .dynamicOverlayBehavior(behavior)
                    .ignoresSafeArea(.all, edges: .bottom)
            }.onAppear {
                print("test content appeared")
            }
        } else {
            Color.blue
                .onAppear {
                    print("test placeholder visible")
                }
        }
    }

    private var behavior: some DynamicOverlayBehavior {
        MagneticNotchOverlayBehavior<Notch> { notch in
            switch notch {
            case .min:
                return .fractional(0.3)
            case .max:
                return .fractional(0.9)
            }
        }.notchChange($notch)
    }

    var overlayView: some View {
        VStack {
            header
            content
        }
        .background(Color.white)
        .foregroundColor(Color.black)
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    var content: some View {
        VStack {
            list2
                .accessibilityIdentifier("List2")
                .drivingScrollView()
            list1
        }
    }

    var header: some View {
        HStack {
            Text("An header.")
                .font(.largeTitle.bold())
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }

    var list1: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<100) { index in
                    Text("Some text: \(index)")
                }
            }
        }
    }

    var list2: some View {
        ScrollView {
            VStack {
                ForEach(0..<100) { index in
                    Text("Another type of text: \(index)")
                }
            }
        }
        .background(Color.red)
        .foregroundColor(Color.blue)
    }
}

extension DrivingScrollViewTest {
    class ViewModel: ObservableObject {
        @Published var viewInitialized = false
        @Published private var active = true

        var linkActive: Bool {
            get { viewInitialized && active }
            set {
                active = newValue
            }
        }

        init() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.linkActive = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DrivingScrollViewTest()
    }
}
