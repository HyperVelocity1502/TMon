//
//  UserView.swift
//  TMon 4
//
//  Created by Louis Flores on 11/16/23.
//


import Foundation
struct User: Identifiable, Codable
{
	let id: String
	let fullname: String
	let email: String
	
	var initials: String
	{
		let formatter = PersonNameComponentsFormatter()
		if let componenets = formatter.personNameComponents(from: fullname)
		{
			formatter.style = .abbreviated
			return formatter.string(from: componenets)
		}
		
		return ""
	}
}


extension User
{
	static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "FULL NAME", email: "EMAIL@TEST.COM")
}


