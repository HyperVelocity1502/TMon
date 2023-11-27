//
//  DatabaseManager.swift
//  TMon 4
//
//  Created by Louis Flores on 11/13/23.
//

import Foundation
import Supabase
import Combine

struct Hours: Codable
{
	let id: Int
	let createdAt: Date?
	let day: Int
	let start: Int
	let end: Int
	
	enum CodingKeys: String, CodingKey
	{
		case id, day, start, end
		case createdAt = "created_at"
	}
}

struct Appointment: Codable, Identifiable, Hashable
{
	var id: Int?
	let createdAt: Date?
	let name: String
	let email: String
	let phone: String
	let date: Date
	
	
	
	enum CodingKeys: String, CodingKey
	{
		case id, name, email, phone, date
		case createdAt = "created_at"
	}
	
	static func == (lhs: Appointment, rhs: Appointment) -> Bool {
			// Compare appointments based on relevant properties
			return lhs.id == rhs.id &&
				lhs.createdAt == rhs.createdAt &&
				lhs.name == rhs.name &&
				lhs.email == rhs.email &&
				lhs.phone == rhs.phone &&
				Calendar.current.isDate(lhs.date, inSameDayAs: rhs.date)
		}

		func hash(into hasher: inout Hasher) {
			// Use only the date for hashing
			hasher.combine(Calendar.current.startOfDay(for: date))
		}
}

enum AppointmentError: Error 
{
	case duplicateAppointment
}

class DatabaseManager: ObservableObject
{
	enum UserRole 
	{
		case client
		case business
	}
	
	@Published var userRole: UserRole = .client // Default to client
	@Published var availibleDates = [Date]()
	@Published var availibleDays: Set<String> = []
	@Published var name: String = ""
	@Published var email: String = ""
	@Published var appointmentsPublisher = PassthroughSubject<[Appointment], Never>()

	
	private let client = SupabaseClient(supabaseURL: URL(string: "https://nndwjxglucbpbpmnpzsv.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5uZHdqeGdsdWNicGJwbW5wenN2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkxNjAyNzgsImV4cCI6MjAxNDczNjI3OH0.0tg4E7Li9ww0LOFrFKlCOyqrsBIYyQjGQgMWLvocBZs")
	
	init() 
	{
		Task
		{
			do
			{
				let dates = try await self.fetchAvaliableAppointments()
				availibleDates = dates
				availibleDays = Set(availibleDates.map({ $0.monthDayYearFormat() }))
			} catch
			{
				print("Error initializing DatabaseManager: \(error)")
			}
		}
	}
	
	private func fetchHours() async throws -> [Hours]
	{
		let response: [Hours] = try await client.database.from("hours").select().execute().value
		
		print(response)
		return response
	}
	
	func fetchAvaliableAppointments() async throws -> [Date]
	{ 
		do
		{
			let appts: [Appointment] = try await client.database.from("appointments").select().execute().value
			return try await generateAppointmentTimes(from: appts)
		} catch {
			print("Error fetching available appointments: \(error)")
			throw error // Propagate the error
		}
	}
	
	private func generateAppointmentTimes(from appts:  [Appointment]) async throws -> [Date] 
	{
		let takenAppts: Set<Date> = Set(appts.map({$0.date}))
		let hours = try await fetchHours()

		let calendar = Calendar.current
		let currentWeekday = calendar.component(.weekday, from: Date()) - 2

		var timeSlots = Set<Date>() // Use a set to ensure uniqueness

		let numberOfWeeks = 6 // Change this value based on your requirements

		for weekOffset in 0..<numberOfWeeks {
			let daysOffset = weekOffset * 7

			for hour in hours 
			{
				if hour.start != 0 && hour.end != 0 
				{
					var currentDate = calendar.date(from: DateComponents(
						year: calendar.component(.year, from: Date()),
						month: calendar.component(.month, from: Date()),
						day: calendar.component(.day, from: Date()) + daysOffset + (hour.day - currentWeekday),
						hour: hour.start
					))!

					while let nextDate = calendar.date(byAdding: .minute, value: 30, to: currentDate),
						  calendar.component(.hour, from: nextDate) <= hour.end {
						if !takenAppts.contains(currentDate) && currentDate > Date() && calendar.component(.hour, from: currentDate) != hour.end 
						{
							timeSlots.insert(currentDate)
						}

						currentDate = nextDate
					}
				}
			}
		}

		let sortedTimeSlots = timeSlots.sorted(by: { $0 < $1 }) // Sort the time slots

		return sortedTimeSlots
	}
	
	func bookAppointment(name: String, email: String, phone: String, date: Date) async throws {
		do {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
			let dateString = dateFormatter.string(from: date)

			// Check if there is an existing appointment for the same user and date
			let existingAppointments: [Appointment] = try await client
				.database
				.from("appointments")
				.select()
				.eq(column: "email", value: email)
				.eq(column: "date", value: dateString)  // Convert Date to String
				.execute()
				.value

			if !existingAppointments.isEmpty {
				// User already has an appointment for the selected date
				throw AppointmentError.duplicateAppointment
			}

			// No existing appointment, proceed with booking
			let appointment = Appointment(createdAt: Date(), name: name, email: email, phone: phone, date: date)

			let response = try await client
				.database
				.from("appointments")
				.upsert(values: [appointment], onConflict: "id")
				.execute()

			print("Database response: \(response)")

			// Remove the booked appointment from the available time slots
			var availableAppointments = try await fetchAvaliableAppointments()
			if let index = availableAppointments.firstIndex(of: date) {
				availableAppointments.remove(at: index)
			}

			print("Available Appointments after booking: \(availableAppointments)")

			appointmentsPublisher.send(try await fetchUserAppointments(email: email))

		} catch {
			print("Error booking appointment: \(error)")
			throw error
		}
	}
	
	func fetchUserAppointments(email: String) async throws -> [Appointment]
	{
		   do 
		   {
			   // Fetch appointments for the specified user
			   let response: [Appointment] = try await client
				   .database
				   .from("appointments")
				   .select()
				   .eq(column: "email", value: email)
				   .execute()
				   .value

			   appointmentsPublisher.send(response)

			   return response
		   } catch {
			   print("Error fetching user appointments: \(error)")
			   throw error
		   }
	   }
	
	func deleteAppointment(_ appointment: Appointment) async throws {
			guard let appointmentId = appointment.id else { return }

			do {
				let response = try await client
					.database
					.from("appointments")
					.delete()
					.eq(column: "id", value: appointmentId)
					.execute()

				print("Deleted appointment. Database response: \(response)")
			} catch {
				print("Error deleting appointment: \(error)")
				throw error
			}
		}

	class AppointmentsPublisher: ObservableObject {
		@Published var didUpdateAppointments = PassthroughSubject<Void, Never>()
		
		func updateAppointments() {
			didUpdateAppointments.send()
		}
	}
}
