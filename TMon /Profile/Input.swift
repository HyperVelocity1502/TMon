//
//  Input.swift
//  TMon 4
//
//  Created by Louis Flores on 11/15/23.
//

import SwiftUI

struct Input: View
{
	@Binding var text: String
	let title: String
	let placeholder: String
	var isSecureField = false
	
	var body: some View
	{
		VStack(alignment: .leading, spacing: 12)
		{
			Text(title)
				.foregroundColor(Color(.darkGray))
				.fontWeight(.semibold)
				.font(.footnote)
			
			if isSecureField
			{
				SecureField(placeholder, text: $text)
					.font(.system(size: 14))
				
			}
			else
			{
				TextField(placeholder, text:$text)
					.font(.system(size:14))
			}
			
		}
	}
}
#Preview
{
	
	Input(text: .constant(""), title: "Email Address", placeholder: "email")
}
