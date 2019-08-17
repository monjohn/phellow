function dragAndDrop() {
  let selectedList
  var lists = document.querySelectorAll('div.list-wrapper')
  lists.forEach(elem => {
    elem.addEventListener('dragstart', function(event) {
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

    elem.addEventListener('dragend', function(event) {
      if (selectedList) {
        selectedList.style.visibility = 'visible'
      }
    })

    elem.addEventListener('dragenter', function(event) {
      console.log('event', event.target)
      // const listWrapper = event.target.closest('div.list-wrapper')
      console.log('this', this)
      this.classList.add('is-target')
    })

    elem.addEventListener('dragleave', function(event) {
      event.preventDefault()
      console.log(!this.contains(event.target))
      if (!this.contains(event.target)) {
        this.classList.remove('is-target')
      }
    })

    elem.addEventListener('dragover', function(event) {
      event.preventDefault()
      event.dataTransfer.dropEffect = 'move'
    })

    elem.addEventListener('drop', function(event) {
      event.preventDefault()

      const listWrapper = event.target.closest('div.list-wrapper')

      selectedList.classList.remove('tilt', 'right', 'left', 'dragging')
      selectedList = undefined
      //   this.appendChild(selectedBox)
    })
  })
}

export default dragAndDrop
