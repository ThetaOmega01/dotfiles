import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";
import { postmortem } from "@oh-my-pi/pi-utils";

const PATCH_STATE = Symbol.for("omp.extension.browserStealthDebugError.5296");
const SOURCE_DEBUG_ERROR_FAILURE = /\bdebugError\b.*\bnot (?:a )?function\b/i;
const BUNDLED_DEBUG_ERROR_FAILURE =
	"P3 is not a function. (In 'P3(_)', 'P3' is undefined)";
const BUNDLED_WORLD_ACQUIRE_FRAME =
	"at #V (/$bunfs/root/packages/coding-agent/src/cli.js:339986:11)";


export function isBrowserStealthDebugError(reason: unknown): boolean {
	if (
		typeof reason !== "object" ||
		reason === null ||
		!("name" in reason) ||
		!("message" in reason) ||
		!("stack" in reason) ||
		reason.name !== "TypeError" ||
		typeof reason.message !== "string" ||
		typeof reason.stack !== "string"
	) {
		return false;
	}

	const sourceBuildFailure =
		SOURCE_DEBUG_ERROR_FAILURE.test(reason.message) &&
		reason.stack.includes("#doAcquireWorlds") &&
		reason.stack.includes("FrameManager.js");
	const bundledBuildFailure =
		reason.message === BUNDLED_DEBUG_ERROR_FAILURE && reason.stack.includes(BUNDLED_WORLD_ACQUIRE_FRAME);

	return sourceBuildFailure || bundledBuildFailure;
}

export default function browserStealthDebugErrorExtension(pi: ExtensionAPI) {
	const processState = globalThis as typeof globalThis & Record<PropertyKey, unknown>;
	if (processState[PATCH_STATE] === true) return;
	const logger = pi.logger;

	postmortem.interceptUnhandledRejections(reason => {
		if (!isBrowserStealthDebugError(reason)) return false;

		try {
			logger.warn("Ignoring Puppeteer stealth debugError failure (issue #5296)", {
				err: reason,
			});
		} catch {
			// The interceptor must remain non-throwing: its purpose is to prevent a
			// secondary debug logger failure from entering the process-fatal path.
		}
		return true;
	});

	processState[PATCH_STATE] = true;
}
