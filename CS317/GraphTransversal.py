#Joseph Noyes
#CS 317
#Problem 18 Graph DFS and BFS
#Script asks user for input up to 10 vertices, represents the graph in a set
#of adjacency lists. The script then performs a DFS and prints the time when
#each vertex was discovered and processed.  The graph then does the same for
#a BFS transverse.

def DFS(G):
	#Prepare to transverse the graph using DFS transversal.
	#Obtain the vertices and what they are connected to.
	#Originally calls the DSFTransverse function
	L = len(G);
	Temp = [];
	Vertex = [];
	Connected = [];
	VisitList = [];
	Processed = [];
	#Use nested list to make two lists
	for i in range (0, L):
		Temp = G[i][0];
		Vertex.append(Temp[0]);
		Connected.append(Temp[1]);
	VisitList.append(Vertex[0]);
	DFSTransverse(Vertex[0], Connected[0], VisitList, Vertex, Processed, Connected, Vertex[0]);
	print("Order visited in DFS:");
	for i in range (0, len(VisitList)):
		print(str(VisitList[i]));
		
	print("Order processed in DFS:");
	for i in range (0, len(Processed)):
		print(str(Processed[i]));

def DFSTransverse(Vertex, Connected, VisitList, Vertices, Processed, Connections, previous):
	if (not Connected):
		#Process all the vertices that have no connections to others
		Processed.append(Vertex);
		
	if (Connected in Processed):
		Processed.append(Vertex);
	for j in range (0, len(Connected)):
		for k in range (0, len(Connected[j])):
			#Next in line, obtained from what Vertex is connected to
			NextVertex = Connected[j][k];
			#Make Indexes of both lists match
			Index = Vertices.index(NextVertex);
				
			#If not marked as visited, mark it as visited
			if(NextVertex not in Processed):
				VisitList.append(NextVertex);
				DFSTransverse(NextVertex, Connections[Index], VisitList, Vertices, Processed, Connections, Vertex);
	if(Vertex not in Processed):
		Processed.append(Vertex);
	
def BFS(G):
	#Transverses the graph using BFS transversal.
	#Obtain the vertices and what they are connected to
	L = len(G);
	Temp = [];
	Vertex = [];
	Connected = [];
	VisitList = [];
	Processed = [];
	#Use nested list to make two lists
	for i in range (0, L):
		Temp = G[i][0];
		Vertex.append(Temp[0]);
		Connected.append(Temp[1]);
	
	#Vist and process vertices
	for i in range (0, L):
		#Starting point, add first vertex and process it.
		if (i == 0): 
			VisitList.append(Vertex[i]);
			Processed.append(Vertex[i]);
		ConnectedLength = len(Connected[i]);
		for j in range (0, ConnectedLength):
			if(Connected[i][j] not in VisitList):
				VisitList.append(Connected[i][j]);
				Processed.append(Connected[i][j]);
		
	print("Ordered visited in BFS:")
	for element in range (0, len(VisitList)):
		print(VisitList[element]);
	
	print("Order processed in BFS")
	for element in range (0, len(Processed)):
		print(Processed[element]);

NumOfVertices = 0;
valid = 0;
Vertices = []; #Empty list, will populate with letters
Graph = [];
while(valid == 0):
	print("Please enter the number of vertices of the graph (up to 10): ");
	NumOfVertices = input();
	if((NumOfVertices >= 1) and (NumOfVertices <= 10)):
		valid = 1;
print("Will create a graph with " +str(NumOfVertices) + " vertices.");

#Names each vertext with the letters of the alphabet, adds vertex to graph.
Letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
for i in range (0, NumOfVertices):
	print("Adding vertex " + str(Letters[i]) + " to the graph...");
	Vertices.append(Letters[i]);
	#Add to the graph itself

#Start with vertex A and ask user what vertices are attached to each vertex.
for j in range (0, NumOfVertices):
	Connected = ""
	print("Please enter how many vertices are connected to: " + str(Vertices[j]));
	NumConnected = input();
	ConnectedToNode = [];
	for k in range (0, NumConnected):
		valid = 0;
		while(valid == 0):
			print("Enter vertex number " + str(k + 1) + " that is connected to " + str(Vertices[j]));
			connectedVertex = raw_input();
		
			#Check to see if user input is valid, that is the node they are trying to connect
			#is a part of the graph.
			valid = 0;
			for node in range (0, NumOfVertices):
				if(Vertices[node] == connectedVertex and Vertices[k] != connectedVertex): 
					valid = 1;
			if(valid == 0):
				print("Invalid vertex, please try again.");
		
		ConnectedToNode.append(connectedVertex);
	GraphSection = [(Vertices[j], ConnectedToNode)];
	Graph.append(GraphSection);
	print("Current vertex and connection(s): " + str(Graph[j]));
print("Graph has now been populated, performing the tranversals on the following graph:");

#print out the graph created by user
for item in range (0, NumOfVertices):
	print(str(Graph[item]));
	
#Call the functions to transverse the graph
DFS(Graph);
BFS(Graph);