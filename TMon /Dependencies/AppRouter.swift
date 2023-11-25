//
//  appRouter.swift
//  TMon 4
//
//  Created by Louis Flores on 11/13/23.
//

import Foundation

enum AppRouter: Hashable
{
	case day(date: Date)
	case booking(date: Date)
	case confirmation(date: Date, name: String)
	case eventsCalendar // New case for EventsCalendarView

}
