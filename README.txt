= Webrat Story Steps collection

* http://www.movesonrails.com/articles/2008/08/19/webrat-story-steps

== DESCRIPTION:

Author:      Andre Foeken - Nedap
Article:     http://www.movesonrails.com/articles/2008/08/19/webrat-story-steps
Bug Tracker: http://nedaphealthcare.lighthouseapp.com/projects/15738/home

Selection of commonly used steps to speed up rspec story creation.

Install:

- Rspec
- Rspec On Rails
- Chronic

- This plugin
  CLONE @ git://github.com/foeken/webrat_story_steps.git

- Adapted Webrat plugin (http://github.com/foeken/webrat)
  CLONE @ git://github.com/foeken/webrat.git

Installation:

- Install my forked Webrat in your vendor/plugins directory
- Copy the webrat_story_steps directory to your vendor/plugins directory
- Run ./script/generate stories

- Start writing stories!

* Read the Wiki for all the possible steps
* Make sure that you read the stories/custom_steps/required_model_attributes.rb file to prevent any validation warnings!

Customizing:

You can add you own steps (that apply ONLY to your app) to the custom_steps directory that was generated. Just as you would have added normal Rspec steps. Please submit any general steps!

Note that these steps should mix with any steps you have already defined as long as the step group names differ.

Selenium:

Read the SELENIUM file for more info on how to drive selenium with these same steps! (No changes required to your stories)
