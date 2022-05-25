// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

// contract SimpleStorage {
//     uint storedData;

//     function set(uint x) public {
//         storedData = x;
//     }

//     function get() public view returns (uint) {
//         return storedData;
//     }
// }

contract DataBank {
    uint publicData;

    function set(uint x) public {
        publicData = x;
    }

    function get() public view returns(uint) {
        return publicData;
    }
}
