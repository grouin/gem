function GetId(id) {
    return document.getElementById(id);
}
var i=false; // La variable i nous dit si la bulle est visible ou non

function move(e) {
    // Si la bulle est visible, on calcul en temps reel sa position ideale
    if(i) {
	// Si on est pas sous IE
	if (navigator.appName!="Microsoft Internet Explorer") { 
	    GetId("curseur").style.left=e.pageX + 5+"px";
	    GetId("curseur").style.top=e.pageY + 10+"px";
	} else {
	    if(document.documentElement.clientWidth>0) {
	        GetId("curseur").style.left=20+event.x+document.documentElement.scrollLeft+"px";
	        GetId("curseur").style.top=10+event.y+document.documentElement.scrollTop+"px";
	    } else {
	        GetId("curseur").style.left=20+event.x+document.body.scrollLeft+"px";
	        GetId("curseur").style.top=10+event.y+document.body.scrollTop+"px";
	    }
	}
    }
}

function montre(text) {
    if(i==false) {
	// S'il est cach� (la verif n'est qu'une securit�) on le rend visible
	GetId("curseur").style.visibility="visible";
	// Cette fonction est a am�liorer, il parait qu'elle n'est pas valide (mais elle marche)
	GetId("curseur").innerHTML = text;
	i=true;
    }
}

function cache() {
    if(i==true) {
	// Si la bulle �tait visible on la cache
	GetId("curseur").style.visibility="hidden"; 
	i=false;
    }
}

// d�s que la souris bouge, on appelle la fonction move pour mettre � jour la position de la bulle
document.onmousemove=move;
