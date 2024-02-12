//
//  URLRequestDebugView.swift
//  
//
//  Created by Apple on 20/08/2023.
//

import Foundation
import SwiftUI
import Core
import CoreUI
import Network

public struct URLRequestDebugModule: ViewModuling {
    public static var preview: ModuleInput { .init(request: .constant(.init(url: .init(string: "https://www.google.com")!)), isEditingEnabled: .constant(true)) }
    
    public typealias ViewType = URLRequestDebugView
    public struct ModuleInput: ModulingInput {
        var request: Binding<URLRequest>
        var isEditingEnabled: Binding<Bool>
    }
    private let input: ModuleInput
    public init(input: ModuleInput) {
        self.input = input
    }
    public func view() -> URLRequestDebugView {
        @Skin(.request) var requestSkin: URLRequestDebugView.Skin
        return URLRequestDebugView(
            viewModel: .init(
                urlRequest: input.request,
                isEditingEnabled: input.isEditingEnabled
            ),
            skin: requestSkin
        )
    }
}

extension URLRequestDebugView {
    public struct Skin: Skinning {
        public static var `default`: URLRequestDebugView.Skin { .init() }
    }

}
public struct URLRequestDebugView: ViewProtocol, View {
    public typealias ViewModelType = URLRequestDebugViewModel
    public typealias SkinType = Skin
    
    @ObservedObject var viewModel: URLRequestDebugViewModel
    @State var skin: Skin
    public init(viewModel: URLRequestDebugViewModel, skin: Skin) {
        self.viewModel = viewModel
        self.skin = skin
    }
    public var body: some View {
        VStack {
            EditableInformation(title: "URL", info: viewModel.urlBinding(), isEditingEnabled: $viewModel.isEditingEnabled)
            EditableInformation(title: "HTTP Method", info: viewModel.methodBinding(), isEditingEnabled: $viewModel.isEditingEnabled)
        }
    }
}
public class URLRequestDebugViewModel: ViewModeling {
    @Binding var request: URLRequest
    @Binding var isEditingEnabled: Bool
    init(urlRequest: Binding<URLRequest>, isEditingEnabled: Binding<Bool>) {
        _request = urlRequest
        _isEditingEnabled = isEditingEnabled
    }
    func urlBinding() -> Binding<String> {
        .init {
            self.request.url?.absoluteString ?? ""
        } set: { newURL in
            if let urlString = self.request.url?.absoluteString, urlString != newURL {
                self.request.url = .init(string: newURL)
            }
        }
    }
    func methodBinding() -> Binding<String> {
        .init {
            self.request.httpMethod ?? ""
        } set: { newMethod in
            if self.request.httpMethod != newMethod {
                self.request.httpMethod = newMethod
            }
        }
    }
}

public struct EditableInformation: View {
    var title: String
    @Binding var info: String
    @Binding var isEditingEnabled: Bool
    init(title: String, info: Binding<String>, isEditingEnabled: Binding<Bool>) {
        self.title = title
        _info = info
        _isEditingEnabled = isEditingEnabled
    }
    public var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title.bold())
                Spacer()
                if isEditingEnabled {
                    TextField("Enter Info", text: $info)
                        .multilineTextAlignment(.trailing)
                        .font(.title)
                }else {
                    Text(info)
                        .font(.title)
                }
            }
            .frame(height: 50)
            .padding(.horizontal)
        }
    }
}
