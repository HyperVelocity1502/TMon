//
//  SignUp.swift
//  TMon 4
//
//  Created by Louis Flores on 11/15/23.
//

import SwiftUI

struct SignUp: View 
{
	@State private var email = ""
	@State private var password = ""
	@State private var fullname = ""
	@State private var confirmpassword = ""
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var viewModel: AuthView

    var body: some View
	{
		VStack
		{
			Image("TMLogo")
				.resizable()
				.scaledToFill()
				.frame(width: 200, height: 220)
				.padding(.vertical, 20)
			
			VStack(spacing: 24)
			{
				Input(text: $email, title: "Email Address", placeholder: "Enter Email")
					.autocapitalization(.none)
				
				Input(text: $fullname, title: "Full Name", placeholder: "Enter Full Name")
				
				Input(text: $password, title: "Password", placeholder: "Enter Password", isSecureField: true)
					.padding(.bottom, 24)
				
				Input(text: $confirmpassword, title: "Confirm Password", placeholder: "Confirm Password", isSecureField: true)
				
				
			}
			.padding(.horizontal)
			.padding(.top, 12)
			
			Button {
				Task {
					do {
						try await viewModel.createUser(withEmail: email, password: password, fullname: fullname)
					} catch {
						// Handle any errors if necessary
					}
				}
			} label: {
				HStack {
					Text("Sign Up")
						.fontWeight(.semibold)
					Image(systemName: "arrow.right")
				}
				.foregroundColor(.white)
				.frame(width: UIScreen.main.bounds.width - 32, height: 48)
			}
			.background(Color(.systemBlue))
			.cornerRadius(10)
			.padding(.top, 15)
			
			Spacer()
			
			HStack
			{
				Text("Already have an account?")
				
				Button
				{
					dismiss()
				}label:
				{
					Text("Sign In")
						.fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
				}
			}
		}
    }
}

#Preview {
    SignUp()
}
