// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from '../css/app.css'

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import 'phoenix_html'

import LiveSocket from 'phoenix_live_view'
import Sortable from 'sortablejs'

let Hooks = {}

let selectedList
Hooks.List = {
  mounted() {
    const list = this.el
    const that = this

    const cards = list.querySelector('div.list-cards')
    Sortable.create(cards, {
      group: 'cards',

      onEnd: function(event) {
        const details = {
          to_list: parseInt(event.to.id),
          to_position: event.newIndex,
          card_id: parseInt(event.item.id),
        }

        that.pushEvent('move_card', details)
      },
    })

    list.addEventListener('dragstart', function(event) {
      console.log('event.target', event.target)
      if (!event.target.classList.contains('list-wrapper')) {
        return
      }
      console.log('selectedList', selectedList)
      selectedList = event.target
      event.dataTransfer.setData('text/html', event.target)
      event.dataTransfer.dropEffect = 'move'
      selectedList.classList.add('dragging', 'tilt')
      selectedList.classList.add('right')

      window.requestAnimationFrame(function() {
        event.target.style.visibility = 'hidden'
        selectedList.classList.remove('tilt', 'right', 'left', 'dragging')
      })
    })

    list.addEventListener('dragend', function(event) {
      if (selectedList) {
        selectedList.style.visibility = 'visible'
      }
    })

    list.addEventListener('dragenter', function(event) {
      this.classList.add('is-target')
    })

    list.addEventListener('dragleave', function(event) {
      event.preventDefault()
      // console.log('contains', !this.contains(event.target))
      if (!this.contains(event.target)) {
        this.classList.remove('is-target')
      }
    })

    list.addEventListener('dragover', function(event) {
      event.preventDefault()
      event.dataTransfer.dropEffect = 'move'
    })

    list.addEventListener('drop', function(event) {
      if (!selectedList) return
      event.preventDefault()
      const to = event.target.closest('div.list-wrapper')

      selectedList.classList.remove('tilt', 'right', 'left', 'dragging')

      const details = {
        from_id: selectedList.id,
        to_position: to.dataset.position,
      }

      that.pushEvent('reorder_list', details)
      selectedList = undefined
    })
  },
}

let liveSocket = new LiveSocket('/live', { hooks: Hooks })
liveSocket.connect()

//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
