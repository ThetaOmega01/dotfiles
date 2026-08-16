---
name: atomic-coding-steps
description: "Use only when the user explicitly asks to use atomic coding steps, atomic atoms, one-atom-at-a-time implementation, or this skill by name. Do not load for ordinary coding tasks unless the user's request directly asks for this workflow."
---

# Atomic Coding Steps

This skill tells you to make code changes as a sequence of atoms. Implement one atom. Do its check. Report it. Then stop and wait for review. If the request is vague, broad, or multi-part, first divide it into an ordered atom list.

## Definitions

- **Atom:** the smallest safe code change with one purpose. An atom is equivalent to one small commit.
- **Unit:** the code that one atom changes. A unit is one function, method, field, enum variant, test case, or one set of coupled callsites.
- **Hat:** the type of an atom. The types are: behavior, refactor, test-only, move-only, and mechanical migration.
- **Check:** the narrowest procedure that shows that an atom is correct or not correct. Examples: one unit test, a compiler diagnostic, a type check, lint on the touched file, a direct scenario.
- **Drive-by work:** work that is not part of the atom. Examples: broad format changes, unrelated cleanup, incidental refactors, comment churn, opportunistic abstractions, unrelated compatibility shims.

## Atom contract

Each atom must have all these properties:

- **One intent:** the atom has one reason. Examples: repair one branch, add one helper, migrate one caller, adjust one test, rename one symbol, change the behavior of one function.
- **One unit:** the atom changes one unit.
- **One invariant:** after the atom, the touched unit is consistent. The system is not in a broken intermediate condition.
- **Bisectable:** you can build, test, revert, and review the atom without a later atom. If the build needs changes in other files, put those files in the same atom.
- **One check:** one check confirms the atom.
- **Related tests:** if the atom changes behavior and a test surface exists, put the test for that behavior in the same atom.
- **No drive-by work.**

Keep the atom atomic by its meaning, not by its file count. Example: a rename of one symbol and all its references is one atom. A parser change plus a renderer change plus tests for the two changes is not one atom. Divide it.

## The two hats

Each atom has one hat. Do not change the hat in an atom.

- **Behavior hat:** the atom changes observable behavior, data shape, API contract, error handling, performance that is important to users, or test expectations. Put the related behavior test in the atom when a test surface exists. Do only the local mechanical cleanup that the change requires.
- **Refactor hat:** the atom changes structure, names, locations, or duplication. The behavior stays the same. Change tests only to keep names and imports correct. Do the check with the existing behavior tests. If test coverage is missing, first add a characterization test as a test-only atom.

Change hats only at atom boundaries. If you find cleanup during a behavior atom, do not do it. Put it in the plan as a later refactor atom. If a refactor shows a necessary behavior change, stop. Make the behavior change a separate atom.

## Decomposition gate

- A vague prompt, a broad goal, a bug report without a named unit, or a multi-part request is not ready for implementation. First divide it into atoms.
- Before a code edit, write the minimal atom sequence for the request. Give each atom a hat, a unit, one outcome, and one check. Use the planning template.
- If the first atom is not clear, examine only the minimum code that defines it. Uncertainty is not permission to batch work.
- Start implementation only after you name the current atom. Later atoms stay plan entries until their own approval.
- Do not make one large atom with a name such as "setup", "foundation", "wire everything", or "finish feature". Divide until a reviewer can review each atom alone.

## Step protocol

Do steps 1 and 2 one time for each task. Do steps 3 to 12 one time for each atom.

1. **Divide the task into atoms.** Put the atoms in dependency and build order. Give each atom a permanent number.
2. **Show the plan and implement atom 1 in the same turn.** The plan does not need a separate approval. The review gate applies after atom 1.
3. **Select one atom.** Work only on the first unapproved atom. Do not start, edit, or stage a later atom in the same turn.
4. **Name the atom.** Use its plan line: `Atom <n>: <hat> — <unit> — <single outcome> — check: <check>`. Put this line in the plan and in the report.
5. **Read the unit and its direct dependencies.** Do not examine unrelated files.
6. **Declare the hat.**
7. **Add or update the related tests.** Obey the section "Tests and checks".
8. **Edit only that atom.** Touch the smallest range that changes the named unit.
9. **Do the check immediately.**
10. **Repair before review.** If the check fails, repair the current atom. Do not start a different atom. If the check fails because of a pre-existing problem, do not repair unrelated code. Report the problem and propose a repair atom.
11. **Report and stop.** Give the atom name, the touched files, the check result, and the review risks. Then stop for review.
12. **Continue only after approval.** Approval permits exactly one next atom. Exception: batch permission (see "Review gate").

## Review gate

- Implement, check, and report a maximum of one atom. Then stop. Exception: batch permission (see below).
- Test results, builds, silence, elapsed time, and confidence are not an approval.
- Only accept an approval that the user gives in this conversation. Examples: "approved", "continue", "move to the next atom".
- An explicit batch permission from the user makes the gate wider. Examples: "do the next three atoms", "finish the rest without stops". Then work atom by atom, do the check for each atom, and write one report entry for each atom. But do not stop between the permitted atoms. Silence never makes the gate wider.
- After approval, start one next atom. Then obey the same gate again.
- If the review changes the intent of the atom, stop. Ask the user: replace the current atom, or add a new atom?
- If the review asks for changes, repair the current atom. Then stop for review again.
- Do not apply future atoms early. Do not add "while here" edits. Do not continue because the next atom is small, mechanical, or in the plan.

## Plan changes

- If you find a missing atom, an unnecessary atom, or a wrong order during work, complete the current atom first. Then show the changed plan in the report and mark each changed atom. Do not change the plan without a report.
- If the plan error blocks the current atom, stop immediately. Show the changed plan and wait for review.
- Each atom keeps its number. A new atom gets a new number. Do not use a number again after a plan change.
- A plan change is not an approval. The review gate applies without change.

## Tests and checks

- Start feature work with a list of the applicable test cases. Then implement one test or behavior atom at a time.
- If a test surface is available, use red-green-refactor. Write one focused test that fails. Implement only sufficient code to make it pass. Then do only the local mechanical cleanup that the behavior atom requires. Do extraction, renames, reorganization, and deduplication in a separate refactor atom.
- One test case examines one behavior, invariant, branch, edge value, or error path.
- Put the test for a behavior in the same atom as that behavior. Test framework work, test helper refactors, and characterization tests for existing behavior are separate atoms.
- Each atom must keep the build and the tests serviceable. Do not make a condition that only a later atom can compile, start, or pass.

## Sizing guide

These atom sizes are correct:

- One function body.
- One method signature plus the callsite updates that it requires.
- One helper extraction without behavior change.
- One caller migrated to an existing API.
- One branch or error path in a function.
- One data-field addition plus the coupled serialization line.
- One test case for one behavior.
- One mechanical migration with a trusted tool and one narrow check.

Divide the atom when one of these conditions occurs:

- More than one behavior changes.
- More than one abstraction layer changes. Exception: all touched layers are necessary for one vertical, user-visible slice, and the slice stays buildable.
- A refactor and a behavior change are mixed.
- A move or rename and an internal code change are mixed.
- Format changes or cleanup touch code outside the logical change.
- You cannot describe the edit in one imperative sentence.
- The check needs more than one unrelated scenario.

## Multi-file atoms

Change more than one file only when the files are one semantic unit:

- Rename an exported symbol and update each reference.
- Update an interface and each implementation that the build requires.
- Add one enum variant and the exhaustive matches that the compiler requires.
- Move one function, file, or module and update the imports. Do not change behavior.
- Add one public API plus one real usage or one focused test that shows that the API is necessary.

Rules:

- **No unused API:** do not add an API, hook, helper, field, enum variant, config knob, or exported symbol without a real caller or a focused test in the same atom. Unused scaffolding is dead code.
- **Move-only purity:** a move-only atom keeps the behavior and the contents of the moved code. Only the necessary path, module, package, import, namespace, and export adjustments are permitted. Change the moved code in a separate atom before or after the move.
- **Build after each atom:** if an interface, schema, generated type, or exhaustive match update breaks the build, put the necessary callsites in the same atom.
- **Tests stay related:** do not use a multi-file atom to mix feature work, cleanup, and broad test organization. Each test atom examines one behavior. Exception: the test is inseparable from its behavior atom.

## Planning template

Use this shape for the plan:

```text
Atom 1: <hat> — <unit> — <single outcome> — check: <check>
Atom 2: <hat> — <unit> — <single outcome> — check: <check>
Atom 3: <hat> — <unit> — <single outcome> — check: <check>
```

A reviewer must understand each atom alone. If an atom says "update everything", "finish feature", "wire the rest", or "cleanup while here", divide it.

Commit only when the user asks for commits. Then make exactly one commit for each atom, after its check passes. Write an imperative one-sentence subject. Add sufficient rationale and check detail for a stand-alone review. If the subject needs more than one action verb, divide the atom.

## Editing discipline

- Keep the edit ranges small.
- Keep the existing style in the touched unit.
- Do not reformat untouched code.
- Do not add compatibility shims. Exception: the current atom requires them to keep the code correct.
- Do not keep placeholders, TODOs, dead aliases, unused APIs, unused feature flags, or unused scaffolding.
- Delete obsolete code in the same atom that makes it obsolete.

## Reporting

Group the summary by atoms:

```text
- Atom <n>: <hat> — <unit> — <single outcome>. Files: <paths>. Check: <command/scenario and result>. Risks: <risks or "none">.
```

If the task was too coupled for a clean division, report the invariant that caused a larger atom. Report the check that examined it.

## Examples

Atomic:

- Behavior: change `parsePort` so that it rejects negative ports, and add the negative-port test; check the `parsePort` tests.
- Refactor: extract `normalizeUserName` from `formatUserName` without behavior change; check the existing formatter tests.
- Move-only: move `formatUserName` to `user/format.ts` and update the imports only; check the type check.
- Mechanical migration: rename the exported `loadUser` to `fetchUser` and update each reference; check the compiler.
- API: add `useAuthSubmit` plus migrate `LoginForm` as its first real usage; check the login form test.

Not atomic:

- Refactor auth, update the UI, and add retry behavior in one step.
- Rename a function and change its semantics at the same time.
- Move a file and clean its internals in the same atom.
- Add a public helper without a caller or a focused test.
- Reformat a file and repair one branch at the same time.
- Add a helper, migrate all callers, and rewrite the tests. Exception: the helper is purely mechanical, and one semantic cutover requires all the edits.

One full loop:

```text
Turn 1 — agent:
  Plan:
    Atom 1: behavior — parsePort — reject negative ports — check: parsePort tests
    Atom 2: refactor — parsePort — extract validatePortRange — check: parsePort tests
  Atom 1: behavior — parsePort — reject negative ports. Files: parse_port.ts, parse_port_test.ts. Check: `test parse_port` — pass. Risks: none.
  I stop for review.
Turn 2 — user: "approved"
Turn 3 — agent:
  Atom 2: refactor — parsePort — extract validatePortRange. Files: parse_port.ts. Check: `test parse_port` — pass. Risks: none.
  I stop for review.
```
