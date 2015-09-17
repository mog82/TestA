using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class HeartRateManager {

    // Attribut
	var heartRate;
	
	// Couleur de l'icon pour mémorisation
    var heartRateIconColor = Gfx.COLOR_DK_RED;

    function initialize() { }
    
    function compute (value) {
    	heartRate = value;
    }
 
    // Formate le texte du rythme cardiaque
    function drawValue (dc, x, y, font1) {
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);	    	           	   	
    	dc.drawText(x-2, y, font1, (heartRate == null) ? "__" :  heartRate.format("%d"), Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_VCENTER);    		
    }
    
    // Dessine un coeur clignotant
    function drawIcon (dc, x, y, r) {
    	if (heartRateIconColor != Gfx.COLOR_DK_GRAY) {
    		heartRateIconColor = Gfx.COLOR_DK_GRAY;
    	} else {
    		heartRateIconColor = (heartRate == null) ? Gfx.COLOR_LT_GRAY : Gfx.COLOR_DK_RED;
    	}
    	
     	dc.setColor(heartRateIconColor, heartRateIconColor);
    	dc.fillCircle (x+r, y+r, r);
    	dc.fillCircle (x+(5*r)/2, y+r, r);
		dc.fillPolygon([[x, y+r], [x+(7*r)/4, y+(7*r)/2], [x+(7*r)/2, y+r], [x, y+r]]);   		   		

    }
 
}