---
name: remind-me
description: Capture a personal todo or reminder in Todoist. Use when the user asks to be reminded of something, says not to let them forget something, or wants a personal todo noted that belongs to no GitHub issue or Linear ticket.
---

# Remind me

The user keeps personal todos and reminders in Todoist, reached through the Todoist MCP server (`mcp__plugin_todoist_todoist__*`). Work that belongs to a codebase goes to that project's tracker instead. Todoist holds everything else: errands, follow-ups, things to check later, and nudges about work that has no ticket.

## Capture

1. **Scope it.** A bug, feature or code change in a repo belongs in that repo's tracker (Linear or GitHub issues). Say so, offer to file it there, and stop. Anything personal, or a work nudge with no natural ticket ("chase the accountant", "check the deploy on Friday"), continues here.
2. **Write the task.** `content` is a short imperative action the user can act on without the conversation ("Renew the domain for jobvantage.com"). Put the context they would need into `description`: links, file paths, names, the why. Leave out anything only this session knows.
3. **Place it.** Call `find-projects` and `find-labels` to see what exists now.
   - Project: the one named after the codebase or venture the reminder concerns (working in the viewings.com repo means `Viewings.com`). Everything else goes to `inbox`.
   - Labels: `reminder` when they asked to be reminded, `chore` for household or admin chores, `work` for anything tied to a job or venture. Combine them where more than one fits.
4. **Date it.** Pass the user's words as `dueString` ("tomorrow at 9am", "next Friday", "every first Monday"). With a time, Todoist notifies them at that time. With no timing given, leave it undated in the right project and say so. The user is in Europe/London; resolve relative dates against `user-info` when the wording is ambiguous.
5. **Create it** with `add-tasks`. Add an extra alert through `add-reminders` only when the user asks for one ("remind me an hour before"). The account is on Todoist Free, so if that call fails on the plan, keep the task and tell the user the due time is the only alert.
6. **Confirm** in one line: the task name, project, labels and due date as Todoist parsed them.

Several reminders in one message become one `add-tasks` call with an entry each.

## Other requests

- "What's on my list", "what did I ask you to remind me about": `find-tasks-by-date` for dated work, `find-tasks` with the `reminder` label for the rest.
- "Done", "drop that one": `complete-tasks`, or `delete-object` only when the user says delete.
- Moving a date: `reschedule-tasks`, which keeps recurrence intact.
