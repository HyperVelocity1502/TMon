import SwiftUI


struct SignIn: View
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
				
				VStack(spacing: 24)
				{
					Input(text: $email, title: "Email Address", placeholder: "Enter Email")
						.autocapitalization(.none)
					
					Input(text: $password, title: "Password", placeholder: "Enter Password", isSecureField: true)
						.padding(.bottom, 24)
					
					
				}
				.padding(.horizontal)
				.padding(.top, 12)
				
				Button 
				{
					Task 
					{
						do 
						{
							try await viewModel.signIn(withEmail: email, password: password)
						} catch 
						{
							// Handle any errors if necessary
						}
					}
				} label: 
				{
					HStack 
					{
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
				
				
				HStack 
				{
					Text("Dont't have an account?")

					NavigationLink
					{
						SignUp()
							
					}label:
					{
						Text("Sign up")
							.fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
					}
				}.font(.system(size: 14))
			}
		}
	}
}

extension SignIn: AuthenticateFormProtocol
{
	var formIsValid: Bool
	{
		return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count > 6
	}
}


#Preview
{
	SignIn()
}


