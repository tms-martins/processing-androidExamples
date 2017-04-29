import android.media.MediaRecorder;

private MediaRecorder mRecorder = null;

int amplitude = 0;
int smoothAmplitude = 0;

boolean startRecorder() {
  if (mRecorder == null) {
    println("Creating MediaRecorder");
    mRecorder = new MediaRecorder();
  }
  println("Configuring MediaRecorder");
  mRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
  mRecorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);
  mRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
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