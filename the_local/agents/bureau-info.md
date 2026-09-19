---
name: bureau-info
description: Use to learn what bureau offers — the shared settings page, sections as registrations, and the vocabulary its other locals assume.
tools: Read
scope: settings — one settings page whose sections are registered by the app and by other gems
---

This local explains what bureau is and which of its other locals you want. It
changes nothing and gives no steps.

## What bureau is

Bureau is the settings page an app mounts instead of building. It is a mountable
Rails engine that owns the page itself, the list of what appears on it, the
address each entry is served at, and the check deciding who may see one. An app
or another gem adds to that page by registering a section, and a section owns
only its own fields and the things a person can do with them. Adding one changes
no routing, no navigation and no controller in the host.

Reach for it when a product needs one settings page that several parts of the
codebase contribute to — the app's own settings beside settings that belong to
gems the app installs. Bureau owns no database table and stores nothing; every
section's data belongs to whoever registered it. Every page is drawn with
keystone_ui, so a host that does not use keystone_ui gets a settings page that
does not match the rest of it.

## Interface

Bureau's surface is split between its other two locals and this one documents
none of it.

- **bureau-install** — putting the gem in, mounting the engine, the methods the
  host's `ApplicationController` supplies for who is signed in and what settings
  act on, and telling bureau which capabilities the app recognises.
- **bureau-develop** — writing a new section's starting files, registering a
  section by hand, replacing one another gem registered, the object a section
  hands a submitted change to, the result that object answers with, and the
  locals its partial is drawn with.

## How to use it

- Putting bureau into an app for the first time, or an app has it and no section
  is appearing — **bureau-install**.
- Starting a section from nothing, editing one that was generated, registering
  one by hand, or changing one that already exists — **bureau-develop**.

Both, in that order, when an app is taking bureau and its first section in the
same pass.

## Conventions

**Section** — one registration, not a page and not a controller. It names what
it is called, which list it belongs in, what is drawn for it, and what runs when
a person submits it.

**Area** — the list a section appears in on the page, named by a symbol. The
person's own settings, a team's and an account's are the usual three, any symbol
is allowed, and sections sharing an area are shown together.

**Key** — the section's own name, used in its address under wherever the engine
is mounted. A registration taking a key already held in that area is refused
when the app starts rather than in front of a person, and a section is found by
key alone, so the same key in two areas leaves one of them unreachable.

**Capability** — the product's word for what a person must hold to see a
section. A section that names none is shown to everyone signed in. The host
answers whether the signed-in person holds one, and an app that never declares
which capabilities exist gets no check at all, which is what lets bureau be
installed without the gem that would normally supply them.

**Registration time** — registrations are made in the reload hook rather than at
boot, and bureau clears what it holds on each reload, so the set of sections is
rebuilt from scratch every time the code reloads.

**Refusal** — a submitted change that did not happen. The object behind the
section says so with a message, the section is drawn again with that message
above it, nothing is saved, and the host is not told a change was made.

**Generated code is a starting point.** A section written from nothing runs and
its test passes as written, and everything in it is meant to be edited rather
than kept as it came out.
