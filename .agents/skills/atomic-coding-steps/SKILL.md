---
name: atomic-coding-steps
description: "Use when performing coding tasks where implementation should advance through atomic, reviewable, bisectable changes: one behavior, function, method, caller, test case, or cohesive code unit per step. Enforces per-atom verification, related tests with behavior atoms, strict refactor-vs-feature separation, no unused APIs, move-only purity, and no drive-by edits."
---

# Atomic Coding Steps

Use this skill to implement coding work as a sequence of small, reviewable, bisectable changes. Treat each atom like a tiny commit/CL: one purpose, one coherent code unit, one verification target, and no hidden companion work.

## Non-negotiable atom contract

An atomic change has all of these properties:

- **One intent:** it answers one reason: fix one branch, add one helper, migrate one caller, adjust one test, rename one symbol, or change one function's behavior.
- **One smallest safe code unit:** usually one function, method, struct field, enum variant, test case, or tightly coupled callsite set.
- **One invariant:** after the atom, the touched unit is internally consistent and the system is not left in a broken intermediate state.
- **Bisectable:** the atom can be built, tested, reverted, or reviewed without relying on an unstated later atom. If separate files are required to keep the compiler/runtime coherent, include those files in the same atom.
- **One verification target:** a focused check can confirm the atom or expose its failure.
- **Related tests included:** an atom that changes behavior carries the test addition/update for that behavior when an applicable test surface exists or when the test is the smallest honest verification.
- **No drive-by work:** no broad formatting, unrelated cleanup, incidental refactors, comment churn, opportunistic abstractions, or compatibility shims unrelated to the atom.

If a change cannot be made safe in one file, keep it atomic by semantic intent, not by file count. Example: a symbol rename across all references is one atomic semantic change. A parser behavior change plus renderer behavior change plus tests for both is not one atom; split it.

## Step protocol

For every coding task:

1. **Decompose first.** List the minimal sequence of atoms needed to satisfy the request. Order atoms by dependency and buildability.
2. **Name the current atom.** Before editing, state it internally as: `Change <unit> so that <single outcome>; check <focused verification>`.
3. **Read the exact unit and direct dependencies.** Do not inspect unrelated files hoping to find work.
4. **Choose the hat.** Declare the atom as behavior, refactor, test-only, move-only, or mechanical migration. Do not switch hats inside the atom.
5. **Add or update related tests with behavior.** When feasible, use red-green-refactor: write the next focused failing test, implement only enough code to pass it, then perform only local mechanical cleanup required to keep the behavior atom coherent. Schedule structural refactoring as a separate refactor atom.
6. **Edit only that atom.** Touch the smallest range that changes the named unit. Do not batch nearby or unrelated improvements.
7. **Verify immediately.** Run the narrowest relevant check: unit test, compiler diagnostic, type check, lint on touched file, or direct scenario.
8. **Repair before proceeding.** If verification fails, fix the current atom before starting the next one.
9. **Record the result.** Keep a short trail: atom completed, files touched, focused check outcome.
10. **Proceed to the next atom.** Do not yield between atoms unless the user explicitly asked for one step only.

## Two-hats rule: refactor vs behavior

Wear one hat per atom:

- **Behavior hat:** changes externally observable behavior, data shape, API contract, error handling, performance characteristics users rely on, or test expectations. Include the related behavior test in this atom when possible. Only perform local mechanical cleanup required to make the behavior change coherent.
- **Refactor hat:** changes structure, names, locations, or duplication without intentional behavior change. Do not change tests except to keep names/imports coherent. Verify with existing behavior tests; if coverage is missing, add a characterization test as a prior test-only atom.

Switch hats only at atom boundaries. If you discover cleanup while wearing the behavior hat, either leave it or schedule a later refactor atom. If a refactor reveals a necessary behavior change, stop and make the behavior change a separate atom.

## Tests and verification

- Start feature work by listing the relevant test cases, then implement one test/behavior atom at a time.
- Prefer red-green-refactor when the test surface is available: failing test first, minimal implementation, then only local mechanical cleanup required for the behavior atom. Extract, rename, reorganize, or deduplicate in a separate refactor atom.
- Keep one test case focused on one behavior, invariant, branch, edge value, or error path.
- Put related test code in the same atom as the behavior it validates. Independent test framework work, test helper refactors, or characterization tests for existing behavior are separate atoms.
- Each atom should preserve build/test health for users and developers. Do not leave an intermediate state that requires a later atom to compile, start, or pass the focused check.

## Sizing guide

Prefer these atom sizes:

- One function body.
- One method signature plus the directly required callsite updates.
- One helper extraction without behavior change.
- One caller migrated to an existing API.
- One branch or error path in a function.
- One data-field addition plus the directly coupled serialization/deserialization line.
- One test case for one behavior.
- One generated/mechanical migration with a trusted tool and a narrow verification.

Split when any of these appear:

- More than one behavior changes.
- More than one abstraction layer changes unless all touched layers are required for one vertical, user-visible slice that stays buildable.
- A refactor and a behavior change are mixed.
- A move/rename and an internal code modification are mixed.
- Formatting or cleanup touches code outside the logical change.
- The edit would be hard to describe in one imperative sentence.
- The verification target would need multiple unrelated scenarios.

## Multi-file atoms

Multi-file edits are allowed only when the files are inseparable for one semantic change:

- Rename an exported symbol and update every reference.
- Update an interface and every implementation required to keep the build coherent.
- Add one enum variant and the exhaustive matches required by the compiler.
- Move one function/file/module and update imports, without changing behavior.
- Add one public API plus one real usage or focused test that proves the API is needed.

Concrete multi-file rules:

- **No unused API atoms:** do not add an API, hook, helper, field, enum variant, config knob, or exported symbol without a real caller or focused test in the same atom. Unused scaffolding is not atomic; it is dead code.
- **Move-only purity:** a move-only atom must preserve moved code behavior and contents except required path, module, package, import, namespace, or export adjustments. Modify the moved code in a separate atom before or after the move.
- **Build after each atom:** if an interface, schema, generated type, or exhaustive match update would break the build until callsites are updated, include the required callsites in the same atom.
- **Tests stay related:** do not use a multi-file atom to combine feature work, cleanup, and broad test organization. Each test atom covers one behavior unless the test is inseparable from the behavior atom.

## Atomic planning template

Use this shape for internal task planning:

```text
Atom 1: <hat> — <unit> — <single outcome> — check: <focused verification>
Atom 2: <hat> — <unit> — <single outcome> — check: <focused verification>
Atom 3: <hat> — <unit> — <single outcome> — check: <focused verification>
```

Each atom must be independently understandable. If an atom reads like "update everything," "finish feature," "wire the rest," or "cleanup while here," split it.

If committing atoms, use an imperative one-sentence subject plus enough rationale/check detail for the atom to stand alone in review. If the subject needs more than one action verb or rationale, split the atom.

## Editing discipline

- Keep edit ranges tight.
- Preserve existing style in the touched unit.
- Do not reformat untouched code.
- Do not introduce compatibility shims unless the current atom explicitly requires them to keep the code coherent.
- Do not leave placeholders, TODOs, dead aliases, unused APIs, unused feature flags, or unused scaffolding.
- Prefer deleting obsolete code in the same atom that makes it obsolete.
- If an atom fails verification, fix that atom before starting the next one.

## Reporting

When summarizing work, group by atoms:

```text
- Atom: <hat> — <unit> — <single outcome>. Files: <paths>. Check: <command/scenario and result>.
```

If a requested task was too coupled to split cleanly, say which invariant forced a larger atom and what focused check covered it.

## Examples

Atomic:

- Behavior: change `parsePort` to reject negative ports and add the negative-port test; verify `parsePort` tests.
- Refactor: extract `normalizeUserName` from `formatUserName` without behavior change; verify existing formatter tests.
- Move-only: move `formatUserName` to `user/format.ts` and update imports only; verify type check.
- Mechanical migration: rename exported `loadUser` to `fetchUser` and update every reference; verify compiler.
- API: add `useAuthSubmit` plus migrate `LoginForm` as its first real usage; verify the login form test.

Not atomic:

- Refactor auth, update UI, and add retry behavior in one step.
- Rename a function while changing its semantics.
- Move a file and clean up its internals in the same atom.
- Add a public helper with no caller or focused test.
- Reformat a file while fixing one branch.
- Add a helper, migrate all callers, and rewrite tests unless the helper is purely mechanical and all edits are required for one semantic cutover.
