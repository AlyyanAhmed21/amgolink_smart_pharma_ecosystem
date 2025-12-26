# AmgoLink - Setup & Build Guide

This guide covers the complete process to set up the development environment, run the app, and build executable files for Windows and Android.

## 1. Prerequisites
Before starting, ensure you have:
*   **Operating System:** Windows 10 or 11.
*   **VS Code:** Installed ([Download here](https://code.visualstudio.com/)).
*   **Git:** Installed ([Download here](https://git-scm.com/)).

---

## 2. Setting up Flutter (Lightweight Method)
*If you already have Flutter installed and added to your PATH, skip to Section 3.*

1.  **Download Flutter:**
    *   Download the latest Flutter Windows Zip from the [official website](https://docs.flutter.dev/get-started/install/windows).
2.  **Extract:**
    *   Create a folder `src` in your `C:` or `E:` drive (e.g., `E:\src`).
    *   Extract the zip file there. You should have `E:\src\flutter`.
3.  **Update Path Variable:**
    *   Press **Windows Key**, type `env`, and select **"Edit the system environment variables"**.
    *   Click **Environment Variables**.
    *   Under **"User variables"**, find **Path** and click **Edit**.
    *   Click **New** and paste the path to the bin folder: `E:\src\flutter\bin`
    *   Click **OK** on all windows.
4.  **Verify:**
    *   Open a new Terminal (PowerShell or CMD).
    *   Type: `flutter --version`.
    *   If it shows a version number, you are ready.

---

## 3. Setting up the Project Directory

1.  **Open the Project:**
    *   Open VS Code.
    *   Go to `File > Open Folder` and select the **AmgoLink** folder.
2.  **Install Extensions (VS Code):**
    *   Go to the Extensions tab (Sidebar).
    *   Search for and install: **Flutter** and **Dart**.
3.  **Install Dependencies:**
    *   Open the VS Code Terminal (`Ctrl + ~`).
    *   Run the following command to download all required libraries:
    ```powershell
    flutter pub get
    ```

---

## 4. Running the App (Debug Mode)

### To Run on Windows (Recommended for Demo)
1.  In the terminal, run:
    ```powershell
    flutter run -d windows
    ```
2.  Wait for the build. The app will launch in a new window.

### To Run on Android (Requires Phone)
1.  Enable **Developer Mode** & **USB Debugging** on your Android phone.
2.  Connect phone to PC via USB.
3.  In the terminal, run:
    ```powershell
    flutter run -d android
    ```

---

## 5. Building for Delivery (Release Versions)

### Build Windows Application (.exe)
1.  Run the build command:
    ```powershell
    flutter build windows
    ```
2.  **Locate the files:**
    *   Go to: `build\windows\x64\runner\Release`
3.  **IMPORTANT:**
    *   Do not just send the `.exe`. It requires the `.dll` files in that folder.
    *   **Zip the entire 'Release' folder** and send that ZIP file.

### Build Android App (.apk)
1.  Run the build command:
    ```powershell
    flutter build apk --release
    ```
2.  **Locate the file:**
    *   Go to: `build\app\outputs\flutter-apk\`
    *   You will find `app-release.apk`.
3.  Rename it to `AmgoLink.apk` and send it to the client.

---

## 6. Troubleshooting
*   **"Flutter command not found":** You did not add the bin folder to your Environment Variables (Path) correctly.
*   **"Version solving failed":** Open `pubspec.yaml`, find `environment: sdk:`, and change it to `'>=3.0.0 <4.0.0'`. Then run `flutter pub get` again.
