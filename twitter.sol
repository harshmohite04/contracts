// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// Twitter Project (Lab - 10)
// Objective: Develop a smart contract that simulates a simple social media platform where users can tweet, send messages,
// follow other users, and manage operator permissions.

// Requirements:

// Tweeting:
// Users can post tweets.
// An operator (authorized by a user) can post tweets on behalf of that user.

// Messaging:
// Users can send direct messages to other users.
// An operator can send messages on behalf of the user who authorized them.

// Following:
// Users can follow other users.

// Operator Management:
// Users can allow or disallow other users as operators who can act on their behalf.

// Retrieving Tweets:
// Retrieve the latest tweets from all users.
// Retrieve the latest tweets from a specific user.

// Instructions:
contract Twitter {
    // Define the Contract Structure:
    // Create a Tweet struct to store tweet details (ID, author, content, creation timestamp).
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 creationTimestamp;
    }
    // Create a Message struct to store message details (ID, content, sender, receiver, creation timestamp).
    struct Message {
        uint256 id;
        string content;
        address sender;
        address receiver;
        uint256 creationTimestamp;
    }

    uint256 public tweetCounter;
    uint256 public messageCounter;

    modifier operatorPermission(address _from) {
        require(operators[_from][msg.sender]==true, "You dont have permission to handle this Account");
        _;
    }

    // Mappings:
    // tweets: A mapping to store all tweets.
    mapping(uint256 => Tweet) tweets;
    // tweetsOf: A mapping to store the IDs of tweets by each user.
    mapping(address => uint256[]) tweetsOf;
    // conversations: A mapping to store direct messages between users.
    mapping(address => Message[]) conversations;
    // operators: A mapping to manage operator permissions.
    mapping(address => mapping(address => bool)) operators;
    // following: A mapping to store the list of users that each user follows.
    mapping(address => address[]) following;

    // Functions:
    // _tweet(address _from, string memory _content): Internal function to handle the tweeting logic.
   

    // _sendMessage(address _from, address _to, string memory _content): Internal function to handle messaging logic.
    

    // tweet(string memory _content): Allows a user to post a tweet.
    function tweet(string memory _content) public {
        tweets[tweetCounter] = Tweet({
            id: tweetCounter,
            author: msg.sender,
            content: _content,
            creationTimestamp: block.timestamp
        });
        tweetCounter++;
    }

    /**
     * @notice Allows a user to post a tweet.
     * @dev This function is internal and should not be called directly.
     * @param _from The address of the user posting the tweet.
     * @param _content The content of the tweet.
     */
    // tweet(address _from, string memory _content): Allows an operator to post a tweet on behalf of a user.
    function tweet(address _from, string memory _content)
        public
        operatorPermission(_from)
    {
        tweets[tweetCounter] = Tweet({
            id: tweetCounter,
            author: _from,
            content: _content,
            creationTimestamp: block.timestamp
        });
        tweetCounter++;
    }

    // sendMessage(string memory _content, address _to): Allows a user to send a message.
    function sendMessage(string memory _content, address _to) public {
        conversations[msg.sender].push(
            Message({
                id: messageCounter,
                content: _content,
                sender: msg.sender,
                receiver: _to,
                creationTimestamp: block.timestamp
            })
        );
        messageCounter++;
    }

    // sendMessage(address _from, address _to, string memory _content): Allows an operator to send a message on behalf of a user.
    function sendMessage(
        address _from,
        address _to,
        string memory _content
    ) public operatorPermission(_from) {
        conversations[msg.sender].push(
            Message({
                id: messageCounter,
                content: _content,
                sender: _from,
                receiver: _to,
                creationTimestamp: block.timestamp
            })
        );
        messageCounter++;
    }

    // follow(address _followed): Allows a user to follow another user.
    function follow(address _followed) public {
        following[msg.sender].push(_followed);
    }

    // allow(address _operator): Allows a user to authorize an operator.
    function allow(address _operator) public {
        operators[msg.sender][_operator]=true;

    }

    // disallow(address _operator): Allows a user to revoke an operator's authorization.
    function disallow(address _operator) public {

        operators[msg.sender][_operator]=false;
    }

    // getLatestTweets(uint count): Returns the latest tweets across all users.
    function getLatestTweets() public view returns (Tweet[] memory) {
        Tweet[] memory latestTweetArr = new Tweet[](tweetCounter);
        for (uint256 i = 0; i < tweetCounter; i++) {
            latestTweetArr[i] = tweets[i];
        }
        return latestTweetArr;
    }

    // getLatestTweetsOf(address user, uint count): Returns the latest tweets of a specific user.
    function getLatestTweetsOf(address user)
        public
        view
        returns (Tweet[] memory)
    {
        uint userCounter=0;
        for (uint256 i = 0; i < tweetCounter; i++) {
            if (tweets[i].author == user) {
                userCounter++;
            }
        }

        Tweet[] memory getLatestTweetsOfArr = new Tweet[](userCounter);
        uint resultIndex=0;
        for (uint256 i = 0; i < tweetCounter; i++) {
            if (tweets[i].author == user) {
                getLatestTweetsOfArr[resultIndex] = tweets[i];
                resultIndex++;
            }
        }
        return getLatestTweetsOfArr;
    }
}
