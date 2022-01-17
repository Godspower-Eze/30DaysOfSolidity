// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract TodoList {

    uint public count;

    struct Task {
        uint id;
        string content;
        bool completed;
    }

    mapping(uint => Task) public tasks;

    event TaskCreated(
        uint id,
        string content,
        bool completed
    );

    event TaskCompleted(
        uint id,
        bool completed
    );
    
    function createTask(string memory _content) public{
        count = count + 1;
        tasks[count] = Task(count, _content, false);
        emit TaskCreated(count, _content, false);
    }

    function checkTask(uint _id) public{
        Task memory _task = tasks[_id];
        _task.completed = true;
        tasks[_id] = _task;
        emit TaskCompleted(_id, true);
    }

}