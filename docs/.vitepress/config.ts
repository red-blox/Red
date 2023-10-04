import { defineConfig } from 'vitepress'

function nav() {
	return [
		{ text: 'FAQ', link: '/faq' },
		{ text: 'Guide', link: '/guide/introduction/what-is-red' },
		{ text: 'API Reference', link: '/2.0/Red' },
	]
}

function sidebar() {
	return {
		'/guide/': [
			{
				text: 'Introduction',
				items: [
					{ text: 'What is Red?', link: '/guide/introduction/what-is-red' },
					{ text: 'Getting Started', link: '/guide/introduction/getting-started' },
					{ text: 'Redblox', link: '/guide/introduction/redblox' },
				]
			},
			{
				text: 'Events',
				items: [
					{ text: 'Declaring Events', link: '/guide/events/declaring' },
					{ text: 'Server Usage', link: '/guide/events/server' },
					{ text: 'Client Usage', link: '/guide/events/client' },
				]
			},
			{
				text: 'Functions',
				link: '/guide/functions',
			},
		],

		'/2.0/': [
			{
				text: 'API Reference',
				items: [
					{ text: 'Red', link: '/2.0/Red' },
					{
						text: 'Event',
						link: '/2.0/Event',
						items: [
							{ text: 'Server', link: '/2.0/Event/Server' },
							{ text: 'Client', link: '/2.0/Event/Client' },
						]
					},
					{ text: 'Function', link: '/2.0/Function' },
				],
			}
		],
	}
}

export default defineConfig({
	title: 'Red',
	description: 'A simple, fast, and powerful networking library.',
	lang: 'en-US',
	head: [
		['link', { rel: 'icon', href: '/favicon.png' }],
	],

	themeConfig: {
		logo: '/logo.png',
		siteTitle: false,
		outline: 'deep',

		socialLinks: [
			{ icon: 'github', link: 'https://github.com/red-blox/red' },
			{ icon: 'discord', link: 'https://discord.gg/mchCdAFPWU' },
		],

		search: {
			provider: 'algolia',
			options: {
				appId: 'OXUAMIFLZV',
				apiKey: 'b30ea2870076353706bb93154da80143',
				indexName: 'red',

			}
		},

		nav: nav(),
		sidebar: sidebar(),
	},
})
