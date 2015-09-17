using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class SpeedManager {

	// Attribut
	var speed = null;
	
	// Pour conversion m/s en km/h ou mph	
	var speedFactor;
	
	function initialize() {
        var prefs = System.getDeviceSettings();
        if (prefs.distanceUnits == Sys.UNIT_METRIC) {
        	speedFactor = 3.6;
        } else {
        	speedFactor = 2.2369362920544;
        }
    }
    
    function compute (value) {
    	speed = (value == null) ? null : value * speedFactor;
    }

	// Formate le texte de la vitesse 
    //  - x = abscisse droite du texte
	//  - y = ordonnée milieu du texte  
    function drawValue (dc, x, y, font0, font1) {
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);	 
        if (speed == null) {
    		dc.drawText(x, y, font1, "__", Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_VCENTER);
    	} else {
    		var text1 = speed.format("%5.1f").substring(4, 5);
    		var text2 = speed.format("%d") + ".";
    		  		
    		dc.drawText(x-2, y-dc.getFontHeight(font1)/2, font0, text1, Gfx.TEXT_JUSTIFY_RIGHT);
    		dc.drawText(x-2-dc.getTextWidthInPixels(text1, font0), y, font1, text2, Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_VCENTER);
    	}   
    }
}