# Rich Push Examples

Sample project demonstrating the integration of Localytics push messaging with custom
handling of particular rich push messages (e.g. images).

## Setup

1. In `AppDelegate.m` replace `YOUR-LOCALYTICS-APP-KEY` with your Localytics app key.
2. Build and run.

## Images

Send a push including the `mutable-content` key with a value of `1` and an `image_url` key with an HTTP image URL value.

## Actions

Send a push including an `action_category` key with the value `social` or `product`.