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
      console.log('dragend', event.target)
      selectedList.style.visibility = 'visible'
    })

    elem.addEventListener('dragenter', function(event) {
      const listWrapper = event.target.closest('div.list-wrapper')
      listWrapper.classList.add('is-target')
    })

    elem.addEventListener('dragleave', function(event) {
      this.classList.remove('is-target')
    })

    elem.addEventListener('dragover', function(event) {
      event.preventDefault()
      event.dataTransfer.dropEffect = 'move'
    })

    elem.addEventListener('drop', function(event) {
      console.log('selectedList.id', selectedList.id)

      const listWrapper = event.target.closest('div.list-wrapper')
      console.log('listWrapper.id', listWrapper.id)

      selectedList.classList.remove('tilt', 'right', 'left', 'dragging')
      //   this.appendChild(selectedBox)
    })
  })
}

export default dragAndDrop
