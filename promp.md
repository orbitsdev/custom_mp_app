Your tasks:

────────────────────────────────────────
A. ⛑️ BACKEND API IMPLEMENTATION (Flutter Repo)
────────────────────────────────────────
Study the API spec and update my auth_repository.dart by adding:

1. updateUserDetails(Map<String, dynamic> body)
   - Uses PATCH /api/profile/details
   - Accepts ANY combination of fields from:
        name, email, password, password_confirmation,
        account_information.full_name,
        account_information.phone_number,
        account_information.gender,
        account_information.date_of_birth
   - Should return the parsed user model

2. uploadAvatar(File file, {ProgressCallback? onSendProgress})
   - Uses POST /api/profile/avatar
   - multipart/form-data
   - MUST support Dio onSendProgress
   - Must return updated user model

3. deleteAvatar()
   - Uses DELETE /api/profile/avatar

4. Make sure all responses use my ApiResponse handler convention.

5. Create strongly typed request examples for each function.

────────────────────────────────────────
B. 📱 UI PAGES (Static UI first)
────────────────────────────────────────
Generate the Flutter UI for the following pages:

1. **ProfileUpdatePage**
   Shows a list:
   - Name
   - Email
   - Change password
   - Account Information (Nested list)
   - Avatar upload (tap → choose file)
   - Do not add delete avatar yet

2. **UpdateFieldPage**
   A generic page used for:
   - Update Name
   - Update Email

3. **UpdatePasswordPage**
   Fields:
   - current password (optional? depends on repo)
   - new password
   - confirm password

4. **UpdateAccountInfoPage**
   Fields:
   - Full Name
   - Phone Number
   - Gender (dropdown)
   - Date of Birth (date picker)
   Use static example values.

5. **UploadAvatarPage**
   - Image picker preview
   - Upload button
   - Show upload progress (%) using onSendProgress