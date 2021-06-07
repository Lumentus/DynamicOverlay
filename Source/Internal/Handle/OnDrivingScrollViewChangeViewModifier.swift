//
//  OnDrivingScrollViewChangeViewModifier.swift
//  DynamicOverlayTests
//
//  Created by Gaétan Zanella on 16/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import SwiftUI

private struct OnDrivingScrollViewChangeViewModifier: ViewModifier {

    let handler: (DynamicOverlayDrivingScrollViewHandle) -> Void

    func body(content: Content) -> some View {
        content.onPreferenceChange(DynamicOverlayScrollPreferenceKey.self, perform: handler)
    }
}

extension View {

    func onDrivingScrollViewChange(handler: @escaping (DynamicOverlayDrivingScrollViewHandle) -> Void) -> some View {
        modifier(OnDrivingScrollViewChangeViewModifier(handler: handler))
    }
}
