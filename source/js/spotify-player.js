(() => {
  const initSpotifyPlayer = () => {
    const toggleBtn = document.getElementById('spotify-toggle-btn')
    const closeBtn = document.getElementById('spotify-close-btn')
    const panel = document.getElementById('spotify-panel')
    if (!toggleBtn || !panel || toggleBtn.dataset.bound) return

    const setOpen = (isOpen) => {
      panel.classList.toggle('open', isOpen)
      panel.setAttribute('aria-hidden', String(!isOpen))
      toggleBtn.setAttribute('aria-expanded', String(isOpen))
    }

    toggleBtn.addEventListener('click', () => {
      setOpen(!panel.classList.contains('open'))
    })

    if (closeBtn) {
      closeBtn.addEventListener('click', () => setOpen(false))
    }

    toggleBtn.dataset.bound = 'true'
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initSpotifyPlayer)
  } else {
    initSpotifyPlayer()
  }
})()
