'use strict';

const expect = require('chai').expect;
const encode = require('../index');

describe('EncodeUrl', () => {
  it('should return TypeError if website url is not valid', () => {
    const original = 'http:///';
    expect(() => encode(original)).to.throw(TypeError);
  });

  it('should not change normal URLs', () => {
    const original = 'http://www.google.com:80/index.html?search=yes&no=false#top';
    expect(encode(original)).to.equal(original);
  });

  it('should encoded URLs with special characters', () => {
    const original = 'http://www.test.com:80/i/süß-a.jpg?ö=1&å=yes#ä1';
    const encoded = 'http://www.test.com:80/i/s%C3%BC%C3%9F-a.jpg?%C3%B6=1&%C3%A5=yes#%C3%A41';
    expect(encode(original)).to.equal(encoded);
  });

  it('should handle already encoded URLs', () => {
    const original = 'http://www.test.com:80/i/s%C3%BC%C3%9F-a.jpg?%C3%B6=1&%C3%A5=yes#%C3%A41';
    const encoded = 'http://www.test.com:80/i/s%C3%BC%C3%9F-a.jpg?%C3%B6=1&%C3%A5=yes#%C3%A41';
    expect(encode(original)).to.equal(encoded);
  });

  it('should handle partly encoded URLs', () => {
    const original = 'http://www.test.com:80/i/süß-a.jpg?%C3%B6=1&%C3%A5=yes#%C3%A41';
    const encoded = 'http://www.test.com:80/i/s%C3%BC%C3%9F-a.jpg?%C3%B6=1&%C3%A5=yes#%C3%A41';
    expect(encode(original)).to.equal(encoded);
  });

  it('should throw InvalidArgumentError for malformed URL components', () => {
    const original = 'http://www.test.com:80/i/P%E4ron.jpg?%C3%B6=1&%C3%A5=yes#%C3%A41';
    expect(() => encode(original)).to.throw(TypeError);
  });
});
