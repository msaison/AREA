const auths = {
    GOOGLE:  "GOOGLE",
    TWITTER: "TWITTER",
    GITHUB:  "GITHUB",
    DISCORD: "DISCORD",
    CRONHOOK: "CRONHOOK",
    YAMMER: "YAMMER"
}

const auth_controllers = {
    GOOGLE: 'require("../auths/google_auth")',
    GITHUB: 'require("../auths/github_auth")',
    TWITTER: 'require("../auths/twitter_auth")',
    DISCORD: 'require("../auths/discord_auth")',
    CRONHOOK: 'require("../auths/cronhook_auth")',
    YAMMER: 'require("../auths/yammer_auth")',
}

var auths_config = [
    {
        type: auths.GOOGLE,
        name: "Google",
        code_hex: '23448A',
        logo: 'https://applets.imgix.net/https%3A%2F%2Fassets.ifttt.com%2Fimages%2Fchannels%2F65067518%2Ficons%2Fmonochrome_large.png?w=240&h=240&s=9f7fc113fc28ffd36d22f76c275859e8',
    },
    {
        type: auths.TWITTER,
        name: "Twitter",
        code_hex: '00AAEC',
        logo: 'https://applets.imgix.net/https%3A%2F%2Fassets.ifttt.com%2Fimages%2Fchannels%2F2%2Ficons%2Fmonochrome_large.png?w=240&h=240&auto=compress&s=81ba2f4f9a4e4fd0c656007e4525b88b',
    },
    {
        type: auths.GITHUB,
        name: "Github",
        code_hex: '4078C0',
        logo: 'https://applets.imgix.net/https%3A%2F%2Fassets.ifttt.com%2Fimages%2Fchannels%2F2107379463%2Ficons%2Fmonochrome_large.png?w=240&h=240&s=8a19bbc158996d098e2fb18310ba7f33',
    },
    {
        type: auths.DISCORD,
        name: "Discord",
        code_hex: '7288DA',
        logo: 'https://applets.imgix.net/https%3A%2F%2Fassets.ifttt.com%2Fimages%2Fchannels%2F179823445%2Ficons%2Fmonochrome_large.png?w=240&h=240&s=51920006e4d6ef7899d0702060f58137',
    },
    {
        type: auths.YAMMER,
        name: "Yammer",
        code_hex: '4c8daf',
        logo: 'https://lh3.googleusercontent.com/d/1u4hS51A5x_O7FCNhwCuieYF6TfVHK4-B=w240-h240?authuser=0',
    },
    {
        type: auths.CRONHOOK,
        name: "CronHook",
        code_hex: '333333',
        logo: 'https://applets.imgix.net/https%3A%2F%2Fassets.ifttt.com%2Fimages%2Fchannels%2F3%2Ficons%2Fmonochrome_large.png?w=240&h=240&s=9f8602f11061e70fe39ea473cbd3d71a',
    }
]

function isMobile(req) {
    const toMatch = [
        /Android/i,
        /webOS/i,
        /iPhone/i,
        /iPad/i,
        /iPod/i,
        /BlackBerry/i,
        /Windows Phone/i
    ];

    return toMatch.some((toMatchItem) => {
        return req.headers['user-agent'].match(toMatchItem);
    });
}

module.exports = {auths: auths, auth_controllers: auth_controllers, auths_config: auths_config, isMobile: isMobile}