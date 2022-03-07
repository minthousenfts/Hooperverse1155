// To debug this code, open wixDefaultCustomElement.js in Developer Tools.

const IMAGE_URL = 'https://wix.to/vUBXBKU';
const H2_TEXT = 'This is a Custom Element';
const H3_1_TEXT = 'View its code by clicking the Settings button and pasting the Server URL into a new browser tab.';
const H3_2_TEXT = 'Explore this code and use it as a reference to create your own element.';
const DEBUG_TEXT = 'Loading the code for Custom Element \'wix-default-custom-element\'. To debug this code, open wixDefaultCustomElement.js in Developer Tools.';

// make the magic happen right here: 
// const checkIfWalletIsConnected = () => {
//     // try accessing window.ethereum
//     const { ethereum } = window

//     if (!ethereum) {
//         alert("You don't have metamask!")
//         return;
//     } else { 
//         console.log("Ethereum found", ethereum)
//     }
// }


const createImage = () => {
  const imageElement = document.createElement('img');
  imageElement.src = IMAGE_URL;
  imageElement.id = 'wdce-image';
  return imageElement;
};

const createH2 = () => {
  const h2Element = document.createElement('h2');
  h2Element.textContent = H2_TEXT;
  h2Element.id = 'wdce-h2';
  return h2Element;
};

const createH3 = (id, text) => {
  const h3Element = document.createElement('h3');
  h3Element.id = id;
  h3Element.textContent = text;
  return h3Element;
};

const createTextContainer = () => {
  const textContainer = document.createElement('div');
  textContainer.id = 'wdce-text-container';
  textContainer.appendChild(createH2());
  textContainer.appendChild(createH3('wdce-h3-1', H3_1_TEXT));
  textContainer.appendChild(createH3('wdce-h3-2', H3_2_TEXT));
  return textContainer;
};

const createImageContainer = () => {
  const imageContainer = document.createElement('div');
  imageContainer.id = 'wdce-image-container';
  imageContainer.appendChild(createImage());
  return imageContainer;
};

const createStyle = () => {
  const styleElement = document.createElement('style');
  styleElement.innerHTML = `
    wix-default-custom-element {
        background-color: #f0f4f7;
        display: flex;
        width: 100%;
        justify-content: center;
      }

    #wdce-image-container {
        width: 35%;
        max-width: 165px;
        display: flex;
        margin: 0 20px 0 30px;
        overflow: hidden;
    }

    #wdce-image {
        width: 100%;
        min-width: 100px;
    }

    #wdce-text-container {
        display: flex;
        flex-direction: column;
        width: 65%;
        justify-content: center;
        max-width: 314px;
        min-width: 200px;
    }

    #wdce-h2 {
        font-family: 'HelveticaNeueW01-45Ligh, HelveticaNeueW02-45Ligh, HelveticaNeueW10-45Ligh, Helvetica Neue, Helvetica, Arial, ãƒ¡ã‚¤ãƒªã‚ª, meiryo, ãƒ’ãƒ©ã‚®ãƒŽè§’ã‚´ pro w3, hiragino kaku gothic pro, sans-serif',
        font-size: 16px;
        font-weight: 500;
        letter-spacing: 0.89px;
        color: #32536a;
        margin: 0 0 16px 0;
    }

    #wdce-h3-1, #wdce-h3-2 {
        font-family: 'HelveticaNeueW01-45Ligh, HelveticaNeueW02-45Ligh, HelveticaNeueW10-45Ligh, Helvetica Neue, Helvetica, Arial, ãƒ¡ã‚¤ãƒªã‚ª, meiryo, ãƒ’ãƒ©ã‚®ãƒŽè§’ã‚´ pro w3, hiragino kaku gothic pro, sans-serif',
        font-size: 14px;
        font-weight: 300;
        line-height: 1.43;
        color: #162d3d;
        margin: 0 0 8px 0;
    }
    `;
  return styleElement;
};

class WixDefaultCustomElement extends HTMLElement {
  constructor() {
    super();
    console.log(DEBUG_TEXT);
  }

  connectedCallback() {
    this.appendChild(createStyle());
    this.appendChild(createImageContainer());
    this.appendChild(createTextContainer());
  }
}
customElements.define('wix-default-custom-element', WixDefaultCustomElement);