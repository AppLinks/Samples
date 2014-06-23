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
import android.widget.*;
import java.util.ArrayList;


public class DefinitionActivity extends PrimeNumberActivity {
    private static final int MAX_EXAMPLE_NUMBER = 12;
    private static final Uri COPY_LINK_URI = Uri.parse(APPLINK_URL_BASE + "/definition");

    @Override  //PrimeNumberActivity
    public Uri getCopyLink() {
        return COPY_LINK_URI;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        // This is a static view. So there is not need to parse AppLink in order to
        // get parameters to determine how the view is.  This is the simplest cases.

        super.onCreate(savedInstanceState);
        setContentView(R.layout.definition);

        final ArrayList<Integer> primeNumbers = new ArrayList<Integer>();
        final ArrayList<Integer> nonPrimeNumbers = new ArrayList<Integer>();

        // generate examples
        boolean filled = false;
        int num = 0;
        while (!filled) {
            if (PrimeNumberHelper.isPrimeNumber(num) && primeNumbers.size() < MAX_EXAMPLE_NUMBER) {
                primeNumbers.add(num);
            } else if (nonPrimeNumbers.size() < MAX_EXAMPLE_NUMBER) {
                nonPrimeNumbers.add(num);
            }

            if (nonPrimeNumbers.size() == MAX_EXAMPLE_NUMBER && primeNumbers.size() == MAX_EXAMPLE_NUMBER) {
                filled = true;
            } else {
                num ++;
            }
        }

        GridView primeExamplesGridView = (GridView) findViewById(R.id.primeExamplesGrid);
        GridView nonPrimeExamplesGridView = (GridView) findViewById(R.id.nonPrimeExamplesGrid);
        primeExamplesGridView.setAdapter(
                new ArrayAdapter<Integer>(this, R.layout.examples_grid_item, primeNumbers));
        nonPrimeExamplesGridView.setAdapter(
                new ArrayAdapter<Integer>(this, R.layout.examples_grid_item, nonPrimeNumbers));

        primeExamplesGridView.setOnItemClickListener (new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent(getApplicationContext(), NumberDetailActivity.class);
                intent.putExtra(NUMBER_KEY, primeNumbers.get(position));
                startActivity(intent);
            }
        });

        nonPrimeExamplesGridView.setOnItemClickListener (new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent(getApplicationContext(), NumberDetailActivity.class);
                intent.putExtra(NUMBER_KEY, nonPrimeNumbers.get(position));
                startActivity(intent);
            }
        });

    }
}
