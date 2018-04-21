import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

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
           coinPRICE: [0, 0, 0, 0],
           coinSUPPLY: [0, 0, 0, 0],
           coinTOTALVOLUME24H: [0, 0, 0, 0],
           coinMKTCAP: [0, 0, 0, 0],
           coinHIGH24HOUR: [0, 0, 0, 0],
           coinLOW24HOUR: [0, 0, 0, 0],
           coinToggle: [true, true, true, true],
       };
       this.getAPIDetails()
   }

   handleToggle(coinToggleIndex) {
       var currentCoinToggleState = this.state.coinToggle[coinToggleIndex];
       this.state.coinToggle[coinToggleIndex] = !currentCoinToggleState;
       this.setState({coinToggle: this.state.coinToggle})
   }

   render() {
       return (
           <div className="container">
               <div className="checkbox-container">
                   <div className="alert" role="alert">
                       Click to toggle coin view
                   </div>

               </div>
             <div className="table-container">
               {this.state.coinSymbols.map((symbol, index) => {
                 return <button type="button" className="btn bg-primary btn-coin-toggle"
                       data-toggle="button" aria-pressed="false" autocomplete="off"
                       onClick = {() => this.handleToggle(index)}>
                             {symbol}
                         </button>
               })}
               <table className="table table-dark">
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
                        if (toggleValue){
                               return <tr>
                                       <th scope="row">{index}</th>
                                       <td>{this.state.coinSymbols[index]}</td>
                                       <td>{this.state.coinName[index]}</td>
                                       <td>{this.state.coinPRICE[index]}</td>
                                       <td>{this.state.coinMKTCAP[index]}</td>
                                       <td>{this.state.coinSUPPLY[index]}</td>
                                       <td>{this.state.coinTOTALVOLUME24H[index]}</td>
                                       <td>{this.state.coinHIGH24HOUR[index]}</td>
                                       <td>{this.state.coinLOW24HOUR[index]}</td>
                                       </tr>
                           }
                       })}
                   </tbody>
               </table>
               </div>
               <div>
                   <button type="button" className="btn bg-primary btn-coin-toggle"
                           data-toggle="button" onClick = {() => this.getAPIDetails()}>
                          Fetch Data
                   </button>
               </div>
           </div>
       )
   }

   getAPIDetails() {
       this.channel.push("fetch_prices", { coinnames: this.state.coinSymbols, state: this.state })
           .receive("ok", this.gotView.bind(this))
   }

   gotView(pricedata) {
       for (var symbols in pricedata) {
           var coinStateIndex = this.state.coinSymbols.indexOf(symbols)
           for (var currency in pricedata[symbols]) {
               var coinData = (pricedata[symbols][currency])
               for(var key in coinData) {
                   if(key == "PRICE") {
                       this.state.coinPRICE[coinStateIndex] = coinData[key];
                       this.setState({coinPRICE: this.state.coinPRICE});
                   }
                   else if(key == "SUPPLY") {
                       this.state.coinSUPPLY[coinStateIndex] = coinData[key];
                       this.setState({coinSUPPLY: this.state.coinSUPPLY});
                   }
                   else if(key == "TOTALVOLUME24H") {
                       this.state.coinTOTALVOLUME24H[coinStateIndex] = coinData[key];
                       this.setState({coinTOTALVOLUME24H: this.state.coinTOTALVOLUME24H});
                   }
                   else if(key == "HIGH24HOUR") {
                       this.state.coinHIGH24HOUR[coinStateIndex] = coinData[key];
                       this.setState({coinHIGH24HOUR: this.state.coinHIGH24HOUR});
                   }
                   else if(key == "LOW24HOUR") {
                       this.state.coinLOW24HOUR[coinStateIndex] = coinData[key];
                       this.setState({coinLOW24HOUR: this.state.coinLOW24HOUR});
                   }
                   else if(key == "MKTCAP") {
                       this.state.coinMKTCAP[coinStateIndex] = coinData[key];
                       this.setState({coinMKTCAP: this.state.coinMKTCAP});
                   }
               }
           }
       }
   }
}
