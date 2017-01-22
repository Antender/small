'use strict'

function check(id1, id2, found_callback) {
  var circle = 0
  var res = []

  var friends = []
  friends[0] = {}
  friends[1] = {}
  friends[0][id1] = {
    'not_checked': true
  }
  friends[1][id2] = {
    'not_checked': true
  }

  function checkCircle() {
    circle++
    var current = (circle + 1) % 2
    var reverse = circle % 2

    function getFriends(user_id) {
      return $.getJSON('https://api.vk.com/method/friends.get?user_id=' + user_id + '&callback=?',
        function(data) {
          for (var key in data.response) {
            var friend_id = data.response[key]
            if (!friends[current].hasOwnProperty(friend_id)) {
              if (friends[reverse].hasOwnProperty(friend_id)) {
                not_found = false
                if (circle % 2 == 1) {
                  backtrack(user_id, friend_id, id1, id2, 0, 1)
                } else {
                  backtrack(user_id, friend_id, id2, id1, 1, 0)
                }
              }
              friends[current][friend_id] = {
                'not_checked': true,
                'referee': user_id
              }
            }
          }
        }
      )
    }

    function backtrack(user_id, friend_id, id1, id2, index0, index1) {
      var res_t = []
      while (user_id != id1) {
        res_t.push(user_id)
        user_id = friends[index0][user_id].referee
      }
      res_t.reverse()
      while (friend_id != id2) {
        res_t.push(friend_id)
        friend_id = friends[index1][friend_id].referee
      }
      res.push(res_t)
    }

    var not_found = true
    var requests = []
    var friends_to_check = []
    for (var key in friends[current]) {
      if (friends[current][key].not_checked == true) {
        friends_to_check.push(key)
      }
    }

    for (key in friends_to_check) {
      var check_id = friends_to_check[key]
      friends[current][check_id].not_checked = false
      requests.push(getFriends(check_id))
    }

    $.when.apply(null, requests).then(function() {
      if (not_found) {
        if (circle == 6) {
          found_callback('overflow')
        } else {
          checkCircle()
        }
      } else {
        found_callback(JSON.stringify(res))
      }
    })
  }
  checkCircle()
}

//check(11, 5449758, function(res) {
//  alert(res)
//})
