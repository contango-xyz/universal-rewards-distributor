// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import "./MerkleTreeLib.sol";

contract MerkleTree {
    using MerkleTreeLib for MerkleTreeLib.Node;
    using MerkleTreeLib for MerkleTreeLib.Tree;

    MerkleTreeLib.Tree tree;

    function newLeaf(MerkleTreeLib.Leaf memory leaf) public {
        tree.newLeaf(leaf);
    }

    function newInternalNode(MerkleTreeLib.InternalNode memory internalNode) public {
        tree.newInternalNode(internalNode);
    }

    function setRoot(bytes32 id) public {
        tree.setRoot(id);
    }

    function getRoot() public view returns (bytes32) {
        return tree.getRoot();
    }

    function getLeft(bytes32 id) public view returns (bytes32) {
        return tree.getLeft(id);
    }

    function getRight(bytes32 id) public view returns (bytes32) {
        return tree.getRight(id);
    }

    function getValue(address addr, address reward) public view returns (uint256) {
        return tree.getValue(addr, reward);
    }

    function getHash(bytes32 id) public view returns (bytes32) {
        return tree.getHash(id);
    }

    function isEmpty(bytes32 id) public view returns (bool) {
        return tree.nodes[id].isEmpty();
    }

    function isWellFormed(bytes32 id) public view returns (bool) {
        return tree.isWellFormed(id);
    }

    // Check that the nodes are well formed on the path from the root.
    function wellFormedPath(bytes32 id, bytes32[] memory proof) public view {
        for (uint256 i = proof.length;;) {
            require(tree.isWellFormed(id));

            if (i == 0) break;

            bytes32 otherHash = proof[--i];

            bytes32 left = tree.getLeft(id);
            bytes32 right = tree.getRight(id);

            id = tree.getHash(left) == otherHash ? right : left;
        }
    }
}
