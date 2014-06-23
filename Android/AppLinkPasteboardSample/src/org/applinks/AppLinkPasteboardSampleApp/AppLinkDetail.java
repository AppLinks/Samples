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
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

import bolts.*;
import com.facebook.*;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AppLinkDetail extends Activity {

    private AppLink resolvedAppLink = null;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(org.applinks.AppLinkPasteboardSampleApp.R.layout.detail);

        Settings.setApplicationId(getString(R.string.fb_app_id));
        Settings.setClientToken(getString(R.string.fb_client_token));

        final Uri uri = getIntent().getData();
        // final String link = uri.toString();
        TextView rawURL = (TextView) findViewById(R.id.rawURL);
        rawURL.setText(uri.toString());

        // raw URL and open in browser
        Button openInWebButton = (Button) findViewById(R.id.openInWebButton);
        openInWebButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent goWeb = new Intent(Intent.ACTION_VIEW);
                goWeb.setData(uri);
                startActivity(goWeb);
            }
        });

        final Button openResolvedButton = (Button) findViewById(R.id.openResolvedButton);
        openResolvedButton.setEnabled(false);
        // details of resolved link, this also demonstrated that how your app can resolve an app link
        // before user clicks on it.
        new WebViewAppLinkResolver(this).getAppLinkFromUrlInBackground(uri)
                .continueWith(new Continuation<AppLink, AppLinkNavigation>() {
                    @Override
                    public AppLinkNavigation then(Task<AppLink> task) {
                        resolvedAppLink = task.getResult();
                        // there can be many matching targets possible on one device.
                        List<AppLink.Target> targets = resolvedAppLink.getTargets();
                        List<Map<String, String>> data = new ArrayList<Map<String, String>>();
                        for (AppLink.Target t : targets) {
                            Map<String, String> map = new HashMap<String, String>();
                            List<String> filters = new ArrayList<String>();
                            if (t.getUrl() != null) {
                                filters.add("url: " + t.getUrl().toString());
                            }
                            if (t.getClassName() != null && t.getClassName().length() > 0) {
                                filters.add("class: " + t.getClassName());
                            }
                            String appName = t.getAppName() == null ? "" : " <" + t.getAppName() + ">";
                            map.put("name", "package: " + t.getPackageName() + appName);
                            map.put("info", TextUtils.join("; ", filters));
                            data.add(map);
                        }
                        final SimpleAdapter adapter = new SimpleAdapter(getApplicationContext(), data,
                                android.R.layout.simple_list_item_2,
                                new String[] {"name", "info"},
                                new int[] {android.R.id.text1, android.R.id.text2});
                        final ListView list = (ListView) findViewById(R.id.listView);
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                list.setAdapter(adapter);
                                if (adapter.getCount() > 0) {
                                   openResolvedButton.setEnabled(true);
                                }
                            }
                        });
                        return null;
                    }
                });

        openResolvedButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (resolvedAppLink == null) {
                    return;
                }
                (new AppLinkNavigation(resolvedAppLink, new Bundle(), new Bundle())).navigate(v.getContext());
            }
        });

        final TextView graphApiResponseView = (TextView) findViewById(R.id.graphApiResponseView);
        Bundle indexGraphApiParam = new Bundle();
        indexGraphApiParam.putString("ids", uri.toString());
        indexGraphApiParam.putString("type", "al");
        new Request(
                null,  // as we set Application ID and Client Token, we don't need a user Session
                "",
                indexGraphApiParam,
                HttpMethod.GET,
                new Request.Callback() {
                    public void onCompleted(Response response) {
                        graphApiResponseView.setText(response.toString());
                    }
                }
        ).executeAsync();

        // delete button
        Button deleteButton = (Button) findViewById(R.id.deleteButton);
        deleteButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                LinksStore.getInstanceWithContext(v.getContext()).delete(uri.toString());
                Intent intent = new Intent(getApplicationContext(), Pasteboard.class);
                startActivity(intent);
            }
        });
    }
}
