//
//  GetUsernameView.swift
//  replaTodoApp2
//
//  Created by Alper Sülün on 23.08.2022.
//

import SwiftUI

struct GetUsernameView: View {
   
    @State var loginUsername: String = ""
    @AppStorage("loginUsernameKey") var loginUsernameKey = ""
    @AppStorage("isLoggedIn") var isLoggedIn = false
    var body: some View {
        NavigationView{
            VStack {
                Text("Welcome!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20)
                //Image
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipped()
                    .cornerRadius(150)
                    .padding(.bottom, 75)
                //Textfield
                TextField("Enter your name", text:$loginUsernameKey)
                    .padding()
                    .background(Color("LightGrey"))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                //Login button
             //   NavigationLink(destination: Home(), isActive: //$navigated)
            //    {
                    Button(action: {
                        print("Button tapped")
                        isLoggedIn = true
                        
                    }
                    ) {
                        Text("LOGIN")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth:.infinity)
                            .background(Color.green)
                            .cornerRadius(15.0)
                    }
            //    }.navigationBarBackButtonHidden(true)

                
            }.padding()
        }
    }
}

struct GetUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        GetUsernameView()
    }
}
