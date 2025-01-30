
## HomeBakery: The Ultimate Baking Learning App 🍰🍞

Welcome to **HomeBakery** – an innovative iOS app designed to bring professional baking classes and workshops to your fingertips. Whether you're a passionate home baker or someone looking to turn your love for baking into a profession, this app connects you with experienced chefs who will guide you through the art of baking.

With **HomeBakery**, you can easily discover a variety of baking courses, book a session with top chefs, have your own profile with your courses, and even cancel bookings with a few taps. Here's how it works and what makes it so exciting!

---

## Features ✨

- **Explore All Available Courses**  
  View detailed information about all courses, including course level, chef’s name, location, and the course schedule (date & time).
  
- **Discover Upcoming & Popular Courses**  
  Stay updated with upcoming classes and browse through the most popular ones to book your spot in advance.

- **Interactive Course Map**  
  View the course location directly on **MapKit** integration, so you’ll never miss the location or struggle to find it.

- **Easy Course Booking**  
  Book a baking class and choose the session that fits your schedule. It’s a simple process, and you’ll be ready to bake in no time!

- **Cancel Bookings**  
  Changed your mind? No worries! The app allows you to cancel your bookings effortlessly.

- **Personal Profile**  
  View your personal profile with your name, image, and a list of your booked courses.

---

## Tools & Technologies Used 🔧

- **SwiftUI**: All user interfaces were built using **SwiftUI**, Apple's declarative framework for creating beautiful and interactive UIs for iOS applications.

- **MapKit**: Integrated to provide a seamless experience for users to view the course locations directly on the map. This ensures that finding the location for a baking class is easier than ever.

- **URLSession**: Used for networking to communicate with the backend API for fetching course data, booking information, and user authentication.


---

## API Integration 🌐

The app relies on a simple but powerful **REST API** for course information, bookings, and user authentication. Here’s how we’ve integrated the API:

1. **Login Authentication**  
   - The user’s email and password are sent to the backend API for validation.
   - Upon successful login, the user’s profile and available courses are retrieved using a secure **GET** request.
   
2. **Fetching Courses**  
   - The app sends a **GET** request to the API to fetch available courses based on the user’s search.
   - The response contains details like **Course Info**, **Date & Time**, and **Location**, which are displayed to the user.

3. **Course Booking**  
   - When the user books a class, a **POST** request is made to the API to reserve their spot with the chosen course.
   - The API confirms the booking and updates the user’s profile with the course they’ve enrolled in.

4. **Cancel Booking**  
   - A **DELETE** request to the API is made to cancel the user's booking if they no longer wish to attend the class.
   
5. **MapKit Integration**  
   - The location of each course is retrieved from the API and displayed on a **MapKit** map, making navigation to the location easier for users.

---

## Methodology 🛠️

The development process for **HomeBakery** follows an **Agile** methodology with continuous integration and testing to ensure that every new feature is integrated smoothly.

### Key Phases:
1. **Initial Planning**
   After receiving the design, I started by understanding the user flow for the features and prioritizing them based on user needs and app usability
   
3. **API Setup & Integration**  
   The core functionality of fetching data (such as course details and user info) was integrated with a REST API.

4. **UI/UX Design**  
   Using **SwiftUI**, I designed a clean, intuitive interface that’s easy to navigate. The focus was on simplicity, accessibility, and a responsive design.

5. **Testing & Refining**  
   After the initial development, I conducted **unit tests**, **integration tests**, and **UI tests** to ensure the app functions flawlessly across various devices.


---

## Contact 📧

Have any questions or suggestions? Feel free to reach out at:  
Email: **nalrowais98@gmail.com**  

---

Thank you for using **HomeBakery**! I hope you enjoy learning the art of baking. Happy baking! 🎂🥖

---

