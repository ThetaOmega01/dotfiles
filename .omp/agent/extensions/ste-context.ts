import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";
import type { UserMessage } from "@oh-my-pi/pi-ai";

const STE_REMINDER: UserMessage = {
	role: "user",
	content:
		"Apply ASD-STE100 Simplified Technical English to all prose in the next reply. This rule controls language only. It does not change requirements for content, evidence, technical detail, decisions, actions, or rigor. Use short, direct sentences and simple words. Use one term for one meaning. Do not use idioms, metaphors, filler, or decorative language. Keep exact technical text unchanged. Check the prose before sending.",
	synthetic: true,
	attribution: "agent",
	timestamp: 0,
};

export default function steContextExtension(pi: ExtensionAPI) {
	let steEnabled = false;

	pi.registerCommand("ste", {
		description: "Turn the STE language reminder on or off",
		handler: async (_args, ctx) => {
			steEnabled = !steEnabled;
			ctx.ui.notify(`STE is ${steEnabled ? "on" : "off"}`, "info");
		},
	});

	pi.on("context", (event) => {
		if (!steEnabled) return;

		event.messages.push(STE_REMINDER);
		return { messages: event.messages };
	});
}
