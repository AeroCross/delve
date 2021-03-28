
## Why go for non-interactive mode?

The single biggest design decision around this application is going directly against what was shown as an example
in the original instructions (even though it is not prescriptive): instead of provide the application in interactive
mode (ie. run the application and then parse input > show output while the application is running, then choose to exit
at any time) I have instead chosen to develop the application with the [Unix philosophy of developing software][unix philosophy]
in mind.

Specifically, item #2 (formatted for your reading pleasure):

1. Expect the output of every program to become the input to another, as yet unknown, program. (e.g `jid`, `pbcopy`, text streams etc.)
2. Don't clutter output with extraneous information. (ie. the `--raw` option)
3. Avoid stringently columnar or binary input formats. (ie. the `--raw` option)
4. Don't insist on interactive input. (ie. the entire thing)

While at first it may seem counter intuitive (especially for people who are not programmers), not providing an
interactive mode has given 2 major benefits to this application:

1. It has virtually infinite features given that it can be piped into any other application that accepts a text stream
2. Interactive mode is one less concern to develop for

For example, even though it is not provided by the application itself, you can navigate any sort of result interactively
if you have [`jid`][jid] installed:

```bash
delve search users _id 25 --raw | jid
```

<details>
  <summary>See demo</summary>
</details>

Want to save a file with the results of your query, but you want it to be prettified with `jsonpp` first and then saved
to Dropox so you can share it with your colleagues because that's how you work?

```bash
delve search users email "byersestrada@flotonic.com" -r | jsonpp > user.json && cp ./user.json ~/Dropbox/user.json
```

<details>
  <summary>See demo</summary>
</details>

(Please don't actually do this if you're dealing with PII or a GDPR data portability request!)

The possibilities are, virtually, endless.

## Why Ruby 2, and not 3?

Ruby 3 was released on December 25th, 2020. That has been a little over 3 months ago. Ruby 2, on the other hand, was
released over **8 years ago**. The Ruby 2 ecosystem is vibrant, vast and well supported, and I wanted to ensure that
this project—even with its small scope—had the full support of the gems, libraries, packages and all the other
things that make a Ruby app, instead of trying the latest and the greatest.

This does not mean that the project is not Ruby 3.0 compatible, or that it won't benefit from it, but for this
coding challenge, I would prefer to stick to something tried, true and tested.

## Why is not every `require` at the top?

Since this is not a Rails application (which autoloads, well, everything), I have decided to use in-line `require`
whenever possible, to improve runtime performance. This may look weird for Rails-only developers, but it is a conscious
decision. This is the rough equivalent of lazy loading classes, modules etc.

## Why provide associations only on primary keys?

The Zendesk Coding Challenge isn't extremely specific when it talks about "related entities should be included in the
results".

When originally developing the Associations code, I quickly realised that, since I'm not working with a database engine
that provides constraints, there was a potential of search results and their associations getting out of control.

For example, without checking the data carefully (something that misses the point, in my opinion, since the data files
can change and the application is designed with that in mind) you can't be sure that the `email` field is unique. If
it is not, then your search results may include 5 users instead of just one. That's 5 (or more) organizations, and then
each organization would then have tens of tickets _each_. Where do we stop?

This is why I introduced the concept of the "Primary Key"—even though we're not dealing with a RDBMS—under the
assumption that _that_ field in particular _had_ to be unique.

My assumption may be wrong, but I feel that keeps the results manageable from a human-readability perspective. This is
also why the `--no-associations` flag exists.

## Given more time and freedom, any tools I would have used, or any other techniques?

There's a few things that I would change, both from the perspective of the challenge, and in a production environment:

- Unless we're Amazon, I think handling so many strings in memory makes things a bit cumbersome. I would have used
something like like SQLite at boot-time (load data, insert it in SQLite, query from there). Something like the
equivalent of using `redux` when a page loads in a client-side web environment.
  - Going a step further, we have things like ElasticSearch that would be way more efficient to search heaps of data.
- There's nothing wrong with using a database. I really like `ActiveRecord` too, which would have _significantly_ reduced
the complexity of the associations code.
- Since we're sticking to in-memory searching, due to the way that the app works (non-interactive mode) I thought of using
a hash table instead to improve search times, but since the application exists immediately after, which unloads the file
from memory, it felt like overkill.
  - A fix for this would be caching results in a file, or loading the file, then creating 
  multiple files that are "indexed" by the `fields` currently available through hashes, then load each file depending
  on the source and field when parsing the arguments. This would create many more files in the `data` folder but
  potentially reduce the time it takes to find something _dramatically_.
- I would have probably not picked `thor` and would have chosen something else.
  - I have used `thor` quite a bit during my career, but it seems to be somewhat unsupported, and its documentation is
  severely lacking — to the point that I had to go through the code itself to see what sort of tools I had at my
  disposal. I'm OK with spelunking through code like that on a daily basis, but when you're under time pressure, that's
  the last thing you want to be doing.
  - I would have still not used `OptionParser`.
- I would have used `oj` or something similar. `oj` _does_ feel like it goes against the spirit of the challenge, so I
just stuck to the `stdlib`.

## Usage of Dependencies

Some gems were used in this project to either speed up the rate of development or to ensure a high-quality deliverable.

These were chosen under the assumption that their implementation would be out of the scope of the challenge, which
allowed me to focus and dedicate more time to what was really important for evaluation purposes.

- [`thor`][thor]
  - A gem that reduces the friction when building command-line utilities.
  - It was mostly used as an alternative to [`OptionParser`](optionparser). I find `thor`'s interface a lot nicer to
  work with, a lot easier to read for reviewers, and it reduces the boilerplate that needs to be written.

- [`tty-table`][tty-table]
  - A gem that allows quick drawing of tables in a command-line environment.
  - Drawing tables does not seem like is part of the scope of the challenge, since "human readable" is ambiguous enough
  for it to be anything.
  - Alternatives to "human readable" would be using ruby's own `pp` class, or some simple spacing, or `awesome_print`,
  but it felt like a nice inclusion.
  - Considering that the application was designed with raw output in mind, it felt that switching between the two modes
  would be a good compromise and a boost in the capabilities of the application without compromising the integrity of
  the challenge.

- [`paint`][paint]
  - A gem that colourises text in a command-line environment through ANSI colour codes.
  - ANSI colour codes are _notoriously_ hard to read and parse, so it would probably distract and deter from the
  reviewing experience.
  - As with table drawing, it felt like it was outside of the scope of the challenge.
  - Furthermore, it is meant to be a nice polishing touch.

- [`fakefs`][fakefs]
  - A gem that allows stubbing of the filesystem when using `rspec`.
  - I originally started stubbing calls to `File` and its siblings, then using a `tmp/` folder inside
  the app's directory, then using the `Tempfile` class to replicate this, but it felt unnecessarily cumbersome to
  develop and test, and it also felt that it would be increasing its brittleness or flakyness on other development
  environments (like Windows).
  - In a professional, production environment, we often use tools like this to ensure we reduce the performance impact
  of our own tests in CI (like using `vcr` for example, to reduce test times and increase reliability without using
  "the real thing") so it felt like I would be doing the same, without undermining the challenge's goal.

## A Note on Git Commits

You may have noticed that the entirety of the application has a bunch of git commits, some with minor fixes.

During the development of a production feature, I would have kept the philosophy of "the commit message should show the
**why** of a change, and the changeset shows the **what**", but I would have used more interactive rebasing to remove
or squash minor stuff.

For example, you wouldn't know that I ever committed `require "byebug"` a million times, but I think it is important
for reviewers to be with me throughout the journey of developing the application, and see it evolve over time.

[thor]: https://github.com/erikhuda/thor
[optionparser]: https://ruby-doc.org/stdlib-2.7.2/libdoc/optparse/rdoc/OptionParser.html
[tty-table]: https://github.com/piotrmurach/tty-table
[paint]: https://github.com/janlelis/paint
[fakefs]: https://github.com/fakefs/fakefs
[unix philosophy]: https://en.wikipedia.org/wiki/Unix_philosophy
[jid]: https://github.com/simeji/jid
