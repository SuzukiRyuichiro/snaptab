# AI Enabled expense tracking for lazy people

## The pain
Good old expense tracking app tries to help you to make it easy to input the expense data by connecting to payment services, etc. However, that path is still requires dicipline. When you split a dinner with friends, importing the recipt doesn't fully convey how much you spent. If you also split expenses with house mates, also that is not a true reflection of what you are paying. Also, input method is often filling out forms, editing forms that couldn't categorize the payment that was auto imported from bank API connection.

## The solution
The app have simple input method, recipt pictures and voice (or text chat). We allow vague inputs, unformatted inputs, still it would categorize and input the data straight into the expense app. No need to touch keyboards.

### The recipt way
If you are on a grocery run, all you have to do is open the app, and take the photo. OCR and visual models would determine the price and what you spent on, and will automatically add it to your expense. If the price should be split between your housemates, you just select split by and put a number (or set default, like 2 for a couple, or 5 for house mates). These are useful for many different payment methods, as all you need is just recipt.

### The voice way
If you are quickly eating a Ramen or some places that does not offer payments online payment or doesn't print recipt. You can audio input easily by speaking to it what you spent it on. You can also tell them the total bill and split it by how much. 

## Differentiaing factors

Money forward ME
- They have good integration with Banks, Security copanies, but the issue is when there is two payments for cards. When you use your debit card from bank as well as credit card, 1. Credit card payment will be counted as big single spending in a month recorded to the bank, without any breakdown of what consists that big payment. 2. but if you disconnect the bank's integration, you would lose track of your recurring rent payment, etc straight from your bank. Also, importing CSVs are good for credit card spending data, but it's a bit of a hassle to export and import, sort each spending out into category.

Zaim
- Zaim is also the same, it have a very decent memo feature, tracking feature with auto import, but that is alot. 

This app will position itself as just spending tracking. We don't really need to account for incomes, capital gains. The target audience is people in their teens or twenties, who just need to start keep track of how much is going out of your wallet. However, they are not diciplined enough or lazy to manually edit many things. (this could justify not even confirming the input. Just say it and forget it)


## User journey

### 1 
- User opens the app
- Clicks on capture a recipt
- Takes the photo, it will automatically record it, and user doesn't have to confirm it (they will be shown a dialogue of hte summary)
- Closes the app.

### 2
- User opens the app
- Clicks on capture a recipt
- Takes the photo, user have the option to "add context"
- This will prompt the user with "split by X" for a group dinner or they have the option to speak into the app say stuff like "The ony thing I ate was Mapodofu and the beer", which then will take it into account for what the spending of the person was
- Closes the app.

### 3
- User opens the app
- Click on the voice input button
- Start talking like "I just had a bowl of ramen. It was 980 yen"
- App will add that info while showing a dialogue of how much was recorded

### 4
- User opens the app
- Go to summary, where they can see a pie chart of how much you are spending on each category
	- food (groceries and eating out incuded)
	- transportation (train fees, bicycle repair fees, bus trips, etc)
	- health and fitness (drugs, runnign gears, gym subscription)
	- clothes and beauty 
	- rent and other utilities (wifi fees, you can also consider AI subscriptions here)
	- insurance
	- education (educational books, online courses)
	- appliances (dish soaps, toilet papers)
	- tax
	- entertainment (trip to themeparks, netflix subscription)
	- misc

### 5
- In case in journeys #2 or #3, user's initial input would automatically added as expense, but if the user notices that the dialog is wrong, user can edit that (either by voice or manual input)
- 

## Technical considerations

1. Do I need queues? => Perhaps not right now, not necessary. THe OCR and visual recipt reading would be done in the foreground since the user needs to quickly look at the result of the scan.

2. Do I need cache? => would be nice since loading the expense data would be no-high updated stuff.
