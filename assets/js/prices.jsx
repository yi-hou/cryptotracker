import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';
import Select from 'react-select';

export default function run_demo(root, channel) {
    ReactDOM.render(<Demo channel={channel} />, root);
}

class Demo extends React.Component {
    constructor(props) {
        super(props);
        this.channel = props.channel
        this.coinSymbols = ["BTC", "ETH", "XRP", "BCH", "EOS", "LTC", "ADA", "XLM", "NEO", "XMR", "DASH", "TRX", "XEM", "USDT", "VEN", "ETC", "QTUM", "BNB", "ICX", "LSK", "BTG", "PPT", "XVG"],
            this.coinNames = ["Bitcoin", "Ethereum", "Ripple", "Bitcoin Cash", "EOS", "Litecoin", "Cardano", "Stellar", "NEO", "Monero", "Dash", "TRON", "NEM", "Tether", "VeChain", "Ethereum Classic", "Qtum", "Binance Coin", "ICON", "Lisk", "Bitcoin Gold", "Populous", "Verge", "Zcash"],
            this.state = {
                coinSymbols: this.coinSymbols,
                coinNames: this.coinNames,
                coinPRICEPREV: new Array(this.coinSymbols.length).fill("Fetching Data..."),
                coinPRICE: new Array(this.coinSymbols.length).fill("Fetching Data..."),
                coinSUPPLY: new Array(this.coinSymbols.length).fill("Fetching Data..."),
                coinTOTALVOLUME24H: new Array(this.coinSymbols.length).fill("Fetching Data..."),
                coinMKTCAP: new Array(this.coinSymbols.length).fill("Fetching Data..."),
                coinHIGH24HOUR: new Array(this.coinSymbols.length).fill("Fetching Data..."),
                coinLOW24HOUR: new Array(this.coinSymbols.length).fill("Fetching Data..."),
                coinToggle: new Array(this.coinSymbols.length).fill(true),
                selectedExchange: "USD",
                timerId: 0
            };
        this.getData(this.state.selectedExchange)
    }

    handleToggle(coinToggleIndex) {
        var currentCoinToggleState = this.state.coinToggle[coinToggleIndex];
        this.state.coinToggle[coinToggleIndex] = !currentCoinToggleState;
        this.setState({ coinToggle: this.state.coinToggle })
        var buttonToToggle = document.getElementById("toggle-btn" + coinToggleIndex);
        if (this.state.coinToggle[coinToggleIndex]) {
            buttonToToggle.className = "btn";
        } else {
            buttonToToggle.className = "btn-toggle-off";
        }
    }

    getData() {
        var timer = setInterval(() => {
            this.channel.push("fetch_prices", { coinnames: this.state.coinSymbols, currency: this.state.selectedExchange, state: this.state })
                .receive("ok", this.gotView.bind(this))
        }, 2000)
        this.setState({ timerId: timer })
    }

    currencyChanged(currency) {
        clearInterval(this.state.timerId);
        this.setState({ selectedExchange: currency })
    }

    gotView(pricedata) {
        for (var symbols in pricedata) {
            var coinStateIndex = this.state.coinSymbols.indexOf(symbols)
            for (var currency in pricedata[symbols]) {
                var coinData = (pricedata[symbols][currency])
                for (var key in coinData) {
                    if (key == "PRICE") {
                        this.state.coinPRICEPREV[coinStateIndex] = this.state.coinPRICE[coinStateIndex];
                        this.setState({ coinPRICEPREV: this.state.coinPRICEPREV });
                        this.state.coinPRICE[coinStateIndex] = coinData[key];
                        this.setState({ coinPRICE: this.state.coinPRICE });
                    }
                    else if (key == "SUPPLY") {
                        this.state.coinSUPPLY[coinStateIndex] = coinData[key];
                        this.setState({ coinSUPPLY: this.state.coinSUPPLY });
                    }
                    else if (key == "TOTALVOLUME24H") {
                        this.state.coinTOTALVOLUME24H[coinStateIndex] = coinData[key];
                        this.setState({ coinTOTALVOLUME24H: this.state.coinTOTALVOLUME24H });
                    }
                    else if (key == "HIGH24HOUR") {
                        this.state.coinHIGH24HOUR[coinStateIndex] = coinData[key];
                        this.setState({ coinHIGH24HOUR: this.state.coinHIGH24HOUR });
                    }
                    else if (key == "LOW24HOUR") {
                        this.state.coinLOW24HOUR[coinStateIndex] = coinData[key];
                        this.setState({ coinLOW24HOUR: this.state.coinLOW24HOUR });
                    }
                    else if (key == "MKTCAP") {
                        this.state.coinMKTCAP[coinStateIndex] = coinData[key];
                        this.setState({ coinMKTCAP: this.state.coinMKTCAP });
                    }
                }
                if (this.state.coinToggle[coinStateIndex]) {
                    var rowToFlash = document.getElementById("coinRow" + coinStateIndex);
                    if (this.state.coinPRICEPREV == "Fetching Data...") {
                        rowToFlash.className = "flashNeutral";
                    } else if (this.state.coinPRICE[coinStateIndex] > this.state.coinPRICEPREV[coinStateIndex]) {
                        rowToFlash.className = "flashGreen";
                    } else if (this.state.coinPRICE[coinStateIndex] < this.state.coinPRICEPREV[coinStateIndex]) {
                        rowToFlash.className = "flashRed";
                    }
                }
            }
        }
    }

    render() {
        return (
            <div className="container">
                <div className="images">
                    <img src={'https://steemitimages.com/DQmUHN62vCWCZGFdt72jxNzeaaeuMoygfG3Ev9LusyhjA4d/growth-price-dash.jpg'} alt="bg1" className="img-responsive" id="img1" />

                </div>
                <div className="price_container">
                    <div className="checkbox-container">
                        <div className="card">
                            <div className="card-header">
                                Click to toggle view
                        </div>
                            <div className="card-body">
                                {this.state.coinSymbols.map((symbol, index) => {
                                    return <button
                                        type="button"
                                        className="btn"
                                        id={"toggle-btn" + index}
                                        data-toggle="button"
                                        aria-pressed="false"
                                        autoComplete="off"
                                        onClick={() => this.handleToggle(index)}>
                                        {symbol}
                                    </button>
                                })}
                            </div>
                        </div>
                    </div>
                    <div className="table-responsive-lg" id="divPrice">
                        <table id="tPrice" className="table table-dark">
                            <thead>
                                <tr>
                                    <th scope="col">#</th>
                                    <th scope="col">Symbol</th>
                                    <th scope="col">Name</th>
                                    <th scope="col">Price
                                    <select className="dropdown" name="input" label="Change Currency" defaultValue="USD">
                                            <option value="USD" onClick={() => this.currencyChanged("USD")}> USD</option>
                                            <option value="EUR" onClick={() => this.currencyChanged("EUR")}> EUR </option>
                                        </select>
                                    </th>
                                    <th scope="col">Market Cap</th>
                                    <th scope="col">Supply</th>
                                    <th scope="col">Total 24Hour Volume</th>
                                    <th scope="col">24Hour High</th>
                                    <th scope="col">24Hour Low</th>
                                </tr>
                            </thead>
                            <tbody>
                                {this.state.coinToggle.map((toggleValue, index) => {
                                    if (toggleValue) {
                                        return <tr id={"coinRow" + index}>
                                            <th scope="row">{index + 1}</th>
                                            <td><label id="labelSymbol">{this.state.coinSymbols[index]}</label></td>
                                            <td><label id="labelName">{this.state.coinNames[index]}</label></td>
                                            <td><label id="labelPrice">{this.state.coinPRICE[index]}</label></td>
                                            <td><label id="labelMktcap">{this.state.coinMKTCAP[index]}</label></td>
                                            <td><label id="labelSupply">{this.state.coinSUPPLY[index]}</label></td>
                                            <td><label id="labelVol">{this.state.coinTOTALVOLUME24H[index]}</label></td>
                                            <td><label id="labelHigh">{this.state.coinHIGH24HOUR[index]}</label></td>
                                            <td><label id="labelLow">{this.state.coinLOW24HOUR[index]}</label></td>
                                        </tr>
                                    }
                                })}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        )
    }
}
