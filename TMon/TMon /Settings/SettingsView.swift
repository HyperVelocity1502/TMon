//
//  SettingsView.swift
//  TMon 4
//
//  Created by Louis Flores on 11/16/23.
//

import SwiftUI

struct SettingsView: View
{
	let imageName: String
	let title: String
	let tintColor: Color
	var fontColor: Color

	
    var body: some View
	{
		HStack(spacing: 12)
		{
			Image(systemName: imageName)
				.imageScale(.small)
				.font(.title)
				.foregroundColor(tintColor)
			
			Text(title)
				.font(.subheadline)
				.foregroundColor(fontColor)
		}
    }
}

#Preview
{
	SettingsView(imageName: "gear", title: "Version", tintColor: Color(.systemGray), fontColor: .primary)
}
