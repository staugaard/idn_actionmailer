Gem::Specification.new do |s|
  s.name = "idn_actionmailer"
  s.version = "0.2"
  s.date = "2008-05-27"
  s.summary = "monkey path for ActionMailer to support international domain names"
  s.email = "mick@staugaard.com"
  s.homepage = "http://github.com/staugaard/idn_actionmailer"
  s.description = "monkey path for ActionMailer to support international domain names"
  s.has_rdoc = false
  s.authors = ["Mick Staugaard"]
  s.files = ["History.txt", "README.txt", "Rakefile", "idn_actionmailer.gemspec", "lib/idn_actionmailer.rb"]
  s.test_files = ["test/test_idn_actionmailer.rb", "test/fixtures/test_mailer/signed_up_with_url.erb", "test/fixtures/test_mailer/signed_up_with_url.rhtml"]
  s.rdoc_options = ["--main", "README.txt"]
  s.extra_rdoc_files = ["History.txt", "README.txt"]
  s.add_dependency("actionmailer", [">= 2.0.2"])
  s.add_dependency("unicode", [">= 0.1"])
  s.add_dependency("punycode4r", [">= 0.2.0"])
end