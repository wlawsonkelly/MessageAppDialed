//
//  RecipientTextField.swift
//  MessageApp
//
//  Created by Lawson Kelly  on 12/6/21.
//

import SwiftUI
import UIKit
import SwiftUIX

struct RecipientTextField: UIViewRepresentable {
    
    typealias UIViewType = UISearchBar
    
    @Binding var text: String
    @Binding var searchTokens: [UISearchToken]
        
    var onCommit: () -> Void
                
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.allowsDeletingTokens = true
        searchBar.searchTextField.tokenBackgroundColor = UIColor(named: "dialed.button")
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Add Recipients"
        searchBar.searchTextField.returnKeyType = .done
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 20)
        searchBar.searchTextField.tokenBackgroundColor = .red
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
        uiView.searchTextField.tokens = searchTokens
        context.coordinator.onCommit = onCommit
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, searchTokens: $searchTokens, onCommit: onCommit)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        @Binding var searchTokens: [UISearchToken]
                
        var onCommit: () -> Void
                        
        var lastTextCount: Int = 0
        
        init(text: Binding<String>, searchTokens: Binding<[UISearchToken]>, onCommit: @escaping () -> Void) {
            _text = text
            _searchTokens = searchTokens
            self.onCommit = onCommit
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            onCommit()
            lastTextCount = 2
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            
            if lastTextCount != 1 && searchText.count == 0 {
                searchTokens.removeLast()
            }
            
            lastTextCount = searchText.count
            
            if searchText.count == 9 {
                // check for number
            }
        }
    }
}

