//
//  Confirmation.swift
//  TMon 4
//
//  Created by Louis Flores on 11/9/23.
//

import SwiftUI

struct Confirmation: View {
	@Binding var path: NavigationPath
	var currentDate: Date
	var name: String
	@EnvironmentObject var manager: DatabaseManager

	@State private var isConfirmationPresented: Bool = false

	var body: some View {
		VStack {
			Text("Confirmed")
				.font(.title)
				.bold()
				.padding()

			Text("You Have Been Scheduled \(name)")

			Divider()
				.padding()

			VStack(alignment: .leading, spacing: 20) {
				// ... (rest of the view)

				Spacer()

				NavigationLink(
					destination: EventsCalendarView(),
					isActive: $isConfirmationPresented,
					label: {
						Button(action: {
							// Your logic here, and when you want to navigate
							self.isConfirmationPresented = true
							self.path.append(AppRouter.eventsCalendar)
						}) {
							Text("Done")
								.bold()
								.padding()
								.foregroundColor(.white)
								.frame(maxWidth: .infinity)
								.background(
									RoundedRectangle(cornerRadius: 10)
										.foregroundColor(.blue)
								)
						}
					}
				)
				.padding()
				.onAppear {
					if self.isConfirmationPresented {
						// Handle navigation when isConfirmationPresented is true
						self.path = NavigationPath() // Reset the path if needed
					}
				}
			}
			.padding()
			.frame(maxHeight: .infinity, alignment: .top)
		}
	}
}


#Preview
{
	NavigationStack {
		Confirmation(path: .constant(NavigationPath()), currentDate: Date(), name: "John Doe")
			.environmentObject(DatabaseManager())  // Make sure to inject the environment object
	}
}
