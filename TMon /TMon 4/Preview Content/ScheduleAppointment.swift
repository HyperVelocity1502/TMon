//
//  ScheduleAppointment.swift
//  TMon 4
//
//  Created by Louis Flores on 10/24/23.
//

import SwiftUI

struct ScheduleAppointment: View 
{
    var body: some View 
	{
        VStack
		{
			TabView
			{
				SignIn()
					.tabItem
					{
						Label("Schedule Appointment", systemImage: "Calendar")
							.padding()
					}
				
				ContentView()
					.tabItem 
					{
						Label("Calendar", systemImage: "Calendar")
							.padding()
					}
				
				
			
			}
		}
    }
	
}

#Preview 
{
    ScheduleAppointment()
}
