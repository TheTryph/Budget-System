

async function getAccounts() {
    const res = await fetch('http://localhost:3000/accounts')
    console.log(res)
    return res.json()
}

async function setupAccount() {
    const acc_name = document.getElementById("account-name")
    const acc_amount = document.getElementById("account-amount")
    const confirm = document.getElementById("confirm")

    confirm.addEventListener('click', () => {
        const name = acc_name.value;
        const amount = acc_amount.value;

        try {
            fetch(
                'http://localhost:3000/create-account',
                {
                    method: "POST",
                    body: JSON.stringify({
                        Name : name,
                        Amount : amount
                    }),
                    headers: {
                        "Content-Type": "application/json"
                    }
                }
            )
            .then(() => {window.electronAPI.changeTo("src/frontend/index.html")})
            .catch((err) => {
                console.log(err);
            });
        } catch (err) { console.log("Error happened: " + err) }
    })
}

async function loadData() {
    document.getElementById("accounts").innerHTML = ""
    try {
        const data = await getAccounts();

        const fragment = document.createDocumentFragment();

        data.forEach(element => {
            const sum = document.createElement('div')
            sum.className = "summary"
            sum.innerHTML = `<div class="summary-item"><div class="summary-label">${element.Name}</div><div class="summary-value">${element.Amount}MAD</div></div>`

            fragment.appendChild(sum);
        });
        document.getElementById("accounts").appendChild(fragment)
    } catch (error) {
        console.log(error)
    }
}
setupAccount();
loadData();