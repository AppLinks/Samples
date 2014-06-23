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

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;


public class NumberDetailActivity extends PrimeNumberActivity {
    private int currentNum = 0;
    private TextView numView = null;
    private TextView detailView = null;
    private TextView assertView = null;

    @Override  //PrimeNumberActivity
    public Uri getCopyLink() {
      return Uri.parse(APPLINK_URL_BASE + "/number?id=" + String.valueOf(currentNum));
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.number_detail);

        // the number that passed in from Examples in Definition.  Integer.MIN_VALUE is not one of the examples.
        int passedInNumber = getIntent().getIntExtra(NUMBER_KEY, Integer.MIN_VALUE);

        if (passedInNumber == Integer.MIN_VALUE) {
            // NOTE:
            // Here we are going to get the information that is passed in from the intent generated from the App Link.
            // App Links preserve all the data that you encoded into the original web URL, and you can get the original
            // web URL from the extras in the intent bundle, it is in the bundle field al_applink_data::target_url.

            Bundle appLinkData = getIntent().getBundleExtra("al_applink_data");
            if (appLinkData != null) {
                String targetURLString = appLinkData.getString("target_url");
                Uri targetURL = Uri.parse(targetURLString);
                try {
                    passedInNumber = Integer.parseInt(targetURL.getQueryParameter("id"));
                } catch (NumberFormatException e) {
                    passedInNumber = (int)(Math.random() * 100);
                }
            } else {
                // if we cannot find any al_applink_data form intent, probably this action is not started by AppLink.
                // In our case, we just show a random number.
                passedInNumber = (int)(Math.random() * 100);
            }
        }


        // render the view
        numView = (TextView) findViewById(R.id.numView);
        detailView = (TextView) findViewById(R.id.detailTextView);
        assertView = (TextView) findViewById(R.id.assertTextView);

        updateView(passedInNumber);

        Button defButton = (Button) findViewById(R.id.definitionButton);
        defButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(v.getContext(), DefinitionActivity.class);
                startActivity(intent);
            }
        });

        Button prevButton = (Button) findViewById(R.id.prev);
        Button nextButton = (Button) findViewById(R.id.next);

        prevButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (Integer.MIN_VALUE < currentNum) {
                    updateView(currentNum - 1);
                }
            }
        });
        nextButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (Integer.MAX_VALUE > currentNum) {
                    updateView(currentNum + 1);
                }
            }
        });
    }

    private void updateView(int num) {
        currentNum = num;
        numView.setText(String.valueOf(num));
        String reason = PrimeNumberHelper.whyNotPrimeNumber(num);
        if (reason != null) {
            assertView.setText("is NOT Prime");
            detailView.setText(reason);
        } else {
            assertView.setText("is Prime");
            detailView.setText("");
        }
    }
}
