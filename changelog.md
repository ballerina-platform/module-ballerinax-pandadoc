# Change Log

This file contains all the notable changes done to the Ballerina PandaDoc package through the releases.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- The client now covers the full PandaDoc Public API (version 8.20.0): documents, templates, content library items,
  folders, contacts, recipients, attachments, fields, sections, quotes, webhooks, notarization, the product catalog,
  logs, members, users and workspaces.
- Mock-server based tests and two examples.

### Changed

- The client exposes **remote methods**.
- Records generated from inline schemas have descriptive names instead of `InlineResponse*` or `*Body`.
