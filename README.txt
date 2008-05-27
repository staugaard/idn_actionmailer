= IdnActionmailer

idn_actionmailer is a gem that patches actionmailer to support recipients on domains with international characters.

This is done by encoding these domain names.

To use this gem in your rails project just install it and and " require 'idn_actionmailer' " to the bottom of your environment.rb.

I KNOW NOTHING ABOUT HOW THE ENCODING WORKS. I just patched the actionmailer code.