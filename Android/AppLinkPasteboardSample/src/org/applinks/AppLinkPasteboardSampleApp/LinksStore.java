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

import android.content.Context;
import android.content.SharedPreferences;
import android.net.Uri;
import android.util.Patterns;

import java.net.URISyntaxException;
import java.util.ArrayList;

public class LinksStore {
    private static LinksStore instance = null;
    Context context = null;
    private static final String StorageName = "AppLinkPasteboard";

    public synchronized static LinksStore getInstanceWithContext(Context context) {
        if (instance != null) {
            instance.context = context;
            return instance;
        }
        instance = new LinksStore();
        instance.context = context;
        return instance;
    }

    public String[] getList() {
        synchronized (this) {
            SharedPreferences storage = context.getSharedPreferences(StorageName, 0);
            String linksString = storage.getString("links", "");
            String[] links = linksString.split("\t");
            ArrayList<String> linkArray = new ArrayList<String>();
            for (String link : links) {
                if (link.trim().length() > 0) {
                    linkArray.add(link);
                }
            }
            String[] arr = new String[linkArray.size()];
            return (String[]) linkArray.toArray(arr);
        }
    }

    public void append(String newLink) {
        synchronized (this) {
            SharedPreferences storage = context.getSharedPreferences(StorageName, 0);
            String links = storage.getString("links", "");
            if (links.trim().length() > 0) {
                links = links + "\t" + newLink;
            } else {
                links = newLink;
            }
            SharedPreferences.Editor editor = storage.edit();
            editor.putString("links", links);
            editor.commit();
        }
    }

    public void delete(String link) {
        synchronized (this) {
            SharedPreferences storage = context.getSharedPreferences(StorageName, 0);
            String linksString = storage.getString("links", "");
            String[] links = linksString.split("\t");
            StringBuilder sb = new StringBuilder();
            for (String l : links) {
                if (!l.equals(link) && l.length() > 0) {
                    sb.append(l);
                    sb.append("\t");
                }
            }
            SharedPreferences.Editor editor = storage.edit();
            editor.putString("links", sb.toString());
            editor.commit();
        }
    }

    public void validate(String link) throws URISyntaxException {
        Uri uri = Uri.parse(link);
        if (!Patterns.WEB_URL.matcher(link).matches()) {
           throw new URISyntaxException(link, "Not a valid web URL.");
        }
        if (uri.getScheme() == null) {
            throw new URISyntaxException(link, "Url scheme is absent.");
        }
    }
}
