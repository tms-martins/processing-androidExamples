import android.os.Environment;
import android.content.res.Resources;
import android.content.res.AssetFileDescriptor;
import android.media.AudioManager;
import android.media.AudioAttributes;
import android.media.MediaPlayer;

class PAAudioPlayer extends MediaPlayer {
  PAAudioPlayer() {
  }
  
  boolean loadFile(PApplet app, String fileName) {
    println("PAAudioPlayer: loading <" + fileName + "> from assets");
    AssetFileDescriptor afd;
    try {
      afd = app.getActivity().getAssets().openFd(fileName);
    } catch (IOException e) {
      println("PAAudioPlayer: ERROR loading <" + fileName + "> from assets");
      println(e.getMessage());
      return false;
    }
    
    if (afd == null) {
      println("PAAudioPlayer: ERROR, asset <" + fileName + "> doesn't exist!");
      return false;
    }
    
    try {
      this.setDataSource(afd.getFileDescriptor(),afd.getStartOffset(),afd.getLength());  
      // Selects the audio stream for music/media
      this.setAudioAttributes(
            new AudioAttributes
               .Builder()
               .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
               .build());
      this.prepare();
      println("PAAudioPlayer: Loaded OK");
      return true;
    } 
    catch (IOException e) {
      println("PAAudioPlayer: error preparing player\n" + e.getMessage());
      return false;
    }
  }

  boolean loadFileSDCard(String fileName) {
    String fullPath = Environment.getExternalStorageDirectory().getAbsolutePath();
    fullPath += "/" + fileName;
    return loadFileFullPath(fullPath);
  }

  boolean loadFileFullPath(String fileName) {
    println("PAAudioPlayer: loading <" + fileName + ">");
    try {
      this.setDataSource(fileName);   
      // Selects the audio stream for music/media
      this.setAudioAttributes(
            new AudioAttributes
               .Builder()
               .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
               .build());
      this.prepare();
      println("PAAudioPlayer: Loaded OK");
      return true;
    } 
    catch (IOException e) {
      println("PAAudioPlayer: error preparing player\n" + e.getMessage());
      return false;
    }
  }
  
  void play() {
    println("PAAudioPlayer.play()");
    if (this.isPlaying()) {
      this.seekTo(0);
    }
    this.start();
  }
}
