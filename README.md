# Delve

Dig deep into data.

-----

## Design Principles

I've documented a number of my thoughts on the decisions, tradeoffs and compromises I've made in
[DESIGN.md](./DESIGN.md). I encourage you to take a look.

## Goals

This application attempts to fulfill the following goals as per the _Zendesk Melbourne Coding Challenge_ instructions:

- Search data within the data sources (the JSON files in `data/`)
- Return results of the search queries
    - These results must be displayed in a "human readable format"
- Where data exists, related (or "associated") values should be included in results
    - eg. search organization by ID should return its tickets and users
- Any field should be searchable
    - Full value matching is OK
- Searching for empty fields should return matches
- Ideally, response times should not scale linearly
- Include a readme
    - With accurate usage instructions
    - With the assumptions and tradeoffs you've made

## Requirements

- Ruby 2.7.2

Previous versions of Ruby 2 should be fine, although it hasn't been tested there.

This project assumes you are running a Unix-like operating system (such as Mac OS or a flavour of Linux). Windows has
**not been tested**.

If this project needs to be run under Windows, using the [Windows Subsystem for Linux][WSL] is a great alternative.

### Getting Started

If you're using a Unix-like system, you probably have Ruby installed. To verify:

```bash
❯ ruby -v
ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-darwin19]
```

If you don't get a similar output, you can [install Ruby in a few different ways][Install Ruby]. Some preferred
instructions below.

### Installation

ℹ️ These installation instructions assume you're running Mac OS. Installing on a Unix-like system shouldn't be too
different.

### Prerequisites

ℹ️ If you have Ruby installed, you can skip to the [next section](#running-the-application).

1. Install [`brew`][brew]
  - Skip this step if you have a package manager already.
2. Install [`rbenv`][Install rbenv]: `brew install rbenv`
  - This will also install `ruby-build`, which allows you to install Ruby versions.
  - You can use your [package manager of choice](https://github.com/rbenv/rbenv#using-package-managers). 
3. Run `rbenv init`, and follow the instructions.
4. Close and open your terminal window so the changes take effect.
5. Install Ruby: `rbenv install 2.7.2`
6. Confirm Ruby is installed and running: `ruby --version`

#### Running the application

```bash
# clone the repo
`git clone git@github.com:AeroCross/delve.git`

# switch to the newly created directory
cd delve

# install dependencies
gem install bundler
bundle

# start the app
# you can remove the `bin/` part if you have `bin/` in your $PATH
bin/delve help
```

You should see the `help` section.

```bash
delve help
Delve, by Zendesk commands:
  delve fields SOURCE [users | tickets | organizations]              # List all the searchable fields in SOURCE
  delve help [COMMAND]                                               # Describe available commands or one specific command
  delve search SOURCE [users | tickets | organizations] FIELD VALUE  # Searches a FIELD for VALUE in SOURCE

Options:
  -r, [--raw=RAW]  # Use machine-parseable output
```

## Using the application

You can see different use cases below, along with their expected outcomes.

<details>
  <summary>Listing all searchable fields</summary>
  
  ```bash
  delve fields help
  Usage:
    delve fields SOURCE [users | tickets | organizations]

  Options:
    -r, [--raw=RAW]  # Use machine-parseable output

  List all the searchable fields in SOURCE
  ```

  ```bash
  delve fields tickets
┌───────────────────┐
│  Values           │
├───────────────────┤
│  _id              │
│  url              │
│  external_id      │
│  created_at       │
│  type             │
│  subject          │
│  description      │
│  priority         │
│  status           │
│  submitter_id     │
│  assignee_id      │
│  organization_id  │
│  tags             │
│  has_incidents    │
│  due_at           │
│  via              │
└───────────────────┘
  ```
</details>

<details>
  <summary>Search for a field</summary>

  ```bash
  delve search users _id 12
┌───────────────────┬───────────────────────────────────────────────────┐
│  Fields           │  Values                                           │
├───────────────────┼───────────────────────────────────────────────────┤
│  _id              │  12                                               │
│  url              │  http://initech.zendesk.com/api/v2/users/12.json  │
│  external_id      │  38899b1e-89ca-43e7-b039-e3c88525f0d2             │
│  name             │  Watkins Hammond                                  │
│  alias            │  Mr Sally                                         │
│  created_at       │  2016-07-21T12:26:16 -10:00                       │
│  active           │  false                                            │
│  verified         │  false                                            │
│  shared           │  false                                            │
│  locale           │  en-AU                                            │
│  timezone         │  United Kingdom                                   │
│  last_login_at    │  2012-12-29T07:59:56 -11:00                       │
│  email            │  sallyhammond@flotonic.com                        │
│  phone            │  8144-293-283                                     │
│  signature        │  Dont Worry Be Happy!                             │
│  organization_id  │  110                                              │
│  tags             │  ["Bonanza", "Balm", "Fulford", "Austinburg"]     │
│  suspended        │  false                                            │
│  role             │  end-user                                         │
└───────────────────┴───────────────────────────────────────────────────┘


Organizations

┌───────────────────────┬──────────────────────────────────────────────────────────────────────┐
│  Organization Fields  │  Values                                                              │
├───────────────────────┼──────────────────────────────────────────────────────────────────────┤
│  _id                  │  110                                                                 │
│  url                  │  http://initech.zendesk.com/api/v2/organizations/110.json            │
│  external_id          │  197f93c0-1729-4c82-9bb0-143e978f06ce                                │
│  name                 │  Kindaloo                                                            │
│  domain_names         │  ["translink.com", "netropic.com", "earthplex.com", "zilencio.com"]  │
│  created_at           │  2016-03-15T03:08:47 -11:00                                          │
│  details              │  Non profit                                                          │
│  shared_tickets       │  true                                                                │
│  tags                 │  ["Chen", "Melton", "Stafford", "Landry"]                            │
└───────────────────────┴──────────────────────────────────────────────────────────────────────┘


Tickets

┌───────────────────┬────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│  Ticket Fields    │  Values                                                                                                                                                        │
├───────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  _id              │  35072cd7-e343-4d8e-a967-bbe32eb019cb                                                                                                                          │
│  url              │  http://initech.zendesk.com/api/v2/tickets/35072cd7-e343-4d8e-a967-bbe32eb019cb.json                                                                           │
│  external_id      │  61749684-ca19-4589-8872-28b08317e395                                                                                                                          │
│  created_at       │  2016-04-07T05:09:10 -10:00                                                                                                                                    │
│  type             │  task                                                                                                                                                          │
│  subject          │  A Catastrophe in Macau                                                                                                                                        │
│  description      │  Eu adipisicing cillum et laborum exercitation fugiat mollit sunt eu non nulla tempor. Eu amet occaecat tempor incididunt adipisicing quis magna occaecat ut.  │
│  priority         │  low                                                                                                                                                           │
│  status           │  pending                                                                                                                                                       │
│  submitter_id     │  53                                                                                                                                                            │
│  assignee_id      │  12                                                                                                                                                            │
│  organization_id  │  116                                                                                                                                                           │
│  tags             │  ["California", "Palau", "Kentucky", "North Carolina"]                                                                                                         │
│  has_incidents    │  true                                                                                                                                                          │
│  due_at           │  2016-08-07T04:44:19 -10:00                                                                                                                                    │
│  via              │  chat                                                                                                                                                          │
└───────────────────┴────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
┌───────────────────┬───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│  Ticket Fields    │  Values                                                                                                                                   │
├───────────────────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  _id              │  774765fe-7123-4131-8822-e855d3cad14c                                                                                                     │
│  url              │  http://initech.zendesk.com/api/v2/tickets/774765fe-7123-4131-8822-e855d3cad14c.json                                                      │
│  external_id      │  52d8d6bf-e289-42f2-8f25-133040723f6c                                                                                                     │
│  created_at       │  2016-06-23T06:08:21 -10:00                                                                                                               │
│  type             │  task                                                                                                                                     │
│  subject          │  A Drama in Germany                                                                                                                       │
│  description      │  Pariatur veniam ipsum sit ullamco pariatur consectetur. Cillum laborum labore excepteur minim officia velit cupidatat esse labore enim.  │
│  priority         │  normal                                                                                                                                   │
│  status           │  pending                                                                                                                                  │
│  submitter_id     │  17                                                                                                                                       │
│  assignee_id      │  12                                                                                                                                       │
│  organization_id  │  124                                                                                                                                      │
│  tags             │  ["Mississippi", "Marshall Islands", "Şouth Dakota", "Montana"]                                                                           │
│  has_incidents    │  false                                                                                                                                    │
│  due_at           │  2016-08-06T06:16:27 -10:00                                                                                                               │
│  via              │  web                                                                                                                                      │
└───────────────────┴───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
┌───────────────────┬──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│  Ticket Fields    │  Values                                                                                                                                              │
├───────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  _id              │  50f3fdbd-f8a6-481d-9bf7-572972856628                                                                                                                │
│  url              │  http://initech.zendesk.com/api/v2/tickets/50f3fdbd-f8a6-481d-9bf7-572972856628.json                                                                 │
│  external_id      │  bf080887-362a-4311-90be-a23cbacf712f                                                                                                                │
│  created_at       │  2016-05-19T08:52:06 -10:00                                                                                                                          │
│  type             │  incident                                                                                                                                            │
│  subject          │  A Nuisance in Namibia                                                                                                                               │
│  description      │  Cillum laboris ad ex reprehenderit dolor velit tempor ea id ut veniam. Excepteur sunt ullamco qui est laboris veniam ut commodo tempor ea laborum.  │
│  priority         │  normal                                                                                                                                              │
│  status           │  pending                                                                                                                                             │
│  submitter_id     │  66                                                                                                                                                  │
│  assignee_id      │  12                                                                                                                                                  │
│  organization_id  │  125                                                                                                                                                 │
│  tags             │  ["Maine", "West Virginia", "Michigan", "Florida"]                                                                                                   │
│  has_incidents    │  false                                                                                                                                               │
│  due_at           │  2016-08-01T11:48:58 -10:00                                                                                                                          │
│  via              │  voice                                                                                                                                               │
└───────────────────┴──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
┌───────────────────┬──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│  Ticket Fields    │  Values                                                                                                                              │
├───────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  _id              │  be0f613a-e7f7-4833-9342-643b0d9b9fca                                                                                                │
│  url              │  http://initech.zendesk.com/api/v2/tickets/be0f613a-e7f7-4833-9342-643b0d9b9fca.json                                                 │
│  external_id      │  bd668495-dfd1-4d47-a68d-364d5176753a                                                                                                │
│  created_at       │  2016-03-13T10:19:40 -11:00                                                                                                          │
│  type             │  problem                                                                                                                             │
│  subject          │  A Drama in Cayman Islands                                                                                                           │
│  description      │  Anim anim exercitation magna esse minim labore reprehenderit. Veniam elit magna excepteur deserunt et labore non aliqua sunt quis.  │
│  priority         │  normal                                                                                                                              │
│  status           │  solved                                                                                                                              │
│  submitter_id     │  12                                                                                                                                  │
│  assignee_id      │  65                                                                                                                                  │
│  organization_id  │  123                                                                                                                                 │
│  tags             │  ["South Dakota", "Montana", "District Of Columbia", "Wisconsin"]                                                                    │
│  has_incidents    │  true                                                                                                                                │
│  due_at           │  2016-08-11T03:56:39 -10:00                                                                                                          │
│  via              │  web                                                                                                                                 │
└───────────────────┴──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
┌───────────────────┬──────────────────────────────────────────────────────────────────────────────────────────────────────┐
│  Ticket Fields    │  Values                                                                                              │
├───────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  _id              │  c48bf827-fc45-4158-b7ce-70784509f562                                                                │
│  url              │  http://initech.zendesk.com/api/v2/tickets/c48bf827-fc45-4158-b7ce-70784509f562.json                 │
│  external_id      │  66f6ab11-16b1-4803-818d-b59057b02fb3                                                                │
│  created_at       │  2016-05-18T12:13:28 -10:00                                                                          │
│  type             │  incident                                                                                            │
│  subject          │  A Catastrophe in New Zealand                                                                        │
│  description      │  Nisi minim sint commodo eu cupidatat amet in aute voluptate laboris. Quis id nostrud sunt ex sunt.  │
│  priority         │  low                                                                                                 │
│  status           │  solved                                                                                              │
│  submitter_id     │  12                                                                                                  │
│  assignee_id      │  55                                                                                                  │
│  organization_id  │  117                                                                                                 │
│  tags             │  ["Georgia", "Tennessee", "Mississippi", "Marshall Islands"]                                         │
│  has_incidents    │  false                                                                                               │
│  due_at           │  2016-08-18T11:38:49 -10:00                                                                          │
│  via              │  chat                                                                                                │
└───────────────────┴──────────────────────────────────────────────────────────────────────────────────────────────────────┘
┌───────────────────┬────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│  Ticket Fields    │  Values                                                                                                                                │
├───────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  _id              │  045b0fe9-8e17-4eec-af9c-cc00ce5b9ed1                                                                                                  │
│  url              │  http://initech.zendesk.com/api/v2/tickets/045b0fe9-8e17-4eec-af9c-cc00ce5b9ed1.json                                                   │
│  external_id      │  816ab668-10cc-46cf-a23a-a048d86bbba4                                                                                                  │
│  created_at       │  2016-07-05T04:41:00 -10:00                                                                                                            │
│  type             │  task                                                                                                                                  │
│  subject          │  A Drama in Mauritius                                                                                                                  │
│  description      │  Aute deserunt laboris tempor officia minim sunt ad laborum. Amet occaecat aliquip ad cupidatat in enim irure dolor id culpa nostrud.  │
│  priority         │  normal                                                                                                                                │
│  status           │  closed                                                                                                                                │
│  submitter_id     │  12                                                                                                                                    │
│  assignee_id      │  58                                                                                                                                    │
│  organization_id  │  120                                                                                                                                   │
│  tags             │  ["Georgia", "Tennessee", "Mississippi", "Marshall Islands"]                                                                           │
│  has_incidents    │  true                                                                                                                                  │
│  due_at           │  2016-08-15T01:47:16 -10:00                                                                                                            │
│  via              │  web                                                                                                                                   │
└───────────────────┴────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
  ```
</details>

**NOTE**: Associations will [only be shown on the equivalent of primary keys](./DESIGN.md#why-provide-associations-only-on-primary-keys?).

<details>
  <summary>Search for a field without associations</summary>

  ```bash
  delve search users _id 12 --no-associations
┌───────────────────┬───────────────────────────────────────────────────┐
│  Fields           │  Values                                           │
├───────────────────┼───────────────────────────────────────────────────┤
│  _id              │  12                                               │
│  url              │  http://initech.zendesk.com/api/v2/users/12.json  │
│  external_id      │  38899b1e-89ca-43e7-b039-e3c88525f0d2             │
│  name             │  Watkins Hammond                                  │
│  alias            │  Mr Sally                                         │
│  created_at       │  2016-07-21T12:26:16 -10:00                       │
│  active           │  false                                            │
│  verified         │  false                                            │
│  shared           │  false                                            │
│  locale           │  en-AU                                            │
│  timezone         │  United Kingdom                                   │
│  last_login_at    │  2012-12-29T07:59:56 -11:00                       │
│  email            │  sallyhammond@flotonic.com                        │
│  phone            │  8144-293-283                                     │
│  signature        │  Dont Worry Be Happy!                             │
│  organization_id  │  110                                              │
│  tags             │  ["Bonanza", "Balm", "Fulford", "Austinburg"]     │
│  suspended        │  false                                            │
│  role             │  end-user                                         │
└───────────────────┴───────────────────────────────────────────────────┘
  ```
</details>

<details>
  <summary>Search for a field and return raw JSON</summary>

  ```bash
  delve search users _id 12 --no-associations --raw
{"source":"users","results":[{"_id":12,"url":"http://initech.zendesk.com/api/v2/users/12.json","external_id":"38899b1e-89ca-43e7-b039-e3c88525f0d2","name":"Watkins Hammond","alias":"Mr Sally","created_at":"2016-07-21T12:26:16 -10:00","active":false,"verified":false,"shared":false,"locale":"en-AU","timezone":"United Kingdom","last_login_at":"2012-12-29T07:59:56 -11:00","email":"sallyhammond@flotonic.com","phone":"8144-293-283","signature":"Don't Worry Be Happy!","organization_id":110,"tags":["Bonanza","Balm","Fulford","Austinburg"],"suspended":false,"role":"end-user"}]}
  ```
</details>

You can use this output and [pipe it into other applications](./DESIGN.md#why-go-for-non-interactive-mode).

## Testing

This project uses [`rspec`](https://rspec.info/) for testing. To run all tests, go to the root directory, and type:

```bash
# inside the root of the project
bundle exec rspec
```

<details>
  <summary>Expected results</summary>

  ```bash
  ❯ rspec

CLI::Fields
  #call
    when provided with a matching option
      returns a list of fields
    when provided with an option that is not supported
      ignores it

CLI::Search
  #call
    when provided with correct values
      returns results that have been found
    when provided with an option that is not supported
      ignores it
    when the value matches with case insensitivity
      reutnrs results that have been found
    when the value is a number
      returns results that have been found
    when the value is a boolean
      returns results that have been found
    when the value is an array
      returns results that have been found
    when the value is empty
      returns results that have been found

Model
  #where
    when providing a matching key and value
      returns an array with the results
    when providing a key that does not exist
      returns an empty array
    when providing a key that exists but the value does not match
      returns an empty array

Organization::AssociationBuilder
  #call
    when provided the relevant data
      returns the associated data to the user
    when the result set is empty
      returns an empty set

Ticket::AssociationBuilder
  #call
    when provided the relevant data
      returns the associated data to the user
    when the result set is empty
      returns an empty set

User::AssociationBuilder
  #call
    when provided the relevant data
      returns the associated data to the user
    when the result set is empty
      returns an empty set

JSONLoader
  #call
    when valid JSON is passed to it
      loads a ruby data structure
  #all_keys
    returns all the unique keys found at the top level of the data array

Loader
  #call
    when provided a path to a json file
      returns json
    when provided a path to a non-json file
      errors out
    when provided an invalid path
      errors out

Finished in 0.04 seconds (files took 0.34829 seconds to load)
23 examples, 0 failures
  ```
</details>

## Formatting

This project is automatically formatted by `rufo`, to ensure consistency.

To format:

```bash
# inside the root of the project
bundle exec rufo .
```

[WSL]: https://docs.microsoft.com/en-us/windows/wsl/install-win10
[Install Ruby]: https://www.ruby-lang.org/en/documentation/installation/
[Install rbenv]: https://github.com/rbenv/rbenv
[brew]: https://brew.sh/
