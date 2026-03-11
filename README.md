<img src="public/icon.png" alt="Strety Commons" width="32" />

# Strety Commons

A community board where the Strety team shares posts and bookmarks the ones they want to get back to.

<img src="public/preview.png" alt="Strety Commons preview" width="600" />

## Getting Started

### Prerequisites

- Ruby 3.4.7
- Node 25.6.0
- Yarn
- SQLite3

If you don't have these versions installed, we recommend using [mise](https://mise.jdx.dev/getting-started.html) to manage tool versions. Once mise is installed:

```bash
mise install
```

This will pick up the Ruby and Node versions from the `.ruby-version` and `.node-version` files in the repo.

### Setup

Fork the repo to your own GitHub account, then clone your fork and run the setup script:

```bash
git clone <your-fork-url>
cd product-design-exercise
bin/setup
```

This will install Ruby and JavaScript dependencies, set up the database, seed it with sample data, and start the development server.

If you've already set up and just want to start the server:

```bash
bin/dev
```

The app will be available at http://localhost:3000.

## The Exercise

Open [PITCH.md](PITCH.md) first. It explains the two exercise tracks that now live in this repo.

- Track 1: [Bookmarks Listing](PITCH_BOOKMARKS_LISTING.md) for a narrower product/design-oriented build
- Track 2: [Personalized Bookmarks](PITCH_PERSONALIZED_BOOKMARKS.md) for a more open-ended, product-minded Rails exercise

Use the track your interviewer assigns. Both briefs build on the same baseline app and existing bookmark toggle.

Take a look around the app first. Create some posts, bookmark a few, and get a feel for how things work before diving in.

## Submission

Please complete the exercise in your own fork of this repository.

- Fork this repo to your GitHub account
- Create a branch in your fork for your work
- Build the assigned exercise track in that fork
- Open a pull request with your changes when you're done

That pull request is the submission we will review. Please use the PR description to include any assumptions, tradeoffs, open questions, or follow-up ideas that would help us understand your decisions.
