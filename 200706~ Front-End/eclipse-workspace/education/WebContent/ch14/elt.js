/*-----------------------------------------------------------------------*
 * 함수 이름：elt
 * 주어진 이름(name)과 속성(attributes), 자식 노드를 포함하는 요소를 만들어서 반환하는 함수
 * 
 * 
 * 
 * 사용예시: elt("p", {id: "", class: "", ...});
 *-----------------------------------------------------------------------*/
function elt(name, attributes) {
	var node = document.createElement(name);	// name 태그의 요소를 만들어
	if( attributes ) {
		for(var attr in attributes) {
			if(attributes.hasOwnProperty(attr)) {
				node.setAttribute(attr,attributes[attr]);	// 만든 요소에 속성을 넣어
			}
		}
	}
	// 3개 이상의 인수들은 전부 child:textNode로 때려박아
	for(var i=2; i<arguments.length; i++) {
		var child = arguments[i];
		if( typeof child == "string" ) {
			child = document.createTextNode(child);
		}
		node.appendChild(child);
	}
	return node;
}
