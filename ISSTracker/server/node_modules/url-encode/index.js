'use strict';

const validation = require('valido');

function encode(url) {
  if (!validation.isUrl(url)) {
    throw new TypeError('Invalid URL');
  }

  try {
    // Make sure that URL is decoded
    // before encoding it
    const decodedUrl = decodeURI(url);

    if (decodedUrl === url) {
      return encodeURI(url);
    }

    return encode(decodedUrl);
  } catch (err) {
    throw new TypeError('Url is malformed');
  }
}

module.exports = encode;
