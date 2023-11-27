//
//  BusinessSignIn.swift
//  TMon 4
//
//  Created by Louis Flores on 11/20/23.
//
import SwiftUI
import Supabase

struct BusinessSignIn: View 
{
	@State private var email = ""
	@State private var password = ""
	@EnvironmentObject var viewModel: AuthView
	
	var body: some View 
	{
		NavigationStack
		{
			VStack
			{
				Image("TMLogo")
					.resizable()
					.scaledToFill()
					.frame(width: 200, height: 220)
					.padding(.vertical, 20)
				
				VStack(spacing: 24) {
					Input(text: $email, title: "Email Address", placeholder: "Enter Email")
						.autocapitalization(.none)
					
					Input(text: $password, title: "Password", placeholder: "Enter Password", isSecureField: true)
						.padding(.bottom, 24)
				}
				.padding(.horizontal)
				.padding(.top, 12)
				
				Button {
					Task {
						do {
							// Assuming you have a SupabaseAuth class handling authentication
							try await viewModel.signIn(withEmail: email, password: password)
						} catch {
							// Handle error
							print("Error signing in: \(error)")
						}
					}
				} label: {
					HStack {
						Text("Sign In")
							.fontWeight(.semibold)
						Image(systemName: "arrow.right")
					}
					.foregroundColor(.white)
					.frame(width: UIScreen.main.bounds.width - 32, height: 48)
				}
				.background(Color(.systemBlue))
				.disabled(!formIsValid)
				.opacity(formIsValid ? 1.0 : 0.5)
				.cornerRadius(10)
				
				Spacer()
				
				HStack {
					Text("Don't have an account?")
					
					NavigationLink(destination: SignUp()) {
						Text("Sign up")
							.fontWeight(.bold)
					}
				}
				.font(.system(size: 14))
			}
		}
	}
}

extension BusinessSignIn: AuthenticateFormProtocol
{
	var formIsValid: Bool 
	{
		return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count > 6
	}
}

struct BusinessSignIn_Previews: PreviewProvider
{
	static var previews: some View 
	{
		SignIn()
	}
}
