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
        this.state = {
            coinSymbols: ["BTC", "ETH", "LTC", "BCH"],
            coinName: ["Bitcoin", "Ethereum", "Litecoin", "Bitcoin Cash"],
            coinPRICEPREV: ["Fetching Data...", "Fetching Data...", "Fetching Data...", "Fetching Data..."],
            coinPRICE: ["Fetching Data...", "Fetching Data...", "Fetching Data...", "Fetching Data..."],
            coinSUPPLY: ["Fetching Data...", "Fetching Data...", "Fetching Data...", "Fetching Data..."],
            coinTOTALVOLUME24H: ["Fetching Data...", "Fetching Data...", "Fetching Data...", "Fetching Data..."],
            coinMKTCAP: ["Fetching Data...", "Fetching Data...", "Fetching Data...", "Fetching Data..."],
            coinHIGH24HOUR: ["Fetching Data...", "Fetching Data...", "Fetching Data...", "Fetching Data..."],
            coinLOW24HOUR: ["Fetching Data...", "Fetching Data...", "Fetching Data...", "Fetching Data..."],
            coinToggle: [true, true, true, true],
            selectedExchange: "USD",
            timerId: 0
        };
        this.getData(this.state.selectedExchange)
    }

    handleToggle(coinToggleIndex) {
        var currentCoinToggleState = this.state.coinToggle[coinToggleIndex];
        this.state.coinToggle[coinToggleIndex] = !currentCoinToggleState;
        this.setState({ coinToggle: this.state.coinToggle })
    }

    render() {
        this.changeColor();
        return (
            <div className="container">
                <div className="checkbox-container">
                    <div className="card">
                        <div className="card-header">
                            Click to toggle view
                    </div>
                        <div className="card-body">
                            {this.state.coinSymbols.map((symbol, index) => {
                                return <button
                                    type="button"
                                    className="btn btn-primary btn-coin-toggle"
                                    data-toggle="button"
                                    aria-pressed="false"
                                    autocomplete="off"
                                    onClick={() => this.handleToggle(index)}>
                                    {symbol}
                                </button>
                            })}
                            <select name="input" label="Change Currency" defaultValue="USD">
                                <option value="USD" onClick={() => this.currencyChanged("USD")}> USD</option>
                                <option value="EUR" onClick={() => this.currencyChanged("EUR")}> EUR </option>
                            </select>
                        </div>
                    </div>
                </div>
                <div id="divPrice">
                    <table id="tPrice" className="table table-dark">
                        <thead>
                            <tr>
                                <th scope="col">#</th>
                                <th scope="col">Symbol</th>
                                <th scope="col">Name</th>
                                <th scope="col">Price</th>
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
                                    return <tr>
                                        <th scope="row">{index + 1}</th>
                                        <td>
                                            <label id="labelSymbol">{this.state.coinSymbols[index]}</label></td>
                                        <td><label id="labelName">{this.state.coinName[index]}</label></td>
                                        <td><label onLoad='changeColor()' id="labelPrice">{this.state.coinPRICE[index]}</label></td>
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
        )
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

    changeColor() {
        var cp = [];
        cp = this.state.coinPRICE
        var cpp = [];
        cpp = this.state.coinPRICEPREV
        var rows = document.getElementsByTagName("tr")
        for (var i = 1; i < rows.length; i++) {
            var row = rows[i];
            var cells = row.getElementsByTagName('td');
            var cell = cells[2]
            if (cp[i - 1] > cpp[i - 1] || cpp[i - 1] == 0) {
                cell.style.color = "green"
                row.style.backgroundColor = "green"
                row.style.backgroundColor = "black"

            }
            else if (cp[i - 1] < cpp[i - 1]) {
                cell.style.color = "red"
                row.style.backgroundColor = "red"
                row.style.backgroundColor = "black"
            }
        }
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
            }
        }
    }
}