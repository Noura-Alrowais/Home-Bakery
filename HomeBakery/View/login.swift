import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel() // تهيئة الـ ViewModel
    @State private var navigateToProfile = false
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle().foregroundStyle(Color("Background")).ignoresSafeArea()
                
                VStack {
                    Text("Email")
                        .font(.custom("SFProRounded-Medium", size: 18))
                        .padding(.trailing, 277.0)
                    
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .frame(width: 336, height: 49)
                    
                    Text("Password")
                        .font(.custom("SFProRounded-Medium", size: 18))
                        .padding(.trailing, 240.0)
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 336, height: 49)
                    
                    Button(action: {

                        viewModel.login()
                        
                        if let user = viewModel.user {
                            self.navigateToProfile = true                         }
                    }) {
                        Text("Sign in")
                            .frame(width: 280.0, height: 15.0)
                            .padding()
                            .background(Color("Primary"))
                            .foregroundColor(.white)
                            .cornerRadius(9)
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    
                           
                }
                .background(Color("Background"))
                .padding(.bottom, 300)
                
                
            }
            
            if let user = viewModel.user {
                NavigationLink(
                    destination:   DashboardView(user: User(id: user.id, email: user.email, name: user.name, password: user.password)),                    isActive: $navigateToProfile,            label: { EmptyView() } 
                )
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
            .previewDevice("iPhone 15")
    }
}
