---
name: daily-log
description: Add an entry to the user's daily work log, kept in an Obsidian vault as one note per month for each project they track. Use when the user asks to log work, add to their daily log or monthly breakdown, or note what they did today. Also, when a session finishes a meaningful piece of work (a feature, fix, design or planning decision), check whether the current project keeps a log in the vault, and if it does, ask the user whether they want the work logged. Never write to the log without asking first.
---

# Daily log

The user keeps a daily log for some of their projects in their Obsidian vaults. A project keeps a log if its folder in a vault has a `monthly-breakdowns` folder. Each month is one note in it, named `<Month> <YYYY>.md`, for example `<Project>/monthly-breakdowns/October 2026.md`. Use the Read and Edit tools with the full path. Vault paths often contain spaces, so quote them in any shell command.

## Find the project

1. **Work out what you're working on** from your own context: the working directory, the repo name, the git remote and anything the user has said about the project.
2. **Find the logs.** Obsidian lists its vaults in `obsidian.json` in its config folder: `~/Library/Application Support/obsidian` on macOS, `~/.config/obsidian` on Linux and `%APPDATA%\obsidian` on Windows. This lists every `monthly-breakdowns` folder in those vaults on macOS and Linux:

   ```sh
   for f in "$HOME/Library/Application Support/obsidian/obsidian.json" "${XDG_CONFIG_HOME:-$HOME/.config}/obsidian/obsidian.json"; do
     [ -f "$f" ] && python3 -c 'import json,sys; [print(v["path"]) for v in json.load(open(sys.argv[1]))["vaults"].values()]' "$f"
   done | while IFS= read -r vault; do
     find "$vault" -maxdepth 3 -type d -name monthly-breakdowns -not -path '*/.*'
   done
   ```

   If Obsidian isn't installed or lists no vaults, ask the user where their vault is.
3. **Match the project** to one of those folders by the name of the folder that contains `monthly-breakdowns`, ignoring case and punctuation. A repo called `acme-app` matches a vault folder called `Acme`. If nothing matches, the project doesn't keep a log. Don't offer to log the work.
4. **When the user asks to log something** and you can't tell the project from context, use the only project with a log if there is one, and ask which project if there are several.

## Format

Another note in the project folder counts the day headings to tally the days worked, so the heading structure must stay exactly as described here.

```markdown
##### Monday 5th
###### Team profile URL improvement
We had an issue where the team URL field required users to type the `https://` part, otherwise they got a confusing "invalid URL" error. Fixed by adding it automatically in the form. [[@ABC-325]]
###### Planning for next cycle
Worked through the outstanding decisions from the new designs, so the tickets in the coming cycle can move faster.

##### Tuesday 6th - 1/2 Day
###### Enquiry follow-up flag
Added a "follow up" _flag_ that users can set on enquiry threads, separate from the enquiry status. [[@ABC-399]]
```

- **Day heading:** `#####` (level 5), weekday, then the date with its ordinal suffix: `1st`, `2nd`, `3rd`, `4th`, `11th`, `12th`, `13th`, `21st`, `22nd`, `23rd`, `31st`. A partial day ends in exactly ` - 1/4 Day`, ` - 1/2 Day` or ` - 3/4 Day`, with a capital D. The day count matches those strings, so any other spelling (`1/2 day`, `half day`) counts as a full day. A full day has no suffix.
- **Item heading:** `######` (level 6), a short title for one piece of work. No other heading levels appear in the file.
- **Body:** plain paragraphs directly under the item heading, with no blank line between the heading and its text or between one item and the next. A list is fine when the work has several parts. Use `-` bullets and indent nested bullets with a tab.
- **Spacing:** one blank line before each day heading. Days run in date order, oldest first. The file has no trailing newline.
- **Tickets:** put Linear tickets at the end of the item's text as `[[@KEY-123]]`, using the project's Linear team key, separated by spaces when there are several. Copy the key from earlier entries. An Obsidian plugin turns them into links.

## Writing an entry

The people who read these are not technical. Write for a layman.

- Say what changed for users and, where it helps, why. Leave out file names, function names, libraries and implementation detail unless a reader needs it to follow the point. "Routed all requests to Google through our own backend, so it's never exposed how we geocode" is the right level of detail.
- Write in the past tense, in the user's voice: "Added", "Reworked", "Fixed by", "I've", "we" for the product. Match the spelling (British or American) of earlier entries.
- Keep it short. Most items are one to three sentences. Use `_italics_` for occasional emphasis and backticks only for something a user would type or see, like `https://`.
- Tag every ticket the work belongs to. Find ticket IDs in the branch name (`abc-399-...`), commit messages, the PR, or the conversation. If the Linear MCP server is available, you can search it. Don't guess an ID. Work with no ticket, such as planning or tooling, goes in without a tag.
- Read the existing month note first, and match how the user has written that month.

## Adding to the note

1. **Pick the day.** Use today's date in the user's local time zone, from `date`, unless the user names another day.
2. **Open the month note.** If it doesn't exist yet, create it with this entry as its first content. Then tell the user, because the note that counts the days names the month it reads, and they update it by hand.
3. **Find or add the day heading.**
   - If the day already has a heading, add the new item after that day's last item. If an existing item that day covers the same piece of work, extend its text and add any new ticket tags instead of starting a duplicate item.
   - If the day has no heading, add one in date order. A new day counts as a full day unless the user says otherwise. Say so when you confirm, since partial days change the day count.
   - Change a day's fraction only when the user asks.
4. **Write it** with Edit, keeping the blank-line rules above. Never reformat, reword or reorder existing entries.
5. **Confirm** by showing the user the lines you added and the note you added them to.

## When to ask and when to write

- **Offering during a session:** when you finish a meaningful piece of work, first find the project's log as described above. If it has one, ask once whether to log the work and include your draft entry in the same message, so the user can approve or correct it in one reply. Skip small tweaks, failed experiments and questions. Don't ask again in the same session about work already offered or logged. Write only after the user says yes.
- **On demand:** when the user asks you to log something, including work done outside this session, draft the entry from what they tell you and write it. Ask first only if you can't tell which project or day it belongs to, or what the work achieved.
