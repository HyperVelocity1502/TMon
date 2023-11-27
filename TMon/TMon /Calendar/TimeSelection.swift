//
//  TimeSelection.swift
//  TMon 4
//
//  Created by Louis Flores on 11/9/23.
//
import SwiftUI

struct TimeSelection: View {
	@EnvironmentObject var manager: DatabaseManager
	
	@State var dates = [Date]()
	@State var selectedDate: Date?
	@State private var isBookingActive = false
	
	@Binding var path: NavigationPath
	
	var currentDate: Date
	
	var body: some View {
		ScrollView {
			VStack {
				Text(currentDate.fullMonthDayYearFormat())
				
				Divider().padding(.vertical)
				
				Text("Select a Time")
					.font(.largeTitle)
					.bold()
				
				Text("Duration:")
				
				ForEach(dates, id: \.self) { date in
					HStack {
						Button {
							withAnimation {
								selectedDate = date
								isBookingActive = true
							}
						} label: {
							Text(date.timeFromDate())
								.bold()
								.padding()
								.frame(maxWidth: .infinity)
								.foregroundColor(selectedDate == date ? .white : .blue)
								.background(
									RoundedRectangle(cornerRadius: 10)
										.stroke(selectedDate == date ? Color.green : Color.blue)
								)
						}
					}
				}
				
				// Use NavigationLink outside of the loop
				NavigationLink(
					destination: Booking(path: $path, currentDate: selectedDate ?? Date()), // Pass selectedDate
					isActive: $isBookingActive,
					label: {
						EmptyView()
					}
				)
				.hidden()
			}
			.onAppear {
				self.dates = manager.availibleDates.filter({ $0.monthDayYearFormat() == currentDate.monthDayYearFormat()})
				
				// Reset selectedDate when view appears
				selectedDate = nil
				isBookingActive = false
			}
		}
		.navigationTitle(currentDate.dayofWeek())
		.navigationBarTitleDisplayMode(.inline)
	}
}
#if DEBUG
struct TimeSelection_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			TimeSelection(path: .constant(NavigationPath()), currentDate: Date())
				.environmentObject(DatabaseManager())
		}
	}
}
#endif
