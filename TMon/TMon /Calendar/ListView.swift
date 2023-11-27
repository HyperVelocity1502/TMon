import SwiftUI

struct ListView: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var viewModel: AuthView
	@State private var userAppointments: [Appointment] = []
	@State private var isDeleteAlertPresented = false
	@State private var appointmentToDelete: Appointment?

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
			.alert(isPresented: $isDeleteAlertPresented) {
				Alert(
					title: Text("Confirm Deletion"),
					message: Text("Are you sure you want to delete this appointment?"),
					primaryButton: .destructive(Text("Delete")) {
						deleteConfirmedAppointment()
					},
					secondaryButton: .cancel()
				)
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
		Task {
			do {
				if let currentUser = viewModel.currentUser {
					userAppointments = try await databaseManager.fetchUserAppointments(email: currentUser.email)
				} else {
					print("User is not logged in.")
					userAppointments = []
				}
			} catch {
				print("Error fetching user appointments: \(error)")
			}
		}
	}

	func deleteAppointments(at indexSet: IndexSet) {
		guard let firstIndex = indexSet.first else {
			return
		}

		appointmentToDelete = userAppointments[firstIndex]
		isDeleteAlertPresented = true
	}

	func deleteConfirmedAppointment() {
		guard let appointmentToDelete = appointmentToDelete else {
			return
		}

		Task {
			do {
				try await databaseManager.deleteAppointment(appointmentToDelete)
				userAppointments.removeAll { $0.id == appointmentToDelete.id }
			} catch {
				print("Error deleting appointment: \(error)")
			}
		}
	}

	func deleteAppointment(_ appointment: Appointment) {
		// Handle deletion when the delete button is tapped
		deleteAppointments(at: IndexSet([userAppointments.firstIndex(of: appointment)!]))
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
