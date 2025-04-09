document.getElementById("saveButton").addEventListener("click", function() {
    const name = document.getElementById("nameInput").value;
    if (name) {
        fetch("http://44.203.147.53:5000/add_name", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ name: name })
        })
        .then(response => response.json())
        .then(data => {
            if (data.message) {
                alert(data.message);
                document.getElementById("nameInput").value = '';  // Clear input
                loadNames();  // Reload names list
            }
        })
        .catch(error => console.error('Error:', error));
    } else {
        alert("Please enter a name.");
    }
});

function loadNames() {
    fetch("http://44.203.147.53:5000/get_names")
        .then(response => response.json())
        .then(names => {
            const namesList = document.getElementById("namesList");
            namesList.innerHTML = "";  // Clear current list
            names.forEach(name => {
                const li = document.createElement("li");
                li.textContent = name;
                namesList.appendChild(li);
            });
        })
        .catch(error => console.error('Error:', error));
}

// Load names initially when the page loads
window.onload = loadNames;
