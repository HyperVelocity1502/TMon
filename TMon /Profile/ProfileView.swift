//
//  ProfileView.swift
//  TMon 4
//
//  Created by Louis Flores on 11/16/23.
//

import SwiftUI

struct ProfileView: View 
{
	@EnvironmentObject var viewModel: AuthView
	
    var body: some View
	{
		if let user = viewModel.currentUser
		{
			List
			{
				Section
				{
					HStack
					{
						Text(user.initials)
							.font(.title)
							.fontWeight(.semibold)
							.foregroundColor(.white)
							.frame(width: 72, height: 72)
							.background(Color(.systemGray3))
							.clipShape(Circle())
						
						
						VStack(alignment: .leading, spacing: 4)
						{
							Text(user.fullname)
								.font(.subheadline)
								.fontWeight(.semibold)
								.padding(.top, 4)
							
							Text(user.email)
								.font(.footnote)
								.accentColor(.gray)
						}
					}
				}
				
				Section("General")
				{
					HStack
					{
						SettingsView(imageName: "gear", title: "Version", tintColor: Color(.systemGray), fontColor: .primary)
						
						Spacer()
						
						Text("1.0.0")
							.font(.subheadline)
							.foregroundColor(.primary)
					}
				}
				
				Section("Account")
				{
					Button
					{
						viewModel.signOut()
						
					}label:
					{
						SettingsView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red, fontColor: .primary)
						
					}
					
					Button
					{
						print("Delete Acocount..")
					}label:
					{
						SettingsView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red, fontColor: .primary)
					}
				}
				
			}
		}
		
    }
}

#Preview {
    ProfileView()
}
