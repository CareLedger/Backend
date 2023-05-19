// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract HealthRecordSystem {
    struct Patient {
        string name;
        string email;
        string password;
        uint[] documents;
        bool exists;
        uint healthDetailCount;
        uint commentCount;
    }

    struct HealthDetail {
        string height;
        string weight;
        string bloodGroup;
        string genotype;
        uint timestamp;
    }

    struct Comment {
        string profileName;
        string comment;
        uint timestamp;
    }

    struct Document {
        string hash;
        uint timestamp;
        address uploader;
    }

    mapping(address => Patient) public patients;
    mapping(uint => Document) public documents;
    mapping(address => mapping(uint => HealthDetail)) public patientHealthDetails;
    mapping(address => mapping(uint => Comment)) public patientComments;

    uint public documentCount;

    // Event emitted when a new patient is registered
    event PatientRegistered(address patientAddress, string name, string email);

    // Event emitted when a new document is uploaded
    event DocumentUploaded(address patientAddress, uint documentId, string hash);

    // Event emitted when a document is updated
    event DocumentUpdated(address patientAddress, uint documentId, string hash);

    // Event emitted when a document is deleted
    event DocumentDeleted(address patientAddress, uint documentId);

    // Event emitted when a health detail is updated
    event HealthDetailUpdated(address patientAddress, uint healthDetailId, string height, string weight, string bloodGroup, string genotype);

    // Event emitted when a comment is added by a doctor
    event CommentAdded(address patientAddress, uint commentId, string profileName, string comment);

    // Function for patient registration
    function register(string memory name, string memory email, string memory password) public {
        require(!patients[msg.sender].exists, "Patient already registered");
        patients[msg.sender] = Patient(name, email, password, new uint[](0), true, 0, 0);
        emit PatientRegistered(msg.sender, name, email);
    }

    // Function for document upload
    function upload(string memory hash) public returns (uint) {
        require(patients[msg.sender].exists, "Patient not registered");
        uint documentId = documentCount++;
        documents[documentId] = Document(hash, block.timestamp, msg.sender);
        patients[msg.sender].documents.push(documentId);
        emit DocumentUploaded(msg.sender, documentId, hash);
        return documentId;
    }

    // Function for document update
    function update(uint documentId, string memory hash) public {
        require(patients[msg.sender].exists, "Patient not registered");
        require(documents[documentId].timestamp != 0, "Document not found");
        require(documents[documentId].uploader == msg.sender, "Unauthorized access");
        documents[documentId].hash = hash;
        emit DocumentUpdated(msg.sender, documentId, hash);
    }

    // Function for document deletion
    function deleteDocument(uint documentId) public {
        require(patients[msg.sender].exists, "Patient not registered");
        require(documents[documentId].timestamp != 0, "Document not found");
        require(documents[documentId].uploader == msg.sender, "Unauthorized access");

        delete documents[documentId];
        
        uint[] storage patientDocuments = patients[msg.sender].documents;
        for (uint i = 0; i < patientDocuments.length; i++) {
            if (patientDocuments[i] == documentId) {
                patientDocuments[i] = patientDocuments[patientDocuments.length - 1];
                patientDocuments.pop();
                break;
            }
        }

        emit DocumentDeleted(msg.sender, documentId);
    }
}