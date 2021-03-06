// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract C {
    // The data location of x is storage.
    // This is the only place where the data location can be omitted.
    uint[] x;

    // The data location of memoryArray is memory.
    function f(uint[] memory memoryArray) public {
        x = memoryArray;  // works, copies the whole arrage to storage
        uint [] storage y = x;  // works, assigns a pointer, data location of y is storage
        y[7];  // fine, returns the 8th element
        y.pop();  // fine, modifies x through y
        delete x;  // fine, clears the array, also modifies y
        // The following does not work; it would need to create a new temporary
        // unnamed array in storage, but storage is "statically" allocated:
        // y = memoryArray;
        // This does not work either, since it would "reset" the pointer, but there is no sensible location it could point to.
        // delete y;
        g(x); // calls g, handing over a refeerence to x
        h(x); // calls h and creates and independent, temporary copy in memory
    }

    function g(uint[] storage) internal pure {}
    function h(uint[] memory) public pure {}
}

contract D {
    bytes s = "Storage";
    function f(bytes calldata c, string memory m, bytes16 b) public view {
        bytes memory a = bytes.concat(s, c, c[:2], "Literal", bytes(m), b);
        assert((s.length + c.length + 2 + 7 + bytes(m).length + 16) == a.length);
    }
}

contract E {
    function f(uint len) public pure {
        uint[] memory a = new uint[](7);
        bytes memory b = new bytes(len);
        assert(a.length == 7);
        assert(b.length == len);
        a[6] = 8;
    }
}

contract F {
    function f() public pure {
        g([uint(1), 2, 3]);
    }
    function g(uint[3] memory) public pure {
        uint[3] memory x = [uint(7), uint(8), uint(9), uint(10)];
        return x;
    }
}

contract G {
    function f() public pure returns (uint24[2][4] memory) {
        uint24[2][4] memory x = [[uint24(0x1), 1], [0xffffff, 2], [uint24(0xff), 3], [uint24(0xffff), 4]];
        // The following does not work, because some of the inner arrays are not of the right type.
        // uint[2][4] memory x = [[0x1, 1], [0xffffff, 2], [0xfff, 3], [0xffffff, 4]]
        return x;
    }

    // To initialized dunamically-sized arrays, you have to assign the individual elements.
    contract H {
        function f() public pure {
            uint[] memory x = new uint[](3);
            x[0] = 1;
            x[1] = 5;
            x[2] = 4;
        }
    }
}