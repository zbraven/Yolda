Yolda Development TODO List
This list breaks down the project into logical milestones. You can check the box (- [x]) as you complete each step.

Milestone 0: Project Setup and Foundations
This stage covers the essential steps to be taken before starting to code.

[ ] Create Xcode Project: Start the project using SwiftUI and Swift.

[ ] Set Up Version Control: Create a Git repository for the project (e.g., GitHub).

[ ] Define Project Architecture: Plan the project structure (e.g., MVVM). Create the necessary folders and groups.

[ ] Create Data Models (SwiftData/Core Data):

[ ] Habit model: id, name, whyNote, creationDate, scheduleType (daily, weekly, etc.).

[ ] HabitLog model: habitID, date, status (completed, reset, paused), resetNote.

[ ] Create Style Files: Define the color palette and font styles to be used throughout the app in a central StyleGuide file.

Milestone 1: MVP - Minimum Viable Product
The goal of this stage is to get the most basic features of the application up and running.

[ ] Main Screen (Habit List):

[ ] Create a View that lists the saved habits.

[ ] Add a simple "completion" button for each habit.

[ ] Add Habit Screen:

[ ] Add text input fields for the habit name and the "Remember Why" note.

[ ] For now, create a save button that only works with the "Every Day" option.

[ ] Basic Data Operations:

[ ] Write the function to save a new habit to the database.

[ ] Code the function to complete a habit (creating a HabitLog).

[ ] Add a swipe-to-delete function to remove a habit from the list.

[ ] Basic Streak Calculation:

[ ] Create the basic logic to calculate the current continuous streak for a habit and display it on the main screen.

Milestone 2: UI/UX and Philosophy Integration
This stage focuses on the critical features that reflect the "feel" and philosophy of the app.

[ ] Improve Design: Apply minimalist design principles (whitespace, colors, fonts) to all screens.

[ ] Calendar View:

[ ] Create the habit detail page.

[ ] Add a monthly calendar View to this page.

[ ] Display completed, skipped, and empty days on the calendar with different colors or icons.

[ ] Pause Feature:

[ ] Add a "Pause" button to the habit detail page.

[ ] Code the pause logic (it should not break the streak).

[ ] Visually mark paused days on the calendar.

[ ] Reset and Add Note Feature:

[ ] Add the streak reset button.

[ ] When resetting, show a sheet asking the user for a "Reset Note".

[ ] Save this note and the reset information and visualize it on the calendar.

[ ] "Remember Why" Display: Prominently display this note on the habit detail page.

Milestone 3: Advanced Features and Enhancements
Additional features that make the application more powerful and useful.

[ ] Widgets:

[ ] Add a "Widget Extension" to the project.

[ ] Create a small-sized widget that displays a single habit.

[ ] Create a medium-sized widget that lists multiple habits.

[ ] Milestones:

[ ] Write the logic to detect when goals like 7, 30, or 100 days are reached.

[ ] Design and implement a simple congratulatory message or badge to be displayed when a goal is reached.

[ ] Custom Day Tracking Enhancement:

[ ] Activate the "Specific days of the week" option on the add/edit habit screen.

[ ] Dark Mode Compatibility:

[ ] Ensure all screens and components look seamless and aesthetically pleasing in dark mode.

[ ] Haptic Feedback and Animations:

[ ] Add subtle haptic feedback for actions like completing a habit.

[ ] Add simple and fast animations to make the interface more fluid.

Milestone 4: Pre-Launch Preparation and Testing
The application is now ready, time for final checks.

[ ] Comprehensive Testing:

[ ] Functional Test: Check that all features are working correctly.

[ ] UI Test: Ensure the interface does not break on different iPhone screen sizes (e.g., iPhone SE, Pro Max).

[ ] Edge Case Tests: Test scenarios like changing time zones, year/month rollovers, etc.

[ ] Gathering Feedback (Beta Test): Send the app to a few friends via TestFlight to request feedback.

[ ] App Store Materials:

[ ] Design the app icon.

[ ] Prepare promotional screenshots.

[ ] Write the descriptive text and keywords for the App Store.

[ ] App Store Connect Setup: Create the application record and fill in the necessary information.

[ ] Final Review and Release: Make final adjustments based on feedback and submit the app to Apple for review.

Future Plans (v2 and Beyond)
Potential features that can be added after the application is released.

[ ] iCloud Sync

[ ] iPad and Apple Watch Support

[ ] Archive Feature

[ ] Simple Statistics (e.g., monthly completion rate)