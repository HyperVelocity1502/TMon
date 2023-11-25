//
//  ContentView.swift
//  TMon 4
//
//  Created by Louis Flores on 10/23/23.
//

import SwiftUI

struct ContentView: View
{
	@EnvironmentObject var viewModel: AuthView
	let setting1 = Image("Icon_Cat")
	var body: some View
	{
		NavigationStack
		{
			VStack
			{
				TabView
				{
					
					EventsCalendarView()
						.tabItem
					{
						Label("Calendar", systemImage: "calendar")
							.padding()
					}
					
					
					//Settings()
					//	.tabItem
					//{
						//Label("Settings", systemImage: "gear")
						//	.padding()
					//}
					
					ListView()
						.tabItem
						{
							Label("List", systemImage: "list.bullet.indent")
								.padding()
						}
					
					Group
					{
						if let user = viewModel.currentUser
						{
							ProfileView()
						}
						else
						{
							SignIn()
						}
					}.tabItem 
					{
						Label("Profile", systemImage: "person.crop.circle")
					}
					
					
				}
					 
			}
			
		}
		
	}
	
}
	



#Preview
{
	ContentView()
}
