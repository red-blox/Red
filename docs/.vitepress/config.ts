import { defineConfig } from 'vitepress'

function nav() {
	return [
		{ text: 'Guide', link: '/guide/introduction/what-is-red' },
		{
			text: 'API Reference',
			items: [
				{ text: '2.0', link: '/2.0/Red' },
			]
		},
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
				]
			},
			{
				text: 'Namespaces',
				items: [
					{ text: 'What is a Namespace?', link: '/guide/namespaces/what-is-namespace' },
					{ text: 'Listening to Events', link: '/guide/namespaces/listening-events' },
					{ text: 'Sending and Calling Events', link: '/guide/namespaces/sending-calling-events' },
					{ text: 'Replicating Data', link: '/guide/namespaces/replicating-data' },
				]
			},
			{
				text: 'Networking Optimization',
				items: [
					{ text: 'Identifiers', link: '/guide/optimization/identifiers' },
					{ text: 'Serdes', link: '/guide/optimization/serdes' },
				]
			},
		],

		'/2.0/': [
			{
				text: 'API Reference',
				items: [
					{ text: 'Red', link: '/2.0/Red' },
					{ text: 'Server', link: '/2.0/Server' },
					{ text: 'Client', link: '/2.0/Client' },
					{ text: 'Identifier', link: '/2.0/Identifier' },
					{ text: 'Serdes', link: '/2.0/Serdes' },
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

		nav: nav(),
		sidebar: sidebar(),
	}
})
