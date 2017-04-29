import android.content.Context;
import android.os.Vibrator;

Vibrator buzz;

void initBuzz() {
  buzz = (Vibrator)getActivity().getSystemService(Context.VIBRATOR_SERVICE);
}