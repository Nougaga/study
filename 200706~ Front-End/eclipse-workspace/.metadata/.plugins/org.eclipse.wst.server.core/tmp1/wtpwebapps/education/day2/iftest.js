function call(){
	var score = document.querySelector("#score").value;
	var grade;
	if (score>100 || score<0){
		grade = "유효하지 않은 점수입니다.";
	}
	else if (score>=90){
		grade = "A학점입니다.";
	}
	else if (score>=80){
		grade = "B학점입니다.";
	}
	else if (score>=70){
		grade = "C학점입니다.";
	}
	else if (score>=60){
		grade = "D학점입니다.";
	}
	else{
		grade = "F학점입니다.";
	}
	alert(grade);
};

function call2(){
	var score = document.querySelector("#score").value;
	var grade;
	
	switch(Math.floor(score/10)){
	case 10:
	case 9:
		grade="A학점";
		break;
	case 8:
		grade="B학점";
		break;
	case 7:
		grade="C학점";
		break;
	case 6:
		grade="D학점";
		break;
	default:
		grade="F학점";
	}
	alert(grade);
};