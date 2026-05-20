| Description | Controller | Verb | Path |
|---|---|---|---|
| User can see two big CTA buttons for adding expense via scan or voice | home | GET | /expenses/new |
| User can capture receipt and automatically create expense | expenses | POST | /expenses |
| User can capture receipt and split expense by X (Part of the flow of adding a new) | expenses | GET | /expenses/capture |
| User can capture receipt and explain expense via voice | expenses | GET | /expenses/new |
| User can speak and automatically create expense via voice input | expenses | POST | /expenses |
| User can view spending dashboard | expenses | GET | /expenses |
| User can edit an expense that scanned incorrectly | expenses | PATCH | /expenses/{id} |
| User can see their subscriptions | settings | GET | /settings |
| User can see their default currency | settings | GET | /settings |
| User can update their default currency although it would archive all previous expenses | settings | POST | /settings |
| User can create a recurring subscription | subscriptions | POST | /subscriptions |
| User can edit existing recurring expense | subscriptions | PATCH | /subscriptions/{id} |
| User can delete a recurring expense | subscriptions | DELETE | /subscriptions/{id} |
