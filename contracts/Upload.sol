// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract upload{
    struct Access{
        address user;
        bool access;
    }
    mapping(address=>string[]) value; // to store the url
    mapping(address=>mapping(address=>bool)) ownership; 
    mapping(address=>Access[])public accessList; // to give the ownership of a file
    mapping(address=>mapping(address=>bool)) previousData; 

    function add(address _user,string calldata url)external {
        value[_user].push(url);
    }
    function allow(address user)external{ //def
        ownership[msg.sender][user]=true;
        if(previousData[msg.sender][user]==true){
            for (uint i=0;i<accessList[msg.sender].length;i++){
                if(accessList[msg.sender][i].user==user){
                    accessList[msg.sender][i].access=true;
                }
            }
        }
        else{
        accessList[msg.sender].push(Access(user,true));
        previousData[msg.sender][user]=true;
        }
    }
    function disallow(address user) external { //revoking def
         ownership[msg.sender][user]=false;
         for(uint i=0;i<accessList[msg.sender].length;i++){
            if (accessList[msg.sender][i].user==user){
                accessList[msg.sender][i].access=false;
            }
         }
        // accessList[msg.sender].push(Access(user,false));
    }
    function display(address _user) external view returns (string[] memory){
        require(_user==msg.sender||ownership[_user][msg.sender],"You Dont Have Access");
        return value[_user];
    }

    function shareAcess() public view returns(Access[] memory){
        return accessList[msg.sender];
    }

}
