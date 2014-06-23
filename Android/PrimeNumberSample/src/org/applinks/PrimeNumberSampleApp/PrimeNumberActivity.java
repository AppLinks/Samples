/**
 * Copyright 2010-present Facebook.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


package org.applinks.PrimeNumberSampleApp;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.DialogInterface;
import android.net.Uri;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Toast;

public abstract class PrimeNumberActivity extends Activity {
    protected final static String NUMBER_KEY = "primenumber.number";
    protected final static String APPLINK_URL_BASE = "http://primenumber.parseapp.com";

    /**
     * Generate a Link for current activity view, that user can copy paste to other application to share.
     *
     * @return  The Uri that represents current activity view.
     */
    protected abstract Uri getCopyLink();

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.action_menu, menu);
        return true;
    }
    @Override
    public boolean onOptionsItemSelected (MenuItem item) {
        super.onOptionsItemSelected(item);
        switch (item.getItemId()) {
            case R.id.copyLinkMenuItem:
                ClipboardManager clipboard = (ClipboardManager) getSystemService(CLIPBOARD_SERVICE);
                ClipData clip = ClipData.newRawUri("Prime Number App Link", getCopyLink());
                clipboard.setPrimaryClip(clip);
                Toast toast = Toast.makeText(this, "App Link is copied in your clipboard", Toast.LENGTH_SHORT);
                toast.show();
                break;
        }

        return true;
    }
}
