Application Specification: Yolda (A Calm Habit Tracker)
This document outlines the core concept, features, and technical requirements for a minimalist, user-centric habit-tracking application named "Yolda."

1. Overview
1.1. Concept
Yolda is a calm, purposeful, and minimalist habit-tracking application that does not overwhelm users with gamification or unnecessary features. Its core philosophy is to help users track their habits consciously, continue without guilt after interruptions, and maintain their motivation. The application aims to be a "peaceful" and personal companion rather than a "clinical" or "mechanical" counter.

1.2. Target Audience
Individuals who dislike traditional, noisy, and gamified habit applications.

People who want to integrate simple and functional tools into their lives.

Those who value digital detox and conscious technology use.

Users looking for more than just a counter, who want motivation and reflection.

1.3. Platform
Primary Platform: iOS (iPhone)

Future Potential: iPadOS, watchOS

1.4. Monetization Model
One-Time Purchase: The application is offered for a single fee, with all features included.

What It Won't Have: Subscriptions, in-app purchases (upsells), ads, or locked features. The goal is a transparent and honest model.

2. Core Principles and Design Philosophy
2.1. Minimalist User Interface (UI)
Color Palette: Calming, pastel, or monochromatic tones to provide a serene experience that is easy on the eyes.

Typography: Legible and elegant fonts.

Use of Whitespace: Ample white (or empty) space in the interface to create a feeling of openness and focus.

Iconography: Simple, understandable, and universal icons.

2.2. Focused Experience (UX)
The application serves a single purpose: habit tracking. Distracting elements like social sharing, leaderboards, or point systems will not be included.

Animations should be fluid, fast, and purposeful; they should not make the user wait or feel intrusive.

2.3. Dark Mode
The application must offer a flawless dark mode experience that is fully compatible with iOS system settings.

An option can be provided for the user to manually switch between light and dark modes.

3. Feature Set
3.1. Main Screen (Habit List)
A simple interface listing all the habits created by the user.

The following information is visible for each habit:

Habit Name

Current streak count (e.g., "15 days")

Completion status for today (e.g., a checkable circle or button)

3.2. Habit Creation and Management
Adding a New Habit:

Habit Name: A free-text field.

"Remember Why": A motivational note field where the user writes why they started this habit. This note will be shown to them in the future when they feel like quitting.

Custom Day Tracking:

Every day

Specific days of the week (Mon, Wed, Fri, etc.)

At specific intervals (e.g., every 3 days)

Editing/Deleting a Habit: All properties of existing habits (name, note, frequency) can be edited, or the habit can be deleted entirely.

3.3. Tracking Mechanisms
Completion: The user marks the habit for the day as "completed" with a single tap. This action increments the streak.

Pausing (Pause Without Guilt):

The user can pause a habit indefinitely or for a specific period (e.g., vacation, illness).

The streak is not broken and is preserved during the pause.

Paused days are marked with a different color or icon in the calendar view.

Resetting:

When a user intentionally breaks a streak, they use the "Reset" button.

After resetting, the user is prompted to enter a "Reset Note" to encourage reflection on "What happened?".

The streak is reset, and this day is marked with a special icon (e.g., a broken chain) in the calendar.

3.4. Visualization and Feedback
Calendar View:

Each habit's detail page includes a monthly calendar view.

The following statuses are clearly visualized on this calendar:

Completed Days: (e.g., A filled green circle)

Skipped/Reset Days: (e.g., A red X or a broken icon)

Paused Days: (e.g., A gray pause icon)

Future Target Days: (e.g., An empty circle)

Milestones:

When the user reaches specific streak goals (e.g., 7, 30, 100, 365 days), a simple and motivating notification or visual is displayed.

This could be an elegant congratulatory message or a small badge appearing in the habit list, rather than a distracting celebration animation.

"Remember Why" Display: The user should be able to easily see their motivational note when viewing habit details or when tempted to break a streak.

3.5. Widgets
Allow users to track their habits from their home screen without opening the app.

Small Widget: Shows a single habit with its name, streak count, and a completion button.

Medium Widget: Shows a list of 2-4 habits with completion buttons next to them.

Large Widget: Offers more habits and perhaps a small calendar preview.

4. Technical Requirements
Data Storage:

All data (habits, notes, dates) must be stored locally on the user's device (e.g., Core Data, SwiftData, Realm).

iCloud Sync (v2 Feature): In the future, iCloud integration can be added to sync user data across different iOS devices. This must be privacy-focused and require user consent.

Notifications:

Users should be able to optionally set reminder notifications for their habits.

Notifications should be minimalist and non-intrusive (e.g., "Don't forget to make time for [Habit Name] today.").

Minimum iOS Version: Should target iOS 16 or later to support modern Widget APIs and Swift/SwiftUI features.

5. Example User Flow
First Launch: The user opens the app. They are greeted with an empty main screen and an "Add your first habit" button.

Adding a Habit: The user taps the button. They enter the name "Read 10 pages a day." In the "Remember Why" section, they write, "To become wiser and calmer." They set it for every day of the week and save.

Tracking: The new habit appears on the main screen. After reading their book that day, the user marks the habit as "completed" from the app's widget or the main screen. The streak becomes "1 day."

Pausing: A week later, the user goes on vacation. They enter the app and pause the "Read Book" habit for 5 days. Their streak (7 days) is preserved.

Resetting: After returning from vacation, one day is very busy, and they fail to perform the habit. The next day, when they open the app, they cannot continue the streak. They use the "Reset" option. A note prompt appears, and they write, "Came home late and tired from work, couldn't manage my time." The streak is reset.

Motivation: A month later, their streak is back in the 20s, but one day their motivation is low. They tap on the habit details, read their note "To become wiser and calmer," and get remotivated to continue their habit.

Milestone: Upon reaching the 30th day, a small "30 Day" badge appears next to the "Read Book" habit on the main screen.