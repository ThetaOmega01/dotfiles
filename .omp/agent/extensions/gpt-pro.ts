import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

export default function gptProExtension(pi: ExtensionAPI) {
	let proEnabled = false;

	pi.registerCommand("gpt-pro", {
		description: "Toggle GPT-5.6 pro reasoning mode for Azure",
		handler: async (_args, ctx) => {
			const model = ctx.model;
			if (!proEnabled && (model?.provider !== "azure" || !model.id.startsWith("gpt-5.6"))) {
				ctx.ui.notify("/gpt-pro requires an Azure GPT-5.6 model", "warning");
				return;
			}
			proEnabled = !proEnabled;
			ctx.ui.notify(`GPT pro reasoning mode ${proEnabled ? "enabled" : "disabled"}`, "info");
		},
	});

	pi.on("before_provider_request", (event, ctx) => {
		const model = ctx.model;
		if (!proEnabled || model?.provider !== "azure" || !model.id.startsWith("gpt-5.6")) return;
		// Responses API request body: always an object; `reasoning` is an optional object.
		const payload = event.payload as { reasoning?: object };
		return { ...payload, reasoning: { ...payload.reasoning, mode: "pro" } };
	});
}
