function elt(name, attributes){
    var node = document.createElement(name);
    // attributes(argument1)로 받은 객체를 반영
    if (attributes){
        for(var attr in attributes){
            if (attributes.hasOwnProperty(attr)){
                node.setAttribute(attr,attributes[attr]);
            }
        }
    }

    // argument2부터는 string이면 textContent로 추가
    for (var i=2; i<arguments.length; i++){
        var child = arguments[i];
        if (typeof child == "string"){
            child = document.createTextNode(child);
        }
        node.appendChild(child);
    }

    // 만들어진 요소 노드를 반환
    return node;
}

/*
elt(tagName, ATTR, argument2, argument3, argument4, ...)

attributes:
    ATTR = {"attr1":v1, "attr2":v2, "attr":v3, ...}

attr:
    attr1, attr2, attr3, ...

attributes[attr]:
    ATTR[attr1] = v1,
    ATTR[attr2] = v2,
    ATTR[attr3] = v3,
    ...
*/