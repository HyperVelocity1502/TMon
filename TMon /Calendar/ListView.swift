import SwiftUI

struct ListView: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var viewModel: AuthView
	@State private var userAppointments: [Appointment] = []
	@State private var isDeleteMode = false

	var body: some View {
		NavigationView {
			List {
				ForEach(groupedAppointments, id: \.0) { date, appointments in
					Section(header: Text(formatSectionHeader(date))) {
						ForEach(appointments) { appointment in
							AppointmentRow(appointment: appointment, onDelete: {
								// Handle deletion when the delete button is tapped
								deleteAppointment(appointment)
							})
						}
					}
				}
				.onDelete { indexSet in
					// Handle deletion when swiping
					deleteAppointments(at: indexSet)
				}
			}
			.listStyle(InsetGroupedListStyle())
			.toolbar {
				ToolbarItem(placement: .principal) {
					VStack {
						Text("Appointments")
							.font(.title)
							.foregroundColor(.primary)

						Rectangle()
							.frame(height: 1)
							.foregroundColor(.gray)
					}
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					EditButton()
				}
			}
		}
		.onAppear {
			// Fetch user appointments asynchronously when the view appears
			fetchUserAppointments()
		}
	}

	var groupedAppointments: [(Date, [Appointment])] {
		let uniqueAppointments = Array(Set(userAppointments))
			.sorted { $0.date < $1.date }

		return Dictionary(grouping: uniqueAppointments) { appointment in
			return Calendar.current.startOfDay(for: appointment.date)
		}
		.filter { $0.key >= Calendar.current.startOfDay(for: Date()) }
		.sorted { $0.key < $1.key }
	}

	func formatSectionHeader(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE, MMMM d"
		return dateFormatter.string(from: date)
	}

	func fetchUserAppointments() {
		// Fetch user appointments asynchronously
		Task {
			do {
				// Check if currentUser is nil before accessing its properties
				if let currentUser = viewModel.currentUser {
					userAppointments = try await databaseManager.fetchUserAppointments(email: currentUser.email)
				} else {
					// Handle the case when currentUser is nil
					print("User is not logged in.")
					// Reset userAppointments array when the user logs out
					userAppointments = []
				}
			} catch {
				print("Error fetching user appointments: \(error)")
			}
		}
	}

	func deleteAppointments(at indexSet: IndexSet) {
		// Handle deletion when swiping
		guard let firstIndex = indexSet.first else {
			return
		}

		// Capture the value in a local variable
		let appointmentToDelete = userAppointments[firstIndex]

		// Synchronously call an asynchronous function
		Task {
			do {
				try await databaseManager.deleteAppointment(appointmentToDelete)
				// Update the userAppointments array after deletion
				userAppointments.remove(atOffsets: indexSet)
			} catch {
				print("Error deleting appointments: \(error)")
			}
		}
	}

	func deleteAppointment(_ appointment: Appointment) {
		// Handle deletion when the delete button is tapped
		Task {
			do {
				try await databaseManager.deleteAppointment(appointment)
				// Update the userAppointments array after deletion
				if let index = userAppointments.firstIndex(where: { $0.id == appointment.id }) {
					userAppointments.remove(at: index)
				}
			} catch {
				print("Error deleting appointment: \(error)")
			}
		}
	}
}

struct AppointmentRow: View {
	var appointment: Appointment
	var onDelete: () -> Void

	var body: some View {
		HStack {
			VStack {
				Text(formatDate(appointment.date))
					.font(.subheadline)
					.foregroundColor(.gray)
					.padding(10)
			}
			.frame(maxWidth: .infinity)
		}
		.background(Color.secondary.opacity(0.1))
		.cornerRadius(10)
	}

	func formatDate(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mm a"
		return dateFormatter.string(from: date)
	}
}
