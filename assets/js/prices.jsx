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

       this.channel.join()
      .receive("ok", tnis.reloadPage())
      .receive("error", resp => { console.log("Unable to join", resp) })

        console.log("jsk")
        setInterval(() => {
            this.reloadPage()
        }, 3000);

    }

    render() {
        <div><p>jdhfjs</p></div>
        console.log("jsk")
        setInterval(() => {
            this.reloadPage()
        }, 3000);

    }

    gotView(bc) {
        console.log("hh", bc)
    }

    reloadPage() {
        console.log("hello");
        this.channel.push("fetch_prices", {})
            .receive("ok", this.gotView.bind(this))
    }

}

