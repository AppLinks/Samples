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
import android.content.Intent;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.TextView;
import bolts.*;
import com.facebook.FacebookAppLinkResolver;
import com.facebook.Settings;

class PasteboardListRowAdapter extends ArrayAdapter<String> {
    public PasteboardListRowAdapter(Context context, String[] objects) {
        super(context, R.layout.list_item_row, 0, objects);
    }

    @Override
    public View getView(final int position, View convertView, final ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) this.getContext()
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        final View rowView = inflater.inflate(R.layout.list_item_row, parent, false);
        TextView title = (TextView) rowView.findViewById(R.id.titleTextView);
        TextView subtitle = (TextView) rowView.findViewById(R.id.subtitleTextView);
        final String link = this.getItem(position);
        final Uri uri = Uri.parse(link);
        title.setText(uri.getHost());
        if (uri.getQuery() != null) {
            subtitle.setText(uri.getPath() + "?" + uri.getQuery());
        } else {
            subtitle.setText(uri.getPath());
        }

        Button detailButton = (Button) rowView.findViewById(R.id.detailButton);
        detailButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent goToDetail = new Intent(getContext(), AppLinkDetail.class);
                goToDetail.setData(uri);
                getContext().startActivity(goToDetail);
            }
        });

        title.setClickable(true);
        title.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openAppLink(link);
            }
        });

        subtitle.setClickable(true);
        subtitle.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openAppLink(link);
            }
        });
        return rowView;
    }

    // Navigate to an app link
    private void openAppLink(String link) {
        // For better performance, we encourage you to use an indexing service. One such service is offered by Facebook.

        FacebookAppLinkResolver resolver = new FacebookAppLinkResolver();
        AppLinkNavigation.setDefaultResolver(resolver);
        // By default the app link resolver is WebViewAppLinkResolver
        // If you don't want to append more information on the link, this line is all you need.
        AppLinkNavigation.navigateInBackground(getContext(), link);
    }

}
