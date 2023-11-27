//
//  Settings.swift
//  TMon 4
//
//  Created by Louis Flores on 11/20/23.
//

import SwiftUI

struct Settings: View 
{
	@EnvironmentObject var viewModel: AuthView
    var body: some View
	{
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
		}
    }
}

#Preview {
    Settings()
}
