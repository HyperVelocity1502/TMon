//
//  EventsCalendarView.swift
//  TMon 4
//
//  Created by Louis Flores on 10/25/23.
//

import SwiftUI

struct EventsCalendarView: View
{
	@StateObject var manager = DatabaseManager()
	
	let days = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
	@State private var selectedMonth = 0
	@State private var selectedDate = Date()
	@State private var path = NavigationPath()
	
	
	var body: some View
	{
		let name = manager.name

		NavigationStack(path: $path)
		{
			VStack
			{
				Text("Calendar")
					.font(.title)
					.bold()
				
				Rectangle()
					.frame(height:1)
					.foregroundColor(.gray)
				
				VStack(spacing: 20)
				{
					Text("Select a Day")
						.font(.title2)
						.bold()
					
					HStack
					{
						Spacer()
						
						Button
						{
							withAnimation
							{
								selectedMonth -= 1
							}
						}label:
						{
							Image(systemName: "lessthan.circle.fill")
								.resizable()
								.scaledToFit()
								.frame(width: 32, height: 32)
								.foregroundColor(.gray)
						}
						
						Spacer()
						
						Text(selectedDate.monthYearFormat())
							.font(.title2)
						
						Spacer()
						
						Button
						{
							withAnimation
							{
								selectedMonth += 1
							}
						}label:
						{
							Image(systemName: "greaterthan.circle.fill")
								.resizable()
								.scaledToFit()
								.frame(width: 32, height: 32)
								.foregroundColor(.gray)
						}
						Spacer()
					}
					HStack
					{
						ForEach(days, id:\.self)
						{
							day in
							Text(day)
								.font(.system(size: 12, weight: .medium))
								.frame(maxWidth: .infinity)
						}
					}
					
					LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 20)
					{
						ForEach(fetchDates())
						{
							value in
							ZStack
							{
								if value.day != -1
								{
									let hasAppts = manager.availibleDays.contains(value.date.monthDayYearFormat())
									
									NavigationLink(value: AppRouter.day(date: value.date))
									{
										Text("\(value.day)")
											.font(.headline)
											.frame(width: 32, height: 32)
											.foregroundColor(.primary)
											.background(
												ZStack(alignment: .bottom) 
												{
													Circle()
														.frame(width: 48, height: 48)
														.foregroundColor(hasAppts ? .blue.opacity(0.3) : .clear)
													
													if value.date.monthDayYearFormat() == Date().monthDayYearFormat() 
													{
														Circle()
															.frame(width: 8, height: 8)
															.foregroundColor(hasAppts ? .blue : .primary)
													}
												}
											)
											.padding(8)
											.disabled(!hasAppts)
									}
								}
								else
								{
									Text("")
								}
							}
							.frame(width: 32, height: 32)
						}
					}
				}
				.padding()
			}
			.frame(maxHeight: .infinity, alignment: .top)
			.onChange(of: selectedMonth)
			{
				_ in
				selectedDate = fetchSelectedMonth()
			}
			.navigationDestination(for: AppRouter.self)
			{
				router in
				switch router
				{
				case .day(let date):
					TimeSelection(path: $path, currentDate: date)
						.environmentObject(manager)
				case .booking(let date):
					Booking(path: $path, currentDate: date)
						.environmentObject(manager)
				case .confirmation(let date, let name):
					Confirmation(path: .constant(NavigationPath()), currentDate: date, name: name)
					case .eventsCalendar: EventsCalendarView()
					
				}
			}
		}.environmentObject(manager)
	}
	
	func fetchDates() -> [CalendarDate]
	{
		let calendar = Calendar.current
		let currentMonth = fetchSelectedMonth()
		
		var dates = currentMonth.datesOfMonth().map({CalendarDate(day: calendar.component(.day, from: $0), date: $0)})
		
		let firstDayOfWeek = calendar.component(.weekday, from: dates.first?.date ?? Date())
		
		for _ in 0..<firstDayOfWeek - 1
		{
			dates.insert(CalendarDate(day: -1, date: Date()), at: 0)
		}
		return dates
	}
	
	func fetchSelectedMonth() -> Date
	{
		let calendar = Calendar.current
		let month = calendar.date(byAdding: .month, value: selectedMonth, to: Date())
		return month!
	}
}

struct CalendarDate: Identifiable
{
	let id = UUID()
	var day: Int
	var date: Date
}

#Preview
{
	EventsCalendarView()
}
