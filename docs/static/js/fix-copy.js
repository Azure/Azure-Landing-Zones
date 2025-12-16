// Fix double line breaks and line number copying issues
(function() {
  function fixCopyButtons() {
    document.querySelectorAll('.gdoc-post__codecopy').forEach(function(button) {
      // Skip if already fixed
      if (button.hasAttribute('data-copy-fixed')) return;
      button.setAttribute('data-copy-fixed', 'true');
      
      // Remove the old click handler by cloning the button
      const newButton = button.cloneNode(true);
      button.parentNode.replaceChild(newButton, button);
      
      // Add our own click handler
      newButton.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        e.stopImmediatePropagation();
        
        // Find the parent highlight container
        const highlight = newButton.closest('.highlight');
        if (!highlight) return;
        
        let codeElement;
        
        // Check if this is a line-numbered table layout (look for any table, not just .lntable class)
        const table = highlight.querySelector('table');
        
        if (table) {
          // This is a line-numbered code block
          // The structure is: table > tbody > tr > td (line numbers) | td (code)
          // We want the second td which contains the actual code
          const rows = table.querySelectorAll('tr');
          
          if (rows.length > 0) {
            // Get all the code cells (second td in each row)
            const codeLines = [];
            rows.forEach(function(row) {
              const tds = row.querySelectorAll('td');
              if (tds.length >= 2) {
                // Get the second td which has the code
                const codeTd = tds[1];
                const code = codeTd.querySelector('code');
                if (code) {
                  codeLines.push(code.textContent);
                }
              }
            });
            
            if (codeLines.length > 0) {
              const codeText = codeLines.join('').trim();
              
              // Copy to clipboard
              navigator.clipboard.writeText(codeText).then(function() {
                // Show success feedback
                newButton.classList.add('gdoc-post__codecopy--success', 'gdoc-post__codecopy--out');
                const copyIcon = newButton.querySelector('.gdoc-icon.copy');
                const checkIcon = newButton.querySelector('.gdoc-icon.check');
                if (copyIcon) copyIcon.classList.add('hidden');
                if (checkIcon) checkIcon.classList.remove('hidden');
                
                setTimeout(function() {
                  newButton.classList.remove('gdoc-post__codecopy--success', 'gdoc-post__codecopy--out');
                  if (copyIcon) copyIcon.classList.remove('hidden');
                  if (checkIcon) checkIcon.classList.add('hidden');
                }, 3000);
              }).catch(function(err) {
                console.error('Failed to copy text: ', err);
              });
              return;
            }
          }
        }
        
        // Regular code block without line numbers
        codeElement = highlight.querySelector('pre > code');
        
        if (!codeElement) return;
        
        // Get the text content
        let codeText = codeElement.textContent.trim();
        
        // Copy to clipboard
        navigator.clipboard.writeText(codeText).then(function() {
          // Show success feedback
          newButton.classList.add('gdoc-post__codecopy--success', 'gdoc-post__codecopy--out');
          const copyIcon = newButton.querySelector('.gdoc-icon.copy');
          const checkIcon = newButton.querySelector('.gdoc-icon.check');
          if (copyIcon) copyIcon.classList.add('hidden');
          if (checkIcon) checkIcon.classList.remove('hidden');
          
          setTimeout(function() {
            newButton.classList.remove('gdoc-post__codecopy--success', 'gdoc-post__codecopy--out');
            if (copyIcon) copyIcon.classList.remove('hidden');
            if (checkIcon) checkIcon.classList.add('hidden');
          }, 3000);
        }).catch(function(err) {
          console.error('Failed to copy text: ', err);
        });
      });
    });
  }
  
  // Try multiple times to catch the buttons after they're created
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      setTimeout(fixCopyButtons, 100);
      setTimeout(fixCopyButtons, 500);
      setTimeout(fixCopyButtons, 1000);
    });
  } else {
    setTimeout(fixCopyButtons, 100);
    setTimeout(fixCopyButtons, 500);
    setTimeout(fixCopyButtons, 1000);
  }
})();
