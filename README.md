# Product List Application

This application provides users with a platform to perform operations such as searching, sorting, and filtering starting from the product listing screen. Additionally, users can update their cart and favorite lists, and they can view the last state of these lists when the application is reopened.


# Features

## Important Notes
- MVVM Architecture: The application is developed using the Model-View-ViewModel (MVVM) architecture, ensuring clean and manageable code.

- Service Integration: The DummyJson Products API enables at least one service structure to be used in the application.

- User Experience: The application prioritizes user experience by offering easy navigation, effective search, and intuitive user interface.
- Product Listing Screen Users: can perform various operations starting from the product listing screen, such as searching, sorting, and filtering.
- Cart and Favorite Management: Users can add, update, and remove products from their cart and favorite lists. These actions are saved, and users can view the last state of their lists when the application is reopened.
- Filtering Screen: The filtering screen allows users to filter products based on specific criteria. A representative design can be viewed here.
- Flow After Clicking the Share Button: The flow after clicking the share button is left to the user and can be developed according to the application requirements.

## Implementation Details

### Technologies Used

- Swift programming language.
- UIKit framework for building the user interface.
- GitHub API for fetching repository data.
- User Defaults for storing favorite repositories.

### User Defaults

- User Defaults is used to store the list of favorite repositories. When a user adds or removes a repository from favorites, the changes are reflected in the User Defaults to persist the user's preferences across app sessions.

## How to Run the Project

1. Clone the repository.
2. Open the Xcode project file.
3. Build and run the application on a simulator or device.

Feel free to explore and enhance the app as you wish. Contributions are welcome!

## Author

Onur

## License

This project is licensed under the [MIT License](LICENSE).
