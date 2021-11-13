async function increase(duration) {

    //increase time
    await web3.currentProvider.sendAsync({
        jsonrpc: "2.0",
        method: "evm_increaseTime",
        params: [duration], // duration must be at least 86400 (seconds in a day)
        id: new Date().getTime()
    }, () => {});

    //mine a new block
    web3.currentProvider.send({
        jsonrpc: '2.0',
        method: 'evm_mine',
        params: [],
        id: new Date().getTime()
    })

}

const duration = {

    seconds: function (val) {
        return val;
    },
    minutes: function (val) {
        return val * this.seconds(60);
    },
    hours: function (val) {
        return val * this.minutes(60);
    },
    days: function (val) {
        return val * this.hours(24);
    },
}

module.exports = {
    increase,
    duration,
};
