
# processing-androidExamples
A collection of examples for Processing Android mode, some of which use the [Ketai library](https://github.com/ketai/ketai).

| Currently tested with      | version |
| ---------------------------|---------| 
| Processing IDE             | 3.5.3   |
| Android Mode               | 4.0.4   |
| Android SDK Tools          | 26.1.1  |
| Android SDK Platform tools | 28.0.2  |
| Android SDK Build Tools    | 26.0.3  |

## Overview

Each sketch contains a description on top of the main file, and the code is commented.
With few exceptions, most of the demonstrated functionality is kept in separate tabs, so it is easier to copy onto other sketches.

The sketches are organized into folders:
+ **Basic** - contains examples for a single functionality, which are easier to extend and combine
+ **Utility** - contains examples which can be useful for testing or improving the behaviour your sketch 
+ **Advanced** - contains examples combining different functionalities, as starting points for bigger sketches 

The basic examples include objects and methods to:
+ make a **phonecall**
+ send and receive **SMS**
+ list **contacts** and **installed apps**
+ list **WiFi networks** ~~and Bluetooth devices~~ (coming soon)
+ **play audio** from a file or synthesize an audio wave
+ convert **text to speech** and **speech to text**
+ show the user's **location** on a **simple map**

Have fun exploring, extending and combining!

## Sketch List

### Basic
+ **App_Lifecycle** - illustrates the basic lifecycle of a Processing for Android app.
+ **App_Orientation_and_Setup** - used to show that the sketch is re-started if the device's orientation changes.
+ **Audio_Player** - play sounds from audio files included in the sketch's data folder.
+ **Audio_Synth** - very basic (and slow) audio synthesis.
+ **Bluetooth_List** - scans for Bluetooth devices and displays a list of results.
+ **Contact_List** - retrieves a list of contacts (names) and phone numbers for + each contact, and prints the mout on the console.
+ **Installed_Apps** - lists all the apps installed on the device.
+ **Keyboard** - illustrates how to toggle (show/hide) the software keyboard and edit a string.
+ **Map_Basic** - exemplifies a basic location map, without resort to Google Maps or Play services.
+ **Noise_Meter** - a noise meter displaying amplitude numerically and also graphically (as a bar).
+ **Phonecall** - starting a phone call from within the sketch.
+ **Roly_Poly** - illustrates using the motion sensors to draw a 2D object which stays "upright".
+ **Sensors** - basic access to most of the phone's sensors.
+ **Sensors_Compass** - draws a compass needle pointing North.
+ **SMS_Receive** - illustrates receiving SMS messages within a sketch.
+ **SMS_Send** - illustrates sending SMS messages from within a sketch.
+ **Speech_to_Text** - illustrates speech-to-text (speech recognition).
+ **Text_to_Speech** - illustrates text-to-speech (speech synthesis).
+ **Vibrate** - triggers the device's vibrator when the screen is tapped.
+ **WiFi_List** - scans for and displays WiFi networks and their signal strengths.
+ **WiFi_List_More_Info** - like WiFI_List, but provides more info about each network.

### Utility

+ **App_Icon** - illustrates using a custom app icon.
+ **App_Lifecycle_Android_Calls** - illustrates when several functions of the Android Activity super class are called.
+ **App_Lifecycle_Thread** - uses a thread to handle logic updates even when the app is in the background.
+ **Audio_from_External_Storage** - shows how to load (and play) a sound from external storage, instead of the sketch's data folder.
+ **Image_from_External_Storage** - shows how to load an image from external storage, instead of the sketch's data folder.
+ **Ketai_Sensor_Display** - show all available sensors on a device (and their current values) via the Ketai library.
+ **Memory_Info** - shows how much memory is being used by the app, as well as the maximum amount of memory which can be used.
+ **Wake_Lock** - shows how to keep the device's screen enabled and bright while the app is running.

### Advanced

+ **Audio_Pentatonic** - a basic musical instrument with a pentatonic scale.
+ **Cardboard_Scene** - a stereo 3D scene a la cardboard, controlling the camera using the device's orientation.
+ **Map_GPS_Sound** - displays the user's location on a map and plays an audio sample depending on the user's proximity to a target
+ **Roly_Poly_3D** - illustrates using the motion sensors to draw a textured cube which keeps its orientation as the device is turned.
+ **Sensors_Compass_3D** - draws a 3D compass needle pointing North.
+ **WiFi_Heartbeat** - causes the device to vibrate rhythmically depending on the total amount of WiFi signal strengths.
+ **Woof** - plays increasingly persistent barking sounds until the phone is moved.