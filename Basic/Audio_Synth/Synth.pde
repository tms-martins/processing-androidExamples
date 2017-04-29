import android.media.AudioManager;
import android.media.AudioTrack;
import android.media.AudioFormat;

int amplitude = 5000;
double frequency = 440.f;
double phase = 0.0;

AudioTrack audioTrack;
int sampleRate = 22050;
int buffSize;
short samples[];

void setupTrack() {
  if (audioTrack != null) {
    println("Track exists already, continuing...");
    
  } else {
    println("Creating track");

    buffSize = AudioTrack.getMinBufferSize(sampleRate, AudioFormat.CHANNEL_OUT_MONO, 
    AudioFormat.ENCODING_PCM_16BIT);

    audioTrack = new AudioTrack(AudioManager.STREAM_MUSIC, sampleRate, 
    AudioFormat.CHANNEL_OUT_MONO, 
    AudioFormat.ENCODING_PCM_16BIT, 
    buffSize, 
    AudioTrack.MODE_STREAM);

    samples = new short[buffSize];
  }

  audioTrack.play();
}

void updateTrack() {
  for (int i=0; i < buffSize; i++) { 
    samples[i] = (short) (amplitude*sin((float)phase));
    phase += TWO_PI*frequency/sampleRate;
  }
  audioTrack.write(samples, 0, buffSize);
}