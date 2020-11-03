# Setting up an In-App campaign for Onboarding

Sample project demonstrating how a customer can show an In-App campaign to all users who first install the app. 

## Setup

1. In `AppDelegate.swift` replace `YOUR_APP_KEY` with your Localytics app key.
2. Build and run.

## Integration information
The Localytics SDK provides a number of routes to support this integration. The major feature used here is an API labeled `forceInAppMessageDisplay`. This method will force the display of a full screen In-App creative for a specified creative, or html file. The variations on the method take the following potential parameters:

 - File: A file currently existing on device. This file must be a local resource living within a valid app directory, or stored as an android-asset. 
 - Campaign Id and Creative Id. This can refer to a campaign currently existing in the Localytics Dashboard. This campaign will be immediately downloaded and shown by the SDK. 

We suggest using this method if you have an onboarding use case where you would like your users to be prompted immediately.

## Limitations
This integration pathway has a number of limitations. The following willl all apply: 

 - No In-App will be shown if an In-App is already showing
 - No In-App will be shown if the input parameters are invalid. This may occur if:
	 - The file is not present on disk or is empty.
	 - The file is not an html file, or a zip file containing a file named `index.html` inside of it.
	 - The campaign ID or creative ID passed in don't match a valid campaign in the Localytics Dashboard
	 - The campaign ID or creative ID do not belong to the app key being used within this app.
 - No standard conversion events will be tagged for this In-App display. This means you will not see metrics on sends or clicks within the Localytics Dashboard.
- Frequency Capping defined in the Localytics Dashboard does not apply to this campaign. The SDK will always show this campaign if it can resolve the creative.
- Audience Segmentation defined  in the Localytics Dashboard does not apply to this campaign. By using this API, you are qualifying the user for this campaign.
-   Any of the MessagingListener methods that request information about showing an In-App will not be triggered. Namely:
	- `localyticsShouldShowInAppMessage`
	- `localyticsWillDisplayInAppMessage`
- As a factor of the above, all In-App container modifications must be supplied in the html file itself as specified in [our documentation](https://help.uplandsoftware.com/localytics/dev/android.html#customize-in-app-html)

## Tracking this campaign
Because no conversion events will be tagged for this impression, it can be difficult to understand how your users interacted with your onboarding campaign. In this scenario, we suggest defining your own conversion metrics. 
In this example, the [creative](Onboarding/Onboarding-Sample.zip) uses the built in `localytics` Javascript API provided by the SDK to  define the following metrics:

 - Carousel Button Clicked: To understand how far through the creative a user clicked, or if they just dismissed the campaign immediately. 
 - Onboarding Viewed: To understand that a user interacted with the campaign. The attribute `Push Prompt` on this campaign determines if the user converted on the desired behavior of looking at the push notification prompt. 