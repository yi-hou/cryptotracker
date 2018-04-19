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

            checkedValues: [],
            priceData: [],
            
       
        };


    }

    handleCheck(name) {
        this.setState({
            checkedValues: [...this.state.checkedValues, name]
        });
        
      }

    render() {
        return (

            <div className="container">
                <p> Please select the crypto currencies you wish to monitor </p>
                <input type="checkbox"
                    value="ETH" onChange={this.handleCheck.bind(this, "ETH")} 

                />
                <label>Ethereum</label>
                <br />
                <input type="checkbox"
                    value="BTC" onChange={this.handleCheck.bind(this, "BTC")} 

                />
                <label>BitCoin</label>
                <br />
                <input type="checkbox"
                    value="LTC" onChange={this.handleCheck.bind(this, "LTC")} 
                />
                <label>LiteCoin</label>

                <br />

                <button  className="button" 
                   onClick={ () => this.getAPIDetails()}>Fetch Prices</button>

            </div>
            
            

        )
    }

    getAPIDetails() {
        console.log(this.state)
        this.channel.push("fetch_prices", {coinnames: this.state.checkedValues, state: this.state})
        .receive("ok", this.gotView.bind(this))
    }

    gotView(pricedata)
    {
       
        this.setState({
            priceData: pricedata
            
        });
        console.log(this.state)


    }

    reloadPage() {
        console.log(this.state)
        this.channel.push("fetch_prices", {})
            .receive("ok", this.gotView.bind(this))
    }

}

