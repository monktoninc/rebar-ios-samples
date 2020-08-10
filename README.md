# Rebar iOS Samples

This repository adds sample apps for Rebar for iOS. These samples will demonstrate the basic capabilities of building on top of Monkton's Rebar trusted mobile development platform.

Your organization can leverage these templates to build your own apps built on top of Rebar.

If you would like more information on Rebar, please email support@monkton.io and we will get back to you.

Please visit our website https://monkton.io for more information on Rebar and what it does.

# Grabbing the project

To download from Git: execute the command `git clone https://github.com/monktoninc/rebar-ios-samples.git`

Once the project is downloaded, follow the instructions on running `setup-project.sh` as documented below.

# Configuring Project

Rebar can be easily configured with by running the `./setup-project.sh` command at the root of the project. This will replace all the necessary configuration settings for a seamless setup.

Setup will prompt for:

* Bundle Identifier: The identifier used within the app
* Team Identifier: The team identifier (app prefix) used by the app, found in the Developer Portal
* API Url: The API Endpoint of your application, eg: https://api.example.com/v1
* URL Scheme: The URL Scheme for the app to be opened by other apps

After running this script, the bulk of the setup is now done. Developers may need to chose the provisioning profile. 

## Runtime Error

If the script will not run, permissions may need to be modified `chmod +x setup-project.sh`

# Project Customization

## Adding the Rebar SDK

Your organization must obtain the latest Rebar iOS SDK from Monkton. Add the zip to a folder under the `Rebar-Template` directory named `rebar-sdk`. From here, unzip. You should see two directories, `Production` and `Development`.

## Swid Tag Configuration

Part of NIAP App 1.3 is the inclusion of Swid Tags for software identification. This sample includes the 

* `app.swidtag` file for embedding within your app
* `helpers/swid-generate` to fill out the Swid tag

The `swid-generate` script, which is invoked with the `Build Actions` in the project, will look for the `CFBundleShortVersionString` value in your app's PList and embed that within the Swid tag.

Your organization must customize the Swid tag for deployment. 
