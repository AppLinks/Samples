/*
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

package org.applinks.AppLinkPasteboardSampleApp;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import com.facebook.Settings;

import java.net.URISyntaxException;

public class Pasteboard extends Activity {
    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        // If you don't use Facebook indexing, you have no dependency on facebook sdk to use App Link.
        // As this sample application is just showing the cases of using facebook indexing, we are not following
        // the normal facebook sdk integration paradigm (config app id in manifest xml and call UILifecycleHelper
        // in Activities), we just set the minimum information needed: application id and client token explicitly.
        Settings.setApplicationId(getString(R.string.fb_app_id));
        Settings.setClientToken(getString(R.string.fb_client_token));

        // fill the list view
        this.loadContent();

        final Pasteboard thisActivity = this;
        Button addNew = (Button) findViewById(R.id.addButton);
        addNew.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                TextView newLink = (TextView) findViewById(R.id.newLinkTextField);
                String newLinkString = newLink.getText().toString().trim();
                if (newLinkString.length() > 0) {

                    LinksStore store = LinksStore.getInstanceWithContext(v.getContext());

                    try {
                        store.validate(newLinkString);
                    } catch (URISyntaxException e){
                        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(v.getContext());
                        alertDialogBuilder.setMessage(e.getMessage() + "\ninput: " +e.getInput());
                        alertDialogBuilder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.cancel();
                            }
                        });
                        alertDialogBuilder.create().show();
                        return;
                     }

                    store.append(newLinkString);

                    runOnUiThread(new Runnable() {
                                      @Override
                                      public void run () {
                                          thisActivity.loadContent();
                                      }
                                  });
                }
            }
        });
    }

    private void loadContent() {
        ListView listView = (ListView) findViewById(R.id.applinkListView);
        String[] links = LinksStore.getInstanceWithContext(this).getList();
        PasteboardListRowAdapter adapter = new PasteboardListRowAdapter(this, links);
        listView.setAdapter(adapter);
    }
}
