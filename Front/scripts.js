let phonenumber 

function openCity(evt, buttn_name) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
      tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
      tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    document.getElementById(buttn_name).style.display = "block";
    evt.currentTarget.className += " active";
  }

  function login() {
    const phonenumber1 = document.getElementById("phone_num").value;
    phonenumber =phonenumber1
    fetch("http://localhost:8080/api/login", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({phonenumber})
    })
    .then(response => response.json())
    .then(data => {
     if (data.message === "Login successful") {
        localStorage.setItem("user", JSON.stringify(data.user)); // Store user session
        window.location.href = "Home.html";
     } else {
    alert("Invalid credentials");
    }
})
    .catch(error => console.error("Error:", error));
}
window.onload = function() {
	const storedUser = localStorage.getItem("user");
	if (storedUser) {
		const user = JSON.parse(storedUser);
		document.getElementById('name').textContent = user.Name; // Corrected to user.Name
		// document.getElementById('phone').textContent = user.PhoneNumber;
		// document.getElementById('lastname').textContent = user.LastName; // Corrected to user.LastName

		// Add other fields as needed
	}
};