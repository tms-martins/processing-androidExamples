import android.view.inputmethod.InputMethodManager;
import android.content.Context;

void toggleKeyboard() {
  InputMethodManager imm = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
  imm.toggleSoftInput(0, 0);
}