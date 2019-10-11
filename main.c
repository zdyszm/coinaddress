#include <stdio.h>
#include "bip32_bip39.h"
#include "hexutils.h"


#define VERSION_PUBLIC  0x0488b21e  // xpub
#define VERSION_PRIVATE 0x0488ade4 // xprv


int main(int argc,char *argv[]){
	const char *passphrase ="";
	int keylength = 64;
    int COIN_TYPE = 0;

	const char *mnemonic = "vault salon bonus asset raw rapid split balance logic employ fuel atom";

	printf("Mnemonic string : %s \n",mnemonic);
	uint8_t bip39_seed[keylength];

	generateBip39Seeed(mnemonic,bip39_seed,passphrase);
	printHexData("seed = ", (unsigned char *)bip39_seed, keylength);



	char rootkey[112];
	uint32_t fingerprint = 0;
	HDNode node;
	int r = hdnode_from_seed(bip39_seed,64, SECP256K1_NAME, &node);
	if( r != 1 ){
		printf("hdnode_from_seed failed (%d).", r);
		return -1;
	}

	hdnode_fill_public_key(&node);


	r = hdnode_serialize_private(&node, fingerprint, PRIVKEY_PREFIX, rootkey, sizeof(rootkey));
	if ( r <= 0 ){
		printf("hdnode_serialize_private failed (%d).", r);
		return -1;
	}

	printf("root private key:%s\n",rootkey);

	r = hdnode_serialize_public(&node, fingerprint, PUBKEY_PREFIX, rootkey, sizeof(rootkey));
	if (r <= 0) {
	   printf("hdnode_serialize_public failed (%d).", r);
	   return -1;
	}
	printf("root  public key:%s\n",rootkey);

	// m/44'/coin/0'/0/0   m/49/coin/0/0/0
	hdnode_private_ckd_prime(&node, 44);
    hdnode_private_ckd_prime(&node, COIN_TYPE);
	hdnode_private_ckd_prime(&node, 0);
	hdnode_private_ckd(&node, 0);
	fingerprint = hdnode_fingerprint(&node);
	hdnode_private_ckd(&node, 0);
	hdnode_fill_public_key(&node);

	hdnode_serialize_private(&node, fingerprint, PRIVKEY_PREFIX, rootkey, sizeof(rootkey));
	if (r <= 0) {
		printf("hdnode_serialize_private failed (%d).", r);
	   return -1;
	}

	printHexData("child hex private key = ", (unsigned char *)node.private_key, 32);

	hdnode_serialize_public(&node, fingerprint, PUBKEY_PREFIX, rootkey, sizeof(rootkey));
	if (r <= 0) {
		printf("hdnode_serialize_public failed (%d).", r);
	   return -1;
	 }

	printHexData("child hex public key = ", (unsigned char *)node.public_key, 33);

	 return 0;



}


