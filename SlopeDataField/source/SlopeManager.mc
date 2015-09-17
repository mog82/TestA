using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Math as Math;
using Toybox.WatchUi as Ui;

class SlopeManager {

    // Attributs
	var slope = null;
	var coeff = null;

	// Paramétrage de la quantité de points pour faire l'extrapolation
	var nbPts = 30;				// 10 points maximum
	var maxDistance = 350.0; 	// ou au plus près (supérieur de 300 m) de cette distance
	
	// Mémorise les points (distance, altitude) pour en faire l'extrapolation linéaire
	var arrayPts = new [nbPts];
	
	// Pour mémoire entre 2 appels de compute et pour usage par autres fonctions de la classe
	var pos = -1;
	var lastDistance = 0.0;
	var accuracy = null;

	
    function initialize() {
    	for (var i = 0; i < nbPts; i += 1) {arrayPts[i] = new [2];}
    }
    
    // Mémorise un nouveau points si distance et altitude sont valides puis calcule pente et coefficient de détermination
    function compute (distance, altitude, precision) {
    
    	accuracy = precision;
    		// Mémorise un nouveau points si distance et altitude sont cohérents et presion GPS suffisante
    	if (distance != null && altitude != null && altitude.abs() < 10000.0 && accuracy > 2) {
    	
    		
    		if (distance != lastDistance) {
    			
    			lastDistance = distance;
    			// Si le tableau est plein, alors on décale
    			if (pos == nbPts-1) {
    				for (var i = 1; i < nbPts; i += 1) {arrayPts[i-1] = arrayPts[i];}
    			} else {
    				pos = pos+1;
    			}
    			arrayPts[pos] = [distance, altitude];   
    		}	
    	} // Fin mémorisation

		var startPos;
    	
    	// si (au moins 3 pts et distance > maxDistance) ou nbPts maximum
    	if ((pos > 1 and arrayPts[pos][0]-arrayPts[0][0] > maxDistance) or pos == nbPts-1) {
    	    
    		startPos = pos-2; // debut égal 3ème pt en partant de la fin
    		while (	startPos>0 && arrayPts[pos][0]-arrayPts[startPos][0] < maxDistance) {
    			startPos = startPos - 1;
    		}
    		
    		// Extrapolation linéaire simple
    		var n = pos - startPos + 1;
    		var Sxy = 0.0;
    		var Sxx = 0.0;
      		var Sx = 0.0;
    		var Sy = 0.0;
   		
    		for (var i=startPos; i<pos+1; i += 1)
    		{
    			Sx = Sx + arrayPts[i][0];
    			Sy = Sy + arrayPts[i][1];
    			Sxy = Sxy + arrayPts[i][0]*arrayPts[i][1];
    			Sxx = Sxx + arrayPts[i][0]*arrayPts[i][0];
    		}
    		   		
   			var xMoy = Sx/n.toFloat();
   			var yMoy = Sy/n.toFloat();
    		var nCovXY = Sxy - Sx*Sy/n.toFloat();
    		var nVarX  = Sxx - Sx*Sx/n.toFloat();
    		
    		if (nVarX != 0.0)
    		{
    			var a = nCovXY / nVarX;
    			var b = yMoy - a*xMoy;
    			
    			var SCT = 0.0;
    			var SCR = 0.0;
    			
    			for (var i=startPos; i<pos+1; i += 1)
    			{
    				var yiChapeau = a*arrayPts[i][0] + b;
    				SCT = Math.pow(arrayPts[i][1]- yMoy, 2.0);
    				SCR = Math.pow(arrayPts[i][1]-yiChapeau, 2.0);    				
    			}    			
    			
    			coeff = (SCT == 0.0) ? 0.0 : 1.0 - SCR/SCT;
    			 
    			slope = 100.0 * a;
    			slope = (slope > 99.0) ? null : slope;
    			slope = (slope < -99.0) ? null : slope;
    			
	   		// nVarX est nulle
    		} else {
    			coeff = null;
    			slope = null;
    		}

		//Pas 3 points
   		} else {
     		coeff = null;
    		slope = null;
   		}
	   
    } // end compute

	// Formate le texte de la pente
    function drawValue (dc, x, y, font0, font1) {
    	var text;
    	           	
    	if (slope == null) {
    		text = "__";
    	} else if (slope < 0.0) {
    		text = (-slope-0.5).format("%d");
    	} else {
    		text = (slope+0.5).format("%d");
    	}   	    	
    	
		dc.setColor((coeff != null and coeff > 0.98 and coeff <= 1.0) ? Gfx.COLOR_BLACK : Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
    	dc.drawText(x+3, y, font1, text, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    	dc.drawText(x+3+dc.getTextWidthInPixels(text, font1), y-dc.getFontHeight(font1)/2, font0, "%", Gfx.TEXT_JUSTIFY_LEFT);   	    	    		
    }
    
    // Dessine l'icon au coordonnées
    function drawIcon (dc, x, y, l) {
        var iconColor = Gfx.COLOR_DK_GRAY;
        
        if (slope != null and coeff !=null and coeff > 0.95 and coeff <= 1.0) {
         
        	iconColor = Gfx.COLOR_GREEN;
        	
			if (slope.abs() > 13.0)  {
        		iconColor = Gfx.COLOR_RED;
			} else if (slope.abs() > 10.0) {
        		iconColor = Gfx.COLOR_ORANGE;
			} else if (slope.abs() > 7.0) {			
        		iconColor = Gfx.COLOR_YELLOW;
			} else if (slope.abs() > 4.0) {
        		iconColor = Gfx.COLOR_BLUE;
			}        	
			      	
        }
        
        dc.setColor(iconColor, iconColor);
                
        if (slope != null && slope < 0.0) {
        	dc.fillPolygon ([[x-4,y-3], [x-4-l,y-3], [x-4-l,y-3-l]]);
        } else {
        	dc.fillPolygon ([[x-4,y-3], [x-4-l,y-3], [x-4,y-3-l]]);
        }
        
    }

}