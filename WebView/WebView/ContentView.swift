//
//  ContentView.swift
//  WebView
//
//  Created by Ömer Köse on 23.09.2021.
//

import SwiftUI
import WebKit

// Structs that will be used in the web browser
struct WebView: UIViewRepresentable {
    let request: URLRequest
    private var webView: WKWebView?
    
    init (request: URLRequest) {
        self.webView = WKWebView()
        self.request = request
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return webView!
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context){
        uiView.load(request)
    }
    
    // Go to the previous page that was searched
    func goBack() {
        webView?.goBack()
    }
    
    // Go to the next page that was searched
    func goForward() {
        webView?.goForward()
    }
    
    // Refresh to the home page
    func refresh() {
        webView?.reload()
    }
    
    // Go Home
    func goHome() {
        webView?.load(request)
    }
}

struct ContentView: View {
    // Initial page that will be displayed on opening the program
    let webView = WebView(request: URLRequest(url: URL(string: "https://www.google.com.tr/")!))
    
    // Display
    var body: some View {
        VStack {
            // Display the web view to the user
            webView
            
            // The toolbar that displays the navigation buttons
            HStack {
                // Previous page button, this function will direct user to the
                // previous page that was searched
                Button(action: {
                    self.webView.goBack()
                }, label: {
                    Image("arrowshape.turn.up.backward")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                })
                Spacer()
                
                // Next page button, this function will direct user to the
                // next page that was searched
                Button(action: {
                    self.webView.goForward()
                }, label: {
                    Image("arrowshape.turn.up.right")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                })
                Spacer()
                
                // Home button, this function will direct user to the URL
                // address that is defined above
                Button(action: {
                    self.webView.goHome()
                }, label: {
                    Image("house")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                })
                Spacer()
                
                // Refresh page button, this function will refresh the page
                // that user is currently using
                Button(action: {
                    self.webView.refresh()
                }, label: {
                    Image("arrow.clockwise")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
