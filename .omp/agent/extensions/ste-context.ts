import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";
import type { UserMessage } from "@oh-my-pi/pi-ai";

const STE_REMINDER: UserMessage = {
	role: "user",
	content:
		"LANGUAGE-ONLY REQUIREMENT FOR THE NEXT REPLY: Preserve all required content, evidence, technical detail, decisions, actions, and rigor. Do not omit, weaken, or simplify the task substance. Apply ASD-STE100 Simplified Technical English only to the prose. Use short, direct sentences and simple words. Use one term for one meaning. Do not use idioms, metaphors, filler, or decorative language. Keep exact technical text unchanged. Before sending, check and correct all prose against these rules.",
	synthetic: true,
	attribution: "agent",
	timestamp: 0,
};

export default function steContextExtension(pi: ExtensionAPI) {
	let steEnabled = false;

	pi.registerCommand("ste", {
		description: "off",
		handler: async (_args, ctx) => {
			steEnabled = !steEnabled;
			ctx.ui.notify(`STE is ${steEnabled ? "on" : "off"}`, "info");
		},
	});

	pi.on("session_start", (_event, ctx) => {
		ctx.ui.addAutocompleteProvider((current) => ({
			async getSuggestions(lines, cursorLine, cursorCol) {
				const suggestions = await current.getSuggestions(lines, cursorLine, cursorCol);
				if (!suggestions) return suggestions;

				return {
					...suggestions,
					items: suggestions.items.map((item) =>
						item.value === "ste" ? { ...item, description: steEnabled ? "on" : "off" } : item,
					),
				};
			},
			applyCompletion(lines, cursorLine, cursorCol, item, prefix) {
				return current.applyCompletion(lines, cursorLine, cursorCol, item, prefix);
			},
		}));
	});

	pi.on("context", (event) => {
		if (steEnabled) return { messages: [...event.messages, STE_REMINDER] };
	});
}
