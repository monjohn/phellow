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
// Import local files
import phello from './phello'
phello()

import LiveSocket from 'phoenix_live_view'

let selectedList
let selectedCard

let Hooks = {}
Hooks.List = {
  mounted() {
    const list = this.el
    const that = this

    list.addEventListener('dragstart', function(event) {
      const selected = event.target
      switch (event.target.dataset.type) {
        case 'list':
          selectedList = event.target
          break
        case 'card':
          console.log('returning card', event.target)
          selectedCard = event.target

          break
      }

      event.dataTransfer.setData('text/html', event.target)
      event.dataTransfer.dropEffect = 'move'
      selected.classList.add('dragging', 'tilt')
      selected.classList.add('right')

      window.requestAnimationFrame(function() {
        if (selectedList) selectedList.style.visibility = 'hidden'
        if (selectedCard) selectedCard.style.opacity = '0.5'
        selected.classList.remove('tilt', 'right', 'left', 'dragging')
      })
    })

    list.addEventListener('dragend', function(event) {
      console.log('dragend')

      if (selectedList) selectedList.style.visibility = 'visible'
      if (selectedCard) selectedCard.style.opacity = '1'
    })

    list.addEventListener('dragenter', function(event) {
      if (selectedList) this.classList.add('is-target')
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
      event.preventDefault()
      console.log('dropping')

      if (selectedList) {
        const to = event.target.closest('div.list-wrapper')

        selectedList.classList.remove('tilt', 'right', 'left', 'dragging')

        const details = {
          from_id: selectedList.id,
          to_position: to.dataset.position,
        }

        that.pushEvent('reorder_list', details)
        selectedList = undefined
      }
      if (selectedCard) {
        selectedCard.style.opacity = '1'
        const list = event.target.closest('div.card-list')

        // selectedList.classList.remove('tilt', 'right', 'left', 'dragging')

        const details = {
          from_id: selectedCard.id,
          to_list: 'insert list here',
        }

        selectedCard = undefined
      }
    })

    const cardList = list.querySelector('div.list-cards')
    cardList.addEventListener('dragenter', function(event) {
      if (!cardList.contains(selectedCard)) {
        this.style.backgroundColor = '#bbb'
      }
    })

    cardList.addEventListener('dragleave', function(event) {
      event.preventDefault()

      if (!this.contains(event.target)) {
        this.style.backgroundColor = 'transparent'
      }
    })

    cardList.addEventListener('dragstart', function(event) {
      const selectedCard = event.target
      event.dataTransfer.setData('text/html', event.target)
      event.dataTransfer.dropEffect = 'move'
      selectedCard.classList.add('dragging', 'tilt')
      selectedCard.classList.add('right')

      window.requestAnimationFrame(function() {
        event.target.style.opacity = '0.5'
        selectedCard.classList.remove('tilt', 'right', 'left', 'dragging')
      })
    })
  },
}

let liveSocket = new LiveSocket('/live', { hooks: Hooks })
liveSocket.connect()

//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
