

/***************************************
Creator: Somin Oh
Email: osso.sunnyturtle@gmail.com
Last Edit: 2022.09.28
****************************************/


try (destroydialog Calculator) catch()


--************Funtion

fn getDistance EPolyD aVert =
(	
	try
	(
		VertPositionD = for iVert in aVert collect	
		polyop.getVert EPolyD iVert
		return (distance VertPositionD[1] VertPositionD[2])
	)
	catch()
)

 fn getLength EditablePoly iEdge =
(		
	try
	(
	    local aiEdgeVerts = polyop.getEdgeVerts EditablePoly iEdge
        
        local VertPosition = for iVert in aiEdgeVerts collect
		polyop.getVert EditablePoly iVert
        
        return (distance VertPosition[1] VertPosition[2])
	)
	catch()
)

fn getfaceArea EPolyArea face = 
(	
	try
	(
	local theArea= 0.0
	theArea = polyop.getFaceArea EPolyArea face
	return (theArea)
	)
	catch()
)

fn getVolume obj =
(
	local Volume= 0.0
	local theMesh = snapshotasmesh obj
	local numFaces = theMesh.numfaces
	for i = 1 to numFaces do
	(
		local Face= getFace theMesh i
		local vert2 = getVert theMesh Face.z
		local vert1 = getVert theMesh Face.y
		local vert0 = getVert theMesh Face.x
		local dV = Dot (Cross (vert1 - vert0) (vert2 - vert0)) vert0
		Volume+= dV		
	)
delete theMesh
Volume /= 6
print(Volume)
)

fn getCenterOfMass obj =
(
	local Volume= 0.0
	local Center= [0.0, 0.0, 0.0]
	local theMesh = snapshotasmesh obj
	local numFaces = theMesh.numfaces
	for i = 1 to numFaces do
	(
		local Face= getFace theMesh i
		local vert2 = getVert theMesh Face.z
		local vert1 = getVert theMesh Face.y
		local vert0 = getVert theMesh Face.x
		local dV = Dot (Cross (vert1 - vert0) (vert2 - vert0)) vert0
		Volume+= dV
		Center+= (vert0 + vert1 + vert2) * dV
	)
delete theMesh
Volume /= 6
Center /= 24
Center /= Volume
print(Center)
)

--***********Rollout

rollout Calculator "Calculator" width:330 height:330
(
	--UI
	
		groupBox grp1 "Calculate" pos:[24,24] width:285 height:192 					
	
		button disbtn "Button" pos:[110,55] width:25 height:25 enabled:true images:#("D:\making\UI\distance.bmp","D:\making\UI\distance_a.bmp", 1,1,1,1,1) 
		button lenbtn "Button" pos:[110,87] width:25 height:25 enabled:true images:#("D:\making\UI\length.bmp","D:\making\UI\length_a.bmp", 1,1,1,1,1)
		button areabtn "Button" pos:[110,119] width:25 height:25 enabled:true images:#("D:\making\UI\area.bmp","D:\making\UI\area_a.bmp", 1,1,1,1,1)
		button volbtn "Button" pos:[110,149] width:25 height:25 enabled:true images:#("D:\making\UI\volume.bmp","D:\making\UI\volume_a.bmp", 1,1,1,1,1)
		button cenbtn "Button" pos:[110,178] width:25 height:25 enabled:true images:#("D:\making\UI\center.bmp","D:\making\UI\center_a.bmp", 1,1,1,1,1)
	
		label lb1 "Distance" pos:[170,60] width:96 height:24
		label lb2 "Length" pos:[170,92] width:96 height:24 
		label lb3 "Area" pos:[170,124] width:96 height:24 
		label lb5 "Volume" pos:[170,154] width:96 height:24 
		label lb4 "Center" pos:[170,183] width:96 height:24 		
			
		listbox listBox items:#() pos: [12,220] height:7					
					
	
	--Scripts
	on disbtn pressed do
	(
		EPolyD= selection[1]
		aVert = polyop.getVertSelection EPolyD
		disVal = getDistance EPolyD aVert		
		
		listBox.items = append listBox.items ("Distance : " + (disVal as string))
	)
	on lenbtn pressed do
	(		
		total = 0
		EPoly = selection[1]         
		aEdge = polyOp.getEdgeSelection EPoly
		                        
		for ed in aEdge do
		(
			LengthValue= getLength EPoly ed 
				
			listBox.items = append listBox.items (($.name as string) +"| Length : #"+(ed as string) +" = " + (LengthValue as string))
				
			if aEdge.count >1 do
			(				
				total += LengthValue				
			)
		)
		listBox.items = append listBox.items (($.name as string) +"| Length Total : "+ (total as string))				
	)
	on areabtn pressed do
	(		
		areaTotal = 0
		EPolyArea = selection[1]
		aMyselection = EPolyArea.GetSelection #Face 	
				
		for face in aMyselection do
		(
			AreaValue = getfaceArea EPolyArea face
			listBox.items = append listBox.items (($.name as string) +"| Area : #"+(face as string) +" = " + (AreaValue as string))
			
			if aMyselection.count >1 do
			(				
				areaTotal += AreaValue				
			)
		)
		listBox.items = append listBox.items (($.name as string) +"| Area Total : "+ (areaTotal as string))		
	)
	on volbtn pressed do
	(
		print "volume"
		vol= getVolume $ 
		listBox.items = append listBox.items (($.name as string) +"| Volume : "+(vol as string) )
	)
	on cenbtn pressed do
	(
		print "center"
		cen= getCenterOfMass $
		listBox.items = append listBox.items (($.name as string) +"| Center : "+(cen as string) )
	)		
)


createDialog Calculator 


