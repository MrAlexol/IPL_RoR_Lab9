document.addEventListener("DOMContentLoaded", function() {
    let btn = document.getElementById("btn_commit");
    btn.addEventListener("click", send_query);
})

seq_url = location.protocol + "//" + location.host + "/sequence/view.json"

function send_query() {
    console.log("send query!")
    let input_elem = document.getElementById("values")
    console.log(input_elem.value)
    var param_str = "?values=" + input_elem.value.split(" ").join("+")
    console.log(param_str)
    if (param_str == "") return false;
    var received_data = [];
    var http_request = new XMLHttpRequest();
    http_request.open("GET", seq_url + param_str, true);
    http_request.onreadystatechange = function () {
        var done = 4, ok = 200;
        if (http_request.readyState == done &&
            http_request.status == ok) {
            received_data = JSON.parse(http_request.responseText);
            show_result(received_data);
        }
    };
    http_request.send(null);
    return false;
}

function show_result(data) {
    let table = document.getElementById("result_table");
    let error_output_el = document.getElementById("error_output");
    table.style.display = "none";
    error_output_el.style.display = "none";
    for (let i = 0; i < table.tBodies.length; i++) {
        table.removeChild(table.tBodies[i]);
    }
    let tbody = document.createElement("tbody");
    table.appendChild(tbody);
    let result_row = document.createElement("tr");
    try {
        for (let i = 0; i < data.length; i++) {
            switch (data[i].name) {
                case "result": {
                    let th = document.createElement("th");
                    th.scope = "row";
                    th.classList = "col-1 text-center";
                    result_row.appendChild(th);
                    let td = document.createElement("td");
                    result_row.appendChild(td);
                    th.innerText = "Ответ";
                    td.innerText = data[i].value; 
                    td.id = "result_field";
                    break;
                }
                case "subs": {
                    subs_arr = data[i].value;
                    if (data[i].type !== "NilClass")
                    //     throw new Error('No subs');
                    for (let j = 0; j < subs_arr.length; j++) {
                        let tr = document.createElement("tr");
                        tbody.appendChild(tr);
                        let th = document.createElement("th");
                        th.scope = "row";
                        th.classList = "col-1 text-center";
                        tr.appendChild(th);
                        let td = document.createElement("td");
                        tr.appendChild(td);
                        th.innerText = j + 1;
                        td.innerText = subs_arr[j];
                        td.id= "result_field" + j;
                    }
                    break;
                }
                case "error":
                    if (data[i].type !== "NilClass")
                    throw new Error(data[i].value);
                    break;
            }
        }
    console.log(data);
    tbody.appendChild(result_row);
    table.style.display = "block";
    }
    catch(e) {
        //console.error(e);
        error_output_el.innerText = e.message;
        error_output_el.style.display = "block";
    }
    
}
