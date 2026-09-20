console.log(Window.Electron)

async function getAccounts() {
    const res = await fetch('http://localhost:3000/accounts')
    console.log(res)
    return res.json()
}

async function setupTransferAccount() {
    const button = document.getElementById("transfer")
    const account1 = document.getElementById("account-selector-1")
    const account2 = document.getElementById("account-selector-2")
    const amount = document.getElementById("amount")

    button.addEventListener('click', async () => {
        const data = JSON.stringify({
            from: account1.value,
            to: account2.value,
            amount: amount.value
        })
        const res = await fetch("http://localhost:3000/transfer", {
            method: "POST",
            body: data,
            headers: {
                "Content-Type": "application/json"
            }
        }).then(response => response.json()).then(data => console.log(data)).then(loadData()).catch(error => console.error('niggaoui' + error))
        if (!res.ok) {
            console.log("An unexpected error has occured.")
        }
    })
}

async function setupAccountCreation() {

    const btn = document.getElementById('create-account')
    btn.addEventListener('click', () => {
        window.electronAPI.changeTo("src/frontend/createAccount.html")
    })
}


async function loadData() {
    const accountselector1 = document.getElementById("account-selector-1")
    const accountselector2 = document.getElementById("account-selector-2")

    accountselector1.innerHTML = ""
    accountselector2.innerHTML = ""
    document.getElementById("accounts").innerHTML = ""
    try {
        const data = await getAccounts();



        const fragment = document.createDocumentFragment();

        data.forEach(element => {
            const sum = document.createElement('div')
            sum.className = "summary"
            sum.innerHTML = `<div class="summary-item"><div class="summary-label">${element.Name}</div><div class="summary-value">${element.Amount}MAD</div></div>`

            const option1 = document.createElement('option')
            option1.value = element.Name
            option1.text = element.Name
            accountselector1.appendChild(option1);
            const option2 = document.createElement('option')
            option2.value = element.Name
            option2.text = element.Name
            accountselector2.appendChild(option2);
            fragment.appendChild(sum);
        });
        document.getElementById("accounts").appendChild(fragment)
    } catch (error) {
        console.log(error)
    }
}

loadData();
setupTransferAccount();
setupAccountCreation();