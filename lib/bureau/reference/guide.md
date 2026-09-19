## Bureau

> **DO NOT** explore the bureau gem source code. This reference is the complete
> user-facing API, and bureau's locals are authored from it. Keep it the single
> source of truth: change it in the same pass that changes the interface, then
> author the locals again.

Bureau is the settings page, shared across apps: **a section is a registration,
not a page.** Bureau owns the page, the list of sections on it, the address each
section is served at, and the check deciding who may see one. A section owns
only its fields and the things a person can do with them. Adding a section
changes no routing, no navigation and no controller.

Bureau owns no database table. It is a mountable Rails engine and it draws every
page with keystone_ui.

### Installing it

```ruby
gem "bureau"
```

```ruby
mount Bureau::Engine => "/settings"
```

The host's `ApplicationController` supplies four things. Only the first is
required:

```ruby
def current_person          # required — who is signed in
def settings_account        # the account settings act on
def current_account         # used when settings_account is not defined
def can?(capability)        # required once any section names a capability
def after_settings_change(section:, person:)   # optional, runs after a change
```

`settings_account` is asked for first and `current_account` is the fallback, so
an app whose settings act on something other than the account a person last
switched to says which by defining `settings_account`. An app that defines
neither gets `nil`, which is correct for a product whose settings are all
personal.

### Generating a section

```
bin/rails generate bureau:section reminders
```

It registers the section in the app's bureau initializer, creating that file if
it is missing, and writes the object the section runs, the partial it draws and
a test for the object. The generated test passes as written, and the section
appears on the settings page with nothing further to wire. Everything it writes
is a starting point to edit.

### Registering a section

```ruby
Rails.application.config.to_prepare do
  Bureau.section :password, area: :user, title: "Password",
    renders: "settings/password", runs: "ChangePassword"
end
```

| Detail | Required | What it is |
|---|---|---|
| first argument | yes | the section's key, used in its address |
| `area:` | yes | which list it appears in — any symbol, commonly `:user`, `:team`, `:account` |
| `title:` | yes | what the list calls it |
| `renders:` | no | the partial drawn inside the settings page |
| `runs:` | no | the object or objects a submitted change is handed to |
| `capability:` | no | what a person must hold to see it |
| `at:` | no | an address to send a person to instead of drawing a partial |

A section with `at:` draws nothing and sends the person to that address. Use it
for a page bureau cannot serve, such as one a vendored engine owns.

Registrations go in `config.to_prepare`, which runs again on every code reload.
Bureau clears its registry each time, so registrations are made fresh rather
than added to what is already there.

### Replacing a registration

`Bureau.section` refuses a key already taken in that area. Code that means to
override a registered section says so:

```ruby
Bureau.replace_section :profile, area: :user, title: "Profile",
  renders: "my_app/profile", runs: "MyApp::ChangeName"
```

### What bureau refuses when the app starts

Three mistakes raise `Bureau::BadRegistration` at registration rather than in
front of a person:

- a key already taken in that area, named in the message
- an object named in `runs:` that the app cannot find, named in the message
- a capability the app does not recognise, named in the message

The third runs only once the app declares what it recognises:

```ruby
Bureau.capabilities = -> { Citizen.capabilities }
```

An app that declares nothing gets no capability check, which is what lets bureau
be installed without citizen.

### The object a section runs

`runs:` names a class as a string. The object takes three keywords and answers
`call`:

```ruby
class ChangeName
  def initialize(person:, account:, values:)
    @person = person
    @account = account
    @values = values
  end

  def call
    return Bureau::Result.refused(@person.errors.full_messages.to_sentence) unless @person.update(name: @values[:name])

    Bureau::Result.ok
  end
end
```

`values` is what the person submitted, as a hash with symbol keys. The object
reads no request, no session and no params object, which is what lets a caller
other than the page run it.

```ruby
Bureau::Result.ok                  # it worked
Bureau::Result.refused("why not")  # it did not, and this is shown to the person
```

A refusal re-draws the section with the message above it and saves nothing, and
the app is not told a change was made.

### The partial a section renders

The partial is handed locals and nothing else. It draws no page heading, no
frame and no layout, because it is rendered inside the settings page:

```erb
<%= ui_panel do %>
  <%= ui_form(action: submit_url, method: :patch) do %>
    <%= ui_form_field(attribute: "name", label: "Name", value: person.name, required: true) %>
    <%= ui_button(label: "Save") %>
  <% end %>
<% end %>
```

| Local | What it is |
|---|---|
| `person` | who is signed in |
| `account` | the account settings act on |
| `selection` | the query string, as a hash with symbol keys |
| `submit_url` | where to submit, for a section naming one object |
| `submit_urls` | where to submit each named object, for a section naming several |

`selection` is how a section holds a choice across a request without a
controller of its own — a section listing people links each one to
`?member_id=1` and reads `selection[:member_id]` to draw that person.

### A section that does several things

`runs:` takes a hash when a section offers more than one thing. Each gets its
own address, handed to the partial in `submit_urls`:

```ruby
Bureau.section :team, area: :team, title: "Team", capability: :manage_team,
  renders: "citizen/members/team",
  runs: {
    invite: "Citizen::Invite",
    remove: "Citizen::RemoveMember"
  }
```

```erb
<%= ui_form(action: submit_urls[:invite], method: :patch) do %>
```

Every object in the hash takes the same three keywords and returns the same
result as the single-object case.
