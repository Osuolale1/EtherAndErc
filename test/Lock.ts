import { ethers } from 'hardhat';
import { Contract, Signer } from 'ethers';
import { expect } from 'chai';

describe('fem ERC20 Contract', function () {
  let FemToken: Contract;
  let femToken: Contract;
  let owner: Signer;
  let user: Signer;

  beforeEach(async function () {
    [owner, user] = await ethers.getSigners();

    // Deploying the ERC20 contract
    const FemTokenFactory = await ethers.getContractFactory('FemToken');
    FemToken = await FemTokenFactory.deploy();
    await FemToken.deployed();
    femToken = FemToken.connect(user);
  });

  it('should deploy with correct name and symbol', async function () {
    const name = await femToken.name();
    const symbol = await femToken.symbol();

    expect(name).to.equal('fem');
    expect(symbol).to.equal('FM');
  });

  it('should mint initial supply to the deployer', async function () {
    const initialSupply = await femToken.balanceOf(await owner.getAddress());
    expect(initialSupply).to.equal(1000000000000000000000); // 1000 tokens with 18 decimal places
  });

  it('should allow minting', async function () {
    const recipientAddress = await user.getAddress();
    const amountToMint = ethers.utils.parseEther('100');

    // Minting tokens
    await femToken.mint(recipientAddress, amountToMint);

    // Checking recipient balance after minting
    const recipientBalance = await femToken.balanceOf(recipientAddress);
    expect(recipientBalance).to.equal(amountToMint);
  });
});
