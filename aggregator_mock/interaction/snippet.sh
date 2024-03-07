PEM="~/pems/dev.pem"

ADDRESS=$(moapy data load --key=address-testnet)
DEPLOY_TRANSACTION=$(moapy data load --key=deployTransaction-testnet)

PROXY=https://devnet-gateway.dharitri.com
CHAIN_ID=D

PROJECT="../../aggregator_mock"

FROM=0x
TO=0x
PRICE=0x

GAS_LIMIT=150000000

AGGREGATOR_ADDR=0x

deploy() {
    moapy contract deploy --project=${PROJECT} --recall-nonce --pem=${PEM} \
    --gas-limit=${GAS_LIMIT} --outfile="deploy.json" \
    --proxy=${PROXY} --chain=${CHAIN_ID} --send || return

    TRANSACTION=$(moapy data parse --file="deploy.json" --expression="data['emitted_tx']['hash']")
    ADDRESS=$(moapy data parse --file="deploy.json" --expression="data['emitted_tx']['address']")

    moapy data store --key=address-testnet --value=${ADDRESS}
    moapy data store --key=deployTransaction-testnet --value=${TRANSACTION}

    echo ""
    echo "Smart contract address: ${ADDRESS}"
}

upgrade() {
    moapy contract upgrade ${ADDRESS} --project=${PROJECT} --recall-nonce \
    --pem=${PEM} --gas-limit=${GAS_LIMIT} --outfile="upgrade.json" \
    --proxy=${PROXY} --chain=${CHAIN_ID} --send || return
}

# SC calls

set_price() {
    moapy contract call ${ADDRESS} --recall-nonce --pem=${PEM} --gas-limit=${GAS_LIMIT} \
    --function="setLatestPriceFeed" --arguments ${FROM} ${TO} ${PRICE} \
    --proxy=${PROXY} --chain=${CHAIN_ID} --send
}
