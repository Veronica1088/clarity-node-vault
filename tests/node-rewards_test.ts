import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Test reward distribution",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const wallet1 = accounts.get("wallet_1")!;

    // First register a node
    let block = chain.mineBlock([
      Tx.contractCall(
        "node-vault",
        "register-node",
        [types.uint(100000)],
        wallet1.address
      )
    ]);

    // Test reward distribution
    let rewardBlock = chain.mineBlock([
      Tx.contractCall(
        "node-rewards",
        "distribute-rewards",
        [types.principal(wallet1.address)],
        deployer.address
      )
    ]);
    
    assertEquals(rewardBlock.receipts[0].result.expectOk(), true);
  },
});
