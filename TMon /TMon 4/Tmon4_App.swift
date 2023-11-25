//
//  Tmon4_App.swift
//  TMon 4
//
//  Created by Louis Flores on 11/13/23.
//

import SwiftUI
import Firebase

@main
struct Tmon: App
{

	init()
	{
		FirebaseApp.configure()
	}
	
	var body: some Scene
	{
		WindowGroup 
		{
			ContentView()
				.environmentObject(AuthView())
				.environmentObject(DatabaseManager())

		}
	}
}
