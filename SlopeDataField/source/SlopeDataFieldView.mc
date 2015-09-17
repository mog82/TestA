using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Math as Math;

class SlopeDataFieldView extends Ui.DataField {

 	var xa;
    var xb;
    var y1;
	var h;
    var w;
    var font0 = Gfx.FONT_NUMBER_MILD;
    var font1 = Gfx.FONT_NUMBER_MEDIUM;
    var iconSize;
   
	var speedManager;
    var slopeManager;
    var heartRateManager;
	
    function initialize() {
    	speedManager = new SpeedManager();
     	slopeManager = new SlopeManager();
     	heartRateManager = new HeartRateManager();
    }

    //! For datafields, if the size changed since the last onUpdate(), onLayout() will be called prior to onUpdate(). 
    function onLayout(dc) {
    	h = dc.getHeight();
     	w = dc.getWidth();
       	y1 = h/2;
       	
    	if (h < 55) {
    		xa = w/3 - 1;
    		xb = (w*2)/3 - 1;
    		font1 = Gfx.FONT_NUMBER_MEDIUM;
    		iconSize = 18;
    	} else {
    		xa = w/2;
    		xb = w;
    		font1 = Gfx.FONT_NUMBER_HOT;
    		iconSize = 24;
    	}
    }
    
    //! The system will call the onUpdate() method inherited from View when the field is displayed by the system.
    function onUpdate(dc) {
    	
    	// set the view background to white
   		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
		dc.clear();
		
		// set the color for the separation
   		dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_WHITE);
   		dc.setPenWidth(3);
   		dc.drawLine(xa, 0, xa, h);
   		
        // 3 DataFieds
   		if (h <55) {  		
   			dc.drawLine(xb, 0, xb, h);
   			
   			heartRateManager.drawIcon(dc, xb+3, 2, 6);
			heartRateManager.drawValue (dc, w, y1, font1);
		}
   			
		slopeManager.drawIcon (dc, xa, h, iconSize);
		slopeManager.drawValue  (dc, 0, y1, font0, font1);
		
        speedManager.drawValue (dc, xb, y1, font0, font1);
    }

    //! Appelée toutes les secondes avec Activity.Info
    function compute(info) {
		speedManager.compute (info.currentSpeed);		
    	slopeManager.compute (info.elapsedDistance, info.altitude, info.currentLocationAccuracy);
		heartRateManager.compute(info.currentHeartRate);
    }

}

