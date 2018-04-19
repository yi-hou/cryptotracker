import { createStore, combineReducers } from 'redux';
import deepFreeze from 'deep-freeze';



let params = {
    checkedValues: [],
    priceData: [],
  };
  

function prices(state = params, action) {
    const state2 = Object.assign([], state);
    switch (action.type) {
        case 'PRICES_LIST':
        return Object.assign({}, state, action.data);
        default:
        return state;
    }
        
}


function root_reducer(state0, action) {
    console.log("reducer", action);
    // {tasks, users, form} is ES6 shorthand for
    // {tasks: tasks, users: users, form: form}
    let reducer = combineReducers({prices});
    let state1 = reducer(state0, action);
    console.log("state1", state1);
    return deepFreeze(state1);
  };
  
  let store = createStore(root_reducer);
  export default store;