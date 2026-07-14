import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

const AZURE_PROVIDER = "azure";
const GPT_56_MODEL_PREFIX = "gpt-5.6";

type ProviderPayload = Record<string, unknown> & {
	reasoning?: Record<string, unknown>;
};

function isProviderPayload(payload: unknown): payload is ProviderPayload {
	return typeof payload === "object" && payload !== null && !Array.isArray(payload);
}

export default function gptProExtension(pi: ExtensionAPI) {
	let proEnabled = false;

	pi.registerCommand("gpt-pro", {
		description: "Toggle GPT-5.6 pro reasoning mode for Azure",
		handler: async (_args, ctx) => {
			const model = ctx.models.current();
			if (model?.provider !== AZURE_PROVIDER || !model.id.startsWith(GPT_56_MODEL_PREFIX)) {
				ctx.ui.notify("/gpt-pro requires an Azure GPT-5.6 model", "warning");
				return;
			}

			proEnabled = !proEnabled;
			ctx.ui.notify(`GPT pro reasoning mode ${proEnabled ? "enabled" : "disabled"}`, "info");
		},
	});

	pi.on("before_provider_request", async (event, ctx) => {
		const model = ctx.models.current();
		if (
			model?.provider !== AZURE_PROVIDER ||
			!model.id.startsWith(GPT_56_MODEL_PREFIX) ||
			!isProviderPayload(event.payload)
		) {
			return;
		}

		if (!proEnabled) {
			return;
		}

		const reasoning = isProviderPayload(event.payload.reasoning) ? event.payload.reasoning : {};
		return {
			...event.payload,
			reasoning: {
				...reasoning,
				mode: "pro",
			},
		};
	});
}
