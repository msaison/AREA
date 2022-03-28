const auths = require('../config/authconfig').auths

const services = {
    GMAIL:          "GMAIL",
    TWITTER:        "TWITTER",
    GITHUB:         "GITHUB",
    DISCORD:        "DISCORD",
    YAMMER:         "YAMMER",
    CRONHOOK:       "CRONHOOK",
}

const service_controllers = {
    GMAIL:  'require("../services/gmail_service")',
    GITHUB:  'require("../services/github_service")',
    TWITTER:  'require("../services/twitter_service")',
    DISCORD:  'require("../services/discord_service")',
    CRONHOOK:  'require("../services/cronhook_service")',
    YAMMER:  'require("../services/yammer_service")',
}


var services_config = [
    {
        type: services.GMAIL,
        name: 'Gmail',
        logo: 'https://applets.imgix.net/https%3A%2F%2Fassets.ifttt.com%2Fimages%2Fchannels%2F33%2Ficons%2Fmonochrome_large.png?w=240&h=240&s=2c5be4317026c104943378c75f40de47',
        code_hex: '23448A',
        desc: 'Connect Gmail to send emails to yourself and others.',
        reactions: [
                {
                    type: 'send_email',
                    desc: 'Send email to specific email',
                    desc_applet: ', then Send an email to',
                    params: [
                        {
                            name: 'to',
                            type: 'string',
                            desc: 'Email to send to'
                        },
                    ]
                },
            ],
        actions: [],
        available_auths: [auths.GOOGLE]
    },
    {
        type: services.TWITTER,
        name: 'Twitter',
        logo: 'https://applets.imgix.net/https%3A%2F%2Fassets.ifttt.com%2Fimages%2Fchannels%2F2%2Ficons%2Fmonochrome_large.png?w=240&h=240&auto=compress&s=81ba2f4f9a4e4fd0c656007e4525b88b',
        code_hex: '00AAEC',
        desc: 'Twitter Applets can help you manage and save tweets, keep an eye on #hashtags, and much more.',
        reactions: [
            {
                type: 'post_tweet',
                desc: 'Post a tweet',
                desc_applet: ', then post a tweet.',
                params: []
            },
            {
                type: 'change_desc',
                desc: 'Change profile description',
                desc_applet: ', then change description.',
                params: []
            },
        ],
        actions: [],
        available_auths: [auths.TWITTER]
    },
    {
        type: services.GITHUB,
        name: 'Github',
        logo: 'https://applets.imgix.net/https%3A%2F%2Fassets.ifttt.com%2Fimages%2Fchannels%2F2107379463%2Ficons%2Fmonochrome_large.png?w=240&h=240&s=8a19bbc158996d098e2fb18310ba7f33',
        code_hex: '4078C0',
        desc: 'GitHub is the best place to share code with friends, co-workers, classmates, and complete strangers.',
        reactions: [
            {
                type: 'create_issue',
                desc: 'Create an issue',
                desc_applet: 'Create an issue',
                params: [
                    {
                        name: 'repo',
                        type: 'string',
                        desc: 'Repo to create issue in'
                    },
                    {
                        name: 'title',
                        type: 'string',
                        desc: 'Title of the issue'
                    },
                    {
                        name: 'body',
                        type: 'string',
                        desc: 'Body of the issue'
                    },
                ]
            },
            {
                type: 'create_pull_request',
                desc: 'Create a pull request',
                desc_applet: 'Create a pull request',
                params: [
                    {
                        name: 'repo',
                        type: 'string',
                        desc: 'Repo to create pull request in'
                    },
                    {
                        name: 'head',
                        type: 'string',
                        desc: 'Head of the pull request'
                    },
                    {
                        name: 'base',
                        type: 'string',
                        desc: 'Base of the pull request'
                    },
                    {
                        name: 'title',
                        type: 'string',
                        desc: 'Title of the pull request'
                    },
                    {
                        name: 'body',
                        type: 'string',
                        desc: 'Body of the pull request'
                    },
                ]
            }
        ],
        actions: [
            {
                type: 'new_commit',
                desc: 'Any new commit',
                desc_applet: 'If a new commit pushed',
                event: 'push',
                params: [
                    {
                        name: 'repo',
                        type: 'string',
                        desc: 'Name of the repository to watch'
                    },
                    {
                        name: 'branch',
                        type: 'string',
                        desc: 'Name of the branch to watch (leave blank for all branches)'
                    },
                ]
            },
            {
                type: 'new_issue',
                desc: 'Any new issue',
                desc_applet: 'If a new issue created',
                event: 'issues',
                params: [
                    {
                        name: 'repo',
                        type: 'string',
                        desc: 'Name of the repository to watch'
                    },
                ]
            },
            {
                type: 'closed_issue',
                desc: 'Any issue closed',
                desc_applet: 'If an issue closed',
                event: 'issues',
                params: [
                    {
                        name: 'repo',
                        type: 'string',
                        desc: 'Name of the repository to watch'
                    },
                ]
            },
            {
                type: 'on_issue_edit',
                desc: 'Specific issue was edited',
                desc_applet: 'If a specific issue was edited',
                event: 'issues',
                params: [
                    {
                        name: 'repo',
                        type: 'string',
                        desc: 'Name of the repository to watch'
                    },
                    {
                        name: 'issue_id',
                        type: 'string',
                        desc: 'Number of the issue to watch'
                    },
                ]
            },
            {
                type: 'new_pull_request',
                desc: 'Any new pull request',
                desc_applet: 'If a new pull request created',
                event: 'pull_request',
                params: [
                    {
                        name: 'repo',
                        type: 'string',
                        desc: 'Name of the repository to watch'
                    },
                ]
            },
            {
                type: 'closed_pull_request',
                desc: 'Any pull request closed',
                desc_applet: 'If a pull request closed',
                event: 'pull_request',
                params: [
                    {
                        name: 'repo',
                        type: 'string',
                        desc: 'Name of the repository to watch'
                    },
                ]
            },
            {
                type: 'on_pull_request_edit',
                desc: 'Specific pull request was edited',
                desc_applet: 'If a specific pull request was edited',
                event: 'pull_request',
                params: [
                    {
                        name: 'repo',
                        type: 'string',
                        desc: 'Name of the repository to watch'
                    },
                    {
                        name: 'pull_request_id',
                        type: 'string',
                        desc: 'Number of the pull request to watch'
                    },
                ]
            },
        ],
        available_auths: [auths.GITHUB]
    },
    {
        type: services.DISCORD,
        name: 'Discord',
        logo: 'https://applets.imgix.net/https%3A%2F%2Fassets.ifttt.com%2Fimages%2Fchannels%2F179823445%2Ficons%2Fmonochrome_large.png?w=240&h=240&s=51920006e4d6ef7899d0702060f58137',
        code_hex: '7288DA',
        desc: 'Whether you’re part of a school club, gaming group, worldwide art community, or just a handful of friends that want to spend time together, Discord makes it easy to talk every day and hang out more often.',
        reactions: [
            {
                type: 'post_message_channel_discord',
                desc: 'Post a message on a given channel',
                desc_applet: ', then post a message on a given channel.',
                params: []
            },
        ],
        actions: [
            {
                type: 'new_message_on_channel',
                desc: 'Listen message on given channel',
                desc_applet: 'If message post on channel',
                params: []
            },
        ],
        available_auths: [auths.DISCORD]
    },
    {
        type: services.YAMMER,
        name: 'Yammer',
        logo: 'https://lh3.googleusercontent.com/d/1u4hS51A5x_O7FCNhwCuieYF6TfVHK4-B=w240-h240?authuser=0',
        code_hex: '4c8daf',
        desc: "Sans aucun doute l''un des pires réseaux pour communiqué.",
        reactions: [
            {
                type: 'send_private',
                desc: 'Send a private message',
                desc_applet: ', then send a private message.',
                params: [
                    {
                        name: 'email',
                        type: 'string',
                        desc: "Email of the person how wan''t to send it"
                    },
                ]
            },
        ],
        actions: [],
        available_auths: [auths.YAMMER]
    },
    {
        type: services.CRONHOOK,
        name: 'CronHook',
        logo: 'https://applets.imgix.net/https%3A%2F%2Fassets.ifttt.com%2Fimages%2Fchannels%2F3%2Ficons%2Fmonochrome_large.png?w=240&h=240&s=9f8602f11061e70fe39ea473cbd3d71a',
        code_hex: '333333',
        desc: 'CronHook is a simple, easy-to-use, and powerful tool for scheduling events.',
        reactions: [],
        actions: [
            {
                type: 'on_cron',
                desc: 'On a specific cron',
                desc_applet: 'If a specific cron was triggered',
                params: [
                    {
                        name: 'cron',
                        type: 'string',
                        desc: 'Cron expression to watch see (https://crontab.guru/)'
                    },
                ]
            },
            {
                type: 'run_at_time',
                desc: 'Run at a specific time',
                desc_applet: 'If a specific time was reached',
                params: [
                    {
                        name: 'time',
                        type: 'datetime',
                        desc: 'Time to watch'
                    },
                ]
            }
        ],
        available_auths: [auths.CRONHOOK]
    }
]

module.exports = {services: services, services_config: services_config, service_controllers: service_controllers}