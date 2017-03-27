module salix::demo::basic::Fsm
import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;
import salix::lib::Dagre;
import salix::SVG;
import salix::Slider;

public Figure fsm(Model m){
	Figure b(str label) =  box( lineColor="black", lineWidth=2, size=<120, 30>,
	fig=htmlText(label, fontWeight="bold"), fillColor="whitesmoke", rounded=<5,5>, padding=<0,6, 0, 6>, tooltip = label
	                                          ,id = newName()
	                                          );	                                          
    list[tuple[str, Figure]] states = [ 	
                <"CLOSED", 		ngon(n=4, r = 50, lineColor="black",lineWidth=1, fig=htmlText("CLOSED", fontWeight="bold"), fillColor="#f77", rounded=<5,5>, padding=<0, 5,0, 5>, tooltip = "CLOSED")>, 
    			<"LISTEN", 		b("LISTEN")>,
    			<"SYN RCVD", 	b("SYN RCVD")>,
				<"SYN SENT", 	b("SYN SENT")>,
                <"ESTAB",	 	box(size=<100, 30>, lineColor="black",fig=htmlText("ESTAB",fontWeight="bold"), fillColor="#7f7", rounded=<5,5>, padding=<0, 5,0, 5>, tooltip = "ESTAB")>,
                <"FINWAIT-1", 	b("FINWAIT-1")>,
                <"CLOSE WAIT", 	box(size=<130, 30>, lineColor="black",fig=htmlText("CLOSE WAIT",fontWeight="bold"), fillColor="antiquewhite", lineDashing=[1,1,1,1],  rounded=<5,5>, padding=<0, 5,0, 5>, tooltip = "CLOSE_WAIT"
                )>,
                <"FINWAIT-2", 	b("FINWAIT-2")>,    
                <"CLOSING", b("CLOSING")>,
                <"LAST-ACK", b("LAST-ACK")>,
                <"TIME WAIT", b("TIME WAIT")>
                ];
 	
    list[Edge] edges = [	edge("CLOSED", 		"LISTEN",  	 label="open", labelStyle="font-weight:bold;fill:blue"), 
    			edge("LISTEN",		"SYN RCVD",  label="rcv SYN", labelStyle="font-style:italic"),
    			edge("LISTEN",		"SYN SENT",  label="send", labelPos="r", labelStyle="font-style:italic", lineColor="red"),
    			edge("LISTEN",		"CLOSED",    label="close", labelStyle="font-style:italic"),
    			edge("SYN RCVD", 	"FINWAIT-1", label="close", labelStyle="font-style:italic"),
    			edge("SYN RCVD", 	"ESTAB",     label="rcv ACK of SYN", labelStyle="font-style:italic"),
    			edge("SYN SENT",   	"SYN RCVD",  label="rcv SYN", labelStyle="font-style:italic"),
   				edge("SYN SENT",   	"ESTAB",     label="rcv SYN, ACK", labelStyle="font-style:italic"),
    			edge("SYN SENT",   	"CLOSED",    label="close", labelStyle="font-style:italic"),
    			edge("ESTAB", 		"FINWAIT-1", label="close", labelStyle="font-style:italic"),
    			edge("ESTAB", 		"CLOSE WAIT",label= "rcv FIN", labelStyle="font-style:italic"),
    			edge("FINWAIT-1",  	"FINWAIT-2",  label="rcv ACK of FIN", labelStyle="font-style:italic"),
    			edge("FINWAIT-1",  	"CLOSING",    label="rcv FIN", labelStyle="font-style:italic"),
    			edge("CLOSE WAIT", 	"LAST-ACK",  label="close", labelStyle="font-style:italic"),
    			edge("FINWAIT-2",  	"TIME WAIT",  label="rcv FIN", labelStyle="font-style:italic"),
    			edge("CLOSING",    	"TIME WAIT",  label="rcv ACK of FIN", labelStyle="font-style:italic"),
    			edge("LAST-ACK",   	"CLOSED",     label="rcv ACK of FIN", lineColor="green", labelStyle="font-style:italic"),
    			edge("TIME WAIT",  	"CLOSED",     label="timeout=2MSL", labelStyle="font-style:italic")
  			];
  	return graph(nodes=states, edges=edges, width = m.width, height = m.height);
}


alias Model = tuple[int width, int height];

Model startModel = <800, 1200>;

data Msg
   = resizeX(int id, real x)
   | resizeY(int id, real y)
   ;
   
 Model update(Msg msg, Model m) {
    switch (msg) {
       case resizeX(_, real x): m.width = round(x);
       case resizeY(_, real y): m.height = round(y);
       }
     return m;
}

Model init() = startModel;

void myView(Model m) {
    div(() {
        h2("Figure using SVG");  
        fig(box(size=<m.width, m.height>, lineWidth=1, lineColor="black", fig=fsm(m)));
        slider([[
                  [<resizeX, 0, "width:", 0, 1600, 200, m.width> ]
                 ,[<resizeY, 0, "height:", 0, 1600, 200, m.height> ]
                 ]]);   
         });  
    }
    
App[Model] testApp() {
   return app(init, myView, update, 
    |http://localhost:9103|, |project://mondriaan/src|);
   }
    
public App[Model] c = testApp();

public void main() {
     c.stop();
     c.serve();
     }
