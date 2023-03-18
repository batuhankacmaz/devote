//
//  ContentView.swift
//  Devote
//
//  Created by Batuhan Kacmaz on 5.03.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: - PROPERTY
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false
    
 
    
    // FETCHING DATA
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    //MARK: - FUNCTIONS
    
   
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //MARK: - BODY
    
    var body: some View {
            NavigationStack {
                ZStack {
                    //MARK: - MAIN  VIEW
                    VStack {
                      //MARK: - HEADER
                        HStack(spacing: 10) {
                            // TITLE
                            Text("Devote")
                                .font(.system(.largeTitle, design: .rounded))
                            
                           Spacer()
                            
                            // EDIT BUTTON
                            EditButton()
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .padding(.horizontal, 10)
                                .frame(minWidth: 70, minHeight: 24)
                                .background(
                                    Capsule().stroke(Color.white, lineWidth: 2)
                                )
                            // APPEARANCE BUTTON
                            Button {
                                // TOGGLE APPEARANCE
                                isDarkMode.toggle()
                            } label: {
                                Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .font(.system(.title, design: .rounded))
                            }

                            
            
                        } //: HSTACK
                        .padding()
                        .foregroundColor(.white)
                        
                        Spacer(minLength: 80)
                        //MARK: - NEW TASK BUTTON
                        
                        Button {
                            showNewTaskItem.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                            Text("New Task")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                                .clipShape(Capsule())
                        )
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)

                        //MARK: - TASKS
                        
                        List {
                            ForEach(items) { item in
                               ListRowItemView(item: item)
                            }
                            .onDelete(perform: deleteItems)
                        } //: LIST
                        .cornerRadius(20) // 1.
                        .listStyle(.inset) // 2.
                        .padding(20) // 3.
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                        .padding(.vertical, 30)
                        .frame(maxWidth: 640)
            
                    } //: VSTACK
                    
                    //MARK: - NEW TASK ITEM
                    
                    if showNewTaskItem {
                        BlankView()
                            .onTapGesture {
                                withAnimation {
                                    showNewTaskItem = false
                                }
                            }
                        NewTaskItemView(isShowing: $showNewTaskItem)
                    }
                    
                } //: ZSTACK
                .navigationTitle("Daily Tasks")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarHidden(true)
                .background(
                    BackgroundImageView()
                )
                .background(
                    backgroundGradient.ignoresSafeArea()
                )
            } //: NAVIGATION
           
        
    }
}



//MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
