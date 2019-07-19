#! /usr/bin/env bash
_FROM="0x77De151AA7e619CD887462fC41365F628CC4B203"
_NETWORK="ropsten"

#rinkeby
#_MASTER_MINTER="0x96ec83a953533463ae2f3d2d80c4d10a573e044b"
#_BLACK_LISTER="0x96ec83a953533463ae2f3d2d80c4d10a573e044b"
#_PAUSER="0x96ec83a953533463ae2f3d2d80c4d10a573e044b"
#_OWNER="0x96ec83a953533463ae2f3d2d80c4d10a573e044b"
#_ADMIN="0x96ec83a953533463ae2f3d2d80c4d10a573e044b"


#ropsten
_MASTER_MINTER="0x8d22df2734f37f4046ab5a9cfea6bc70e509a249"
_BLACK_LISTER="0x8d22df2734f37f4046ab5a9cfea6bc70e509a249"
_PAUSER="0x8d22df2734f37f4046ab5a9cfea6bc70e509a249"
_OWNER="0x8d22df2734f37f4046ab5a9cfea6bc70e509a249"
_ADMIN="0x8d22df2734f37f4046ab5a9cfea6bc70e509a249"

_ARGS="'\"cCLP Fiat Token\",\"cCLP\",18,$_MASTER_MINTER,$_BLACK_LISTER,$_PAUSER,$_OWNER'"

echo "$_ARGS"
echo "$_NETWORK"
zos compile
echo "zos create FiatToken --network $_NETWORK --init initialize --args $_ARGS --from $_FROM -v"
#zos push --network $_NETWORK  --from $_FROM -v
echo "zos set-admin FiatToken "$_ADMIN" --from "$_FROM""