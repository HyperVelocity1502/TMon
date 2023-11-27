//
//  Booking.swift
//  TMon 4
//
//  Created by Louis Flores on 11/9/23.
//

import SwiftUI
import Supabase
import Firebase

struct Booking: View {
	@EnvironmentObject var manager: DatabaseManager
	@EnvironmentObject var viewModel: AuthView
	
	@State var name = ""
	@State var email = ""
	@State var phone = ""
	
	@Binding var path: NavigationPath
	
	var currentDate: Date
	
	@State private var isConfirmationActive = false
	
	var body: some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading, spacing: 16) {
				HStack {
					Image(systemName: "clock")
					Text("30 Min")
				}
				
				HStack {
					Image(systemName: "info.bubble.rtl")
					Text("Doctors Appointment")
				}
				
				HStack(alignment: .top) {
					Image(systemName: "calendar")
					Text(currentDate.bookingViewDateFormat())
				}
			}
			.padding()
			
			Divider()
			
			if let currentUser = viewModel.currentUser {
				HStack
				{
					Text("Name: ")
					Text(currentUser.fullname ?? "")
						.padding()
				}
				HStack
				{
					Text("Email: ")
					Text(currentUser.email ?? "")
						.padding()
				}
				
				HStack
				{
					Text("Phone Number")
					
					Text("(*Optional)")
						.opacity(0.2)
				}
				TextField("", text: $phone)
					.padding()
					.background(
						RoundedRectangle(cornerRadius: 10)
							.stroke())
				
				Button(action: {
					Task {
						do {
							try await manager.bookAppointment(name: currentUser.fullname ?? "", email: currentUser.email ?? "", phone: phone, date: currentDate)
							name = ""
							email = ""
							phone = ""
							
							// Set isConfirmationActive to trigger NavigationLink
							isConfirmationActive = true
						} catch {
							print(error)
						}
					}
				}) {
					Text("Schedule Event")
						.bold()
						.foregroundColor(.white)
						.padding()
						.frame(maxWidth: .infinity)
						.background(RoundedRectangle(cornerRadius: 10)
							.foregroundColor(.blue))
				}
				
			} else {
				// Handle case when user is nil
				Text("User not available.")
			}
			
			// Use NavigationLink for programmatic navigation
			NavigationLink(
				destination: Confirmation(path: $path, currentDate: currentDate, name: viewModel.currentUser?.fullname ?? ""),
				isActive: $isConfirmationActive,
				label: { EmptyView() }
			)
			.hidden()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		.navigationTitle("Doctors Appointment")
	}
}

#if DEBUG
struct Booking_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			Booking(path: .constant(NavigationPath()), currentDate: Date())
				.environmentObject(DatabaseManager()) // Make sure to include your environment object
				.environmentObject(AuthView()) // Make sure to include your authentication environment object
		}
	}
}
#endif
