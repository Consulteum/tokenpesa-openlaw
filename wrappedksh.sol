//Compatible Solidity Compiler Version

pragma solidity ^0.5.0;

/*
This Wrapped KSH Token contract is based on the ERC20 token contract standard. Additional
functionality has been integrated:
*/

contract WrappedKSH {

    string public constant name = "Wrapped KSH";
    string public constant symbol = "WKSH";
    uint8 public constant decimals = 18;
    
  //database to match agent accounts (TokenPesa DAO members) and their respective reputation units
  mapping(address => uint) public reputation;

  //minimum reputation units needed to act as an agent/arbiter
   uint public minReputation;

  //constant agent minting and burning parameter
  uint public constantWKSH;
    	
//database to match user accounts and their respective Wrapped KSH token balances
  mapping(address => uint) _balances;
  
  
  mapping(address => mapping( address => uint )) _approvals;
  

  mapping(address => pendingMint) awaitingMint;
  mapping(address => pendingBurn) awaitingBurn;
  
  struct pendingMint
  {
      bool pendingMinter;
      uint pendingM;
  }
  
   struct pendingBurn
   {
      
      bool pendingBurner;
      uint pendingB;
  }      

  uint public totalMints;
  uint public totalBurns;
  
  uint public pendingMintTotal;
  uint public pendingBurnTotal;

  //Wrapped KSH token current supply
  uint public currentSupply;


// the Authorized DAO Ethereum address
  address public DAO;

  //Authorized Wrapped KSH token minter Ethereum address
  address public custodian;
  
/**
                 * @dev Throws if called by any account other than agent.
                 */
                  modifier onlyAgent() {
                        require(reputation[msg.sender] >= minReputation);
                         _;
                        }
  
  
  //check if Account is the Authorized DAO
  modifier onlyDAO {
    
      require(msg.sender == DAO);
      _;
  }

  //check if Account is the Authorized Custodian
  modifier onlyCustodian {
    
      require(msg.sender == custodian);
      _;
  }
  
  event Transfer(address indexed from, address indexed to, uint value );
  event Approval(address indexed owner, address indexed spender, uint value );
  event TokenMint(address newTokenHolder, uint amountOfTokens);
  event Mint(address newTokenHolder, uint amountOfTokens);
  event Burn(address newTokenHolder, uint amountOfTokens);
  event MinterTransfered(address prevMinter, address nextMinter);
  event MintInitialized(address agent, uint amount);
  event BurnInitialized(address agent, uint amount);
  event DAOset(address caller, address DAOaddress);
  event MinREPutationSet(uint rep);
  event constantWKSHset(uint rep);
 
 
//initialize Wrapped KSH token
//Wrapped KSH token & DAO constructor configurations 
 constructor(address dOrg, uint minREP, uint constWKSH) public  {
    
        custodian = msg.sender;
        DAO = dOrg;

	reputation[0x32eB2497aA9dAB012C8D645dF021f5DE3f5d4426] = 1871000000000000000000;
	reputation[0x7714F0738e0Fc263FA26397D6aa6B12B453f65ff] = 1304000000000000000000;
	reputation[0x20AA324b59bf6190c2A565d8030Bb3E3f0D9EA34] = 548000000000000000000;
	reputation[0x52FF5C42A50488699e217aF42C0984af6F6c39Ef] = 361000000000000000000;
	reputation[0xd3c9BE98cB67007782648bC5B95F9224001023Cf] = 300000000000000000000;
	reputation[0x07051E428F31Fe5C76cE47a3512cD9Af3aAAEA4c] = 224000000000000000000;
	reputation[0x529BF5e181d8A067e9fD9dCb592e6Db00114093e] = 173000000000000000000;
	reputation[0xfaFb56C389065F12A33Ecb3296B93c16C2e24395] = 168000000000000000000;
	reputation[0xb0D8e769FfEbd9b95fDceA952915aA8cbca87990] = 152000000000000000000;
	reputation[0x4c2753515b124303034197eC09c4B9d5d7d4e4B4] = 141000000000000000000;
	reputation[0x26cAeC1BaBF84cD250E5Bc2C01f42B6586CD3616] = 100000000000000000000;
	reputation[0xF1A538E09B1137a651b44EA88Cfa4D1216af475d] = 89000000000000000000;
	reputation[0x0b134F1258F02d45f0cA807631Bd5Ee5a3454d31] = 89000000000000000000;
	reputation[0x36d68E8b6a46F1a4538AF4Ba29d91D78fD6A4182] = 87000000000000000000;
	reputation[0xa9Aa7B47B06726A22758b6b7a15eB75aeff9639e] = 84000000000000000000;
	reputation[0x3890C6B13De444029c30621e911F0D5b2361810B] = 71000000000000000000;
	reputation[0xBB865A6Fcb4e8C81004b3Eb82437265E90b8b231] = 71000000000000000000;
	reputation[0x7b6FD18501450Ff1D6C916E220CF76228FD5585f] = 71000000000000000000;
	reputation[0x8fda0fB03D73348A4Ea99ea47E7E61c8B65ABc88] = 67000000000000000000;
	reputation[0x831fb2fC74Aba0E7343093B756799ea64D526be9] = 67000000000000000000;
	reputation[0x874716FccE3F9Cb312dEbf438F62346A8A677a72] = 60000000000000000000;
	reputation[0xcd79bdE488a2dF94464941BDA7343913178e7070] = 55000000000000000000;
	reputation[0x1dfb9ed662cd8bcFF05638FAAA29F5D8FE2b08dE] = 55000000000000000000;
	reputation[0x9cA7FfCb4160c45B5044777DFbedD2Aefc58F4d5] = 55000000000000000000;
	reputation[0x22cbA1A255B07f7879c89a080A4D60A48ba2B785] = 55000000000000000000;
	reputation[0xE4B46DFF71b074df7269C18882289EB4e8E5A30f] = 55000000000000000000;
	reputation[0x82AD1c92b3eA6C9116771c8c07245B2dCeaEdb37] = 55000000000000000000;
	reputation[0x0421FA4d19Aadd3EB94B7F1d382705775d1cbfa1] = 55000000000000000000;
	reputation[0x2FE5757206DBE19B5eCce55D9f899387acFB38a5] = 55000000000000000000;
	reputation[0xDb8679ec767a4d2e31B7609387E8fA4679Cf9956] = 55000000000000000000;
	reputation[0x5E5C21bf0b1A7AfbF85f8A90fB78235582c40Ab2] = 55000000000000000000;
	reputation[0x1672620300ED947C84FAE87b25CC99700EBb6D09] = 55000000000000000000;
	reputation[0xD340dB4631D49140Ad75E617c24CfD1dB981A92c] = 55000000000000000000;
	reputation[0x68e19f80bfdE4F12700DC01507c2D612d62668E1] = 55000000000000000000;
	reputation[0x38FB29D4DB7224d9B9a68665170a09fc00b646a5] = 55000000000000000000;
	reputation[0x9D2323E9411BB962C0413DF0ba68ebCCf628C1d3] = 55000000000000000000;
	
	reputation[0xD9493c4feAFA77505E46B734788a3B19442dfDFa] = 55000000000000000000;
	reputation[0xf3549929A21433363449576056c29F72be9BB741] = 55000000000000000000;

        minReputation = minREP;
        constantWKSH = constWKSH;

  }

//retrieve number of all Wrapped KSH tokens in existence
function totalSupply() public view returns (uint supply) {
    return currentSupply;
  }

//check Wrapped KSH tokens balance of an Ethereum account
function balanceOf(address who) public view returns (uint value) {
    return _balances[who];
  }

//check how many Wrapped KSH tokens a spender is allowed to spend from an owner
function allowance(address _owner, address spender) public view returns (uint _allowance) {
    return _approvals[_owner][spender];
  }

  // A helper to notify if overflow occurs
function safeToAdd(uint a, uint b) internal pure returns (bool) {
    return (a + b >= a && a + b >= b);
  }

//transfer an amount of Wrapped KSH tokens to an Ethereum address
function transfer(address to, uint value) public returns (bool ok) {

    if(_balances[msg.sender] < value) revert();
    
    if(!safeToAdd(_balances[to], value)) revert();
    
    _balances[msg.sender] -= value;
    _balances[to] += value;
    
    emit Transfer(msg.sender, to, value);
    return true;
  }

//spend WrappedKSH tokens from another Ethereum account that approves you as spender
function transferFrom(address from, address to, uint value) public returns (bool ok) {
    // if you don't have enough balance, throw
    if(_balances[from] < value) revert();

    // if you don't have approval, throw
    if(_approvals[from][msg.sender] < value) revert();
    
    if(!safeToAdd(_balances[to], value)) revert();
    
    // transfer and return true
    _approvals[from][msg.sender] -= value;
    _balances[from] -= value;
    _balances[to] += value;
    
    emit Transfer(from, to, value);
    return true;
  }
  
//allow another Ethereum account to spend Wrapped KSH tokens from your account
function approve(address spender, uint value)
    public
    returns (bool ok) {
    _approvals[msg.sender][spender] = value;
    
    emit Approval(msg.sender, spender, value);
    return true;
  }


//mechanism to initialize Wrapped KSH tokens creation
//only TokenPesa DAO reputation holders can intitialize minting of Wrapped KSH tokens

function initializeMint(uint amount) public onlyAgent returns (bool ok)
  {
    if(amount > ((reputation[msg.sender]) * constantWKSH) || amount < constantWKSH)  revert();
    if((awaitingMint[msg.sender].pendingMinter) == true) revert();
    
    awaitingMint[msg.sender].pendingM = amount;
    awaitingMint[msg.sender].pendingMinter = true;
    
    pendingMintTotal++;
    
    emit MintInitialized(msg.sender, amount);
    return true;
  }


//mechanism for Wrapped KSH tokens creation
//only custodian can complete minting of Wrapped KSH tokens

function mint(address recipient) onlyCustodian  public returns (bool ok)
  {
      
    uint x = awaitingMint[recipient].pendingM;
       
    if(!safeToAdd(_balances[recipient], x)) revert();
    if(!safeToAdd(currentSupply, x)) revert();

   _balances[recipient] += x;  
   currentSupply += x;
    
   awaitingMint[recipient].pendingMinter == false;
   awaitingMint[recipient].pendingM == 0;
   
   pendingMintTotal--;
   totalMints ++;
   
   
   emit Mint(recipient, x);
    return true;
  }

//mechanism to initialize Wrapped KSH tokens burning
//only TokenPesa DAO reputation holders can intitialize burning of Wrapped KSH tokens

function initializeBurn(uint amount) public onlyAgent returns (bool ok)
  {
   if(amount > ((reputation[msg.sender]) * constantWKSH) || amount < constantWKSH)  revert();
   if((awaitingBurn[msg.sender].pendingBurner) == true) revert();
      
    awaitingBurn[msg.sender].pendingB = amount;
    awaitingBurn[msg.sender].pendingBurner = true;
    
    pendingBurnTotal++;
    return true;
    
    emit BurnInitialized(msg.sender, amount);
  }


//mechanism for Wrapped KSH tokens burning
//only custodian can complete burning of Wrapped KSH tokens

function burn(address recipient) onlyCustodian  public returns (bool ok)
  {
      
  uint x = awaitingBurn[recipient].pendingB;

   _balances[recipient] -= x;  
   currentSupply -= x;
   
   awaitingBurn[recipient].pendingBurner == false;
   awaitingBurn[recipient].pendingB == 0;
   
   pendingBurnTotal--;
   totalBurns ++;
   
   emit Burn(recipient, x);

    return true;
  }

  
  //transfer the priviledge of creating new Wrapped KSH Tokens to another Ethereum account
function transferCustodianship(address newMinter) public onlyCustodian returns (bool ok)
  {
    
    custodian == newMinter;
    
    emit MinterTransfered(custodian, newMinter);
     return true;
  }
  
  

function setDAOaddress(address newDAO) public onlyDAO returns (bool ok)

        {
    DAO = newDAO;
    
    emit DAOset(msg.sender, newDAO);
    
     return true;
     
     
         }
  
  
function setMinREPutation(uint rep) public onlyDAO returns (bool ok)

         {
    minReputation = rep;
    
    emit constantWKSHset(rep);
    
    return true;
    
          }



 function setConstantWKSH(uint wkshconstant) public onlyDAO returns (bool ok)
 
         {
             
    constantWKSH = wkshconstant;
    
    emit constantWKSHset(wkshconstant);
    return true;
    
    
         }
         
         
  
  
}