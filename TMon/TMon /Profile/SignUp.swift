//
//  SignUp.swift
//  TMon 4
//
//  Created by Louis Flores on 11/15/23.
//

import SwiftUI

struct SignUp: View {
	@State private var email = ""
	@State private var password = ""
	@State private var fullname = ""
	@State private var confirmpassword = ""
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var viewModel: AuthView
	@State private var isEmailValid = false

	var body: some View {
		VStack {
			Image("TMLogo")
				.resizable()
				.scaledToFill()
				.frame(width: 200, height: 220)
				.padding(.vertical, 20)

			VStack(spacing: 24) {
				Input(text: $email, title: "Email Address", placeholder: "Enter Email")
					.autocapitalization(.none)
					.onChange(of: email) { newEmail in
						// Validate email format
						isEmailValid = newEmail.isValidEmail()
					}

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
						// Check if the email is valid before creating a user
						guard isEmailValid else {
							// Handle invalid email case
							return
						}

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
			.background(isEmailValid ? Color(.systemBlue) : Color(.gray))
			.cornerRadius(10)
			.padding(.top, 15)
			.disabled(!isEmailValid) // Disable button if email is not valid

			Spacer()

			HStack {
				Text("Already have an account?")

				Button(action: {
					dismiss()
				}) {
					Text("Sign In")
						.fontWeight(.bold)
				}
			}
		}
	}
}

extension String {
	// Enhanced email validation
	func isValidEmail() -> Bool {
		let emailRegEx = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
		let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: self)
	}
}

#if DEBUG
struct SignUp_Previews: PreviewProvider {
	static var previews: some View {
		SignUp()
	}
}
#endif
