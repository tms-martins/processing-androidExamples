import android.media.MediaRecorder;

final static String permissionRecordAudio = "android.permission.RECORD_AUDIO";

MediaRecorder mRecorder = null;

int amplitude = 0;
int smoothAmplitude = 0;

void permissionAudioGranted(boolean granted) {
  if (granted) 
    startRecorder();
  else
    println("ERROR: you need to grant the app permission to record audio.");
}

boolean startRecorder() {
  // The app needs to explicitly request permission to record audio.
  // If the permission hasn't been previously granted, prompt the user and afterwards call permissionContactsGranted().
  // This will in turn call startRecorder() again, so this test yields "true" and the audio recorder can be initialized.
  if (!hasPermission(permissionRecordAudio)) {
    requestPermission(permissionRecordAudio, "permissionAudioGranted");
    return false;
  }
  
  if (mRecorder == null) {
    println("Creating MediaRecorder");
    mRecorder = new MediaRecorder();
  }
  else {
    println("MediaRecorder exists already, resuming, returning true");
    mRecorder.resume();
    return true;
  }
  
  println("Configuring MediaRecorder: setting audio source");
  mRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
  println("Configuring MediaRecorder: setting output format");
  mRecorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);
  println("Configuring MediaRecorder: setting encoder");
  mRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
  println("Configuring MediaRecorder: setting output file");
  mRecorder.setOutputFile("/dev/null"); 
  try {
    println("Preparing MediaRecorder...");
    mRecorder.prepare();
  } 
  catch (IllegalStateException e) {
    e.printStackTrace();
    mRecorder = null;
    return false;
  } 
  catch (IOException e) {
    e.printStackTrace();
    mRecorder = null;
    return false;
  }

  try {
    println("Starting MediaRecorder...");
    mRecorder.start();
  } 
  catch (IllegalStateException e) {
    e.printStackTrace();
    mRecorder = null;
    return false;
  } 
  println("Recorder started!");
  return true;
}

void stopRecorder() {
  if (mRecorder != null) {
    try {
      println("Stopping MediaRecorder...");
      mRecorder.stop();
    } 
    catch (IllegalStateException e) {
      println("MediaRecorder: Illegal State");
      println(e.getMessage());
      mRecorder = null;
    }
    catch (RuntimeException e) {
      println("MediaRecorder: Nothing was recorded.");
    }
    catch (Exception e) {
      println("MediaRecorder: Unknown Exception");
      println(e.getMessage());
      e.printStackTrace();
      mRecorder = null;
    }
  }

  if (mRecorder != null) {
    try {
      println("Resetting MediaRecorder...");
      mRecorder.reset();
    }
    catch (Exception e) {
      println("MediaRecorder: Exception while resetting");
      println(e.getMessage());
      e.printStackTrace();
      mRecorder = null;
    }
  }
}

void updateRecorder() {
  if (mRecorder == null) return;

  // decay the current amplitude smoothly
  if (smoothAmplitude > 0) {
    smoothAmplitude *= 0.9;
  }
  // get the current maximum amplitude and
  // update the smooth amplitude
  amplitude = (int)mRecorder.getMaxAmplitude();
  if (amplitude > smoothAmplitude) {
    smoothAmplitude = amplitude;
  }
}