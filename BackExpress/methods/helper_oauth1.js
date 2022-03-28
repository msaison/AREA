const crypto = require('crypto');
const oauth1a = require('oauth-1.0a');

const consumerKey = 'tvdiJfiaDxmvhlu7ezVoRHeL0';
const consumerSecret = 'JwL7Me8oRWNyABZoLQYjK3brjoq90hhcTR6q0mfThCNsfluzpG';

class Oauth1Helper {
    static getAuthHeaderForRequest(request, tokenKey, secretKey) {
        const oauth = oauth1a({
            consumer: { key: consumerKey, secret: consumerSecret },
            signature_method: 'HMAC-SHA1',
            hash_function(base_string, key) {
                return crypto
                    .createHmac('sha1', key)
                    .update(base_string)
                    .digest('base64')
            },
        })

        const authorization = oauth.authorize(request, {
            key: tokenKey,
            secret: secretKey,
        });

        return oauth.toHeader(authorization);
    }
}

module.exports = Oauth1Helper;