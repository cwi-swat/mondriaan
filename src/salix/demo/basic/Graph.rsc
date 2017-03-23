module salix::demo::basic::Graph
import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;
import salix::lib::Dagre;
import salix::SVG;

public Figure fsm(){
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
  	return graph(nodes=states, edges=edges);
}


alias Model = tuple[num x, num y];

Model startModel = <0, 0>;

data Msg
   = moveX(num x)
   ;
   
 Model update(Msg msg, Model m) {
    switch (msg) {
       case moveX(num x): 
     return m;
     }
}

Model init() = startModel;


//Figure testFigure(Model m) {
//
/*     }
Usage:
dagre("myGraph", (N n, E e) {
   n("a", () {
     button(onClick(clicked()), "Hello");
   });
   
   n("b", ...)
   
   e("a", "b");
   e("b", "c");
});
*/

Figure tab() = grid(height=60, figArray=[[box(fillColor="beige", width=30), box(fillColor="antiqueWhite", size=<40, 30>,
                     fig=htmlText("aap"))]
                , [box(fillColor="navy"), box(fillColor="gold")]
                , [box(fillColor="whitesmoke"), box(fillColor="lightgrey")]
                ]);
      
 Figure crc(str color) = shapes::Figure::ellipse(rx=30, ry=20, fillColor=color);
 
 Figure bx(str color) = box(fillColor=color, size=<60, 60>);
 
 tuple[list[tuple[str, Figure]] nodes , list[Edge] edges] gr() {
      return <[<"a", crc("magenta")>, <"b", crc("yellow")>, <"c", bx("navy")>], 
                [edge("a", "b"), edge("b","c"), edge("a","c")]>;
      } 
                
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        // fig(testFigure(m), width = 600, height = 700);
        //dagre("myGraph", (N n, E e) {
        //     n("a",salix::lib::Dagre::shape("rect"), "aap");
        //     n("b",shape("rect"), 
        //                (){svg(width("30px"), height("30px"), () {salix::SVG::circle(salix::SVG::fill("red"), salix::SVG::r("10px"));});}
        //            );
        //     e("a", "b", lineInterpolate("linear"));
        //     });
        
        //list[tuple[str, Figure]] nodes = [
        //    <"a"
        //         // , box(size=<30, 30>, fillColor="red", lineWidth=4, lineColor="black")
        //          , tab()
        //          >
        //   ,<"b", shapes::Figure::circle(r=35, lineWidth= 2, fillColor="blue", lineColor="black")>
        //   ];
        // list[Edge] edges = [edge("a", "b")];
         tuple[list[tuple[str, Figure]] nodes , list[Edge] edges] g = gr();
        // fig(shapes::Figure::graph(nodes=g.nodes, edges = g.edges, width=200, height=200), width = 800, height = 800);
        fig(box(size=<600, 900>, lineWidth=1, lineColor="black", fig=fsm()));
         });  
    }
    
//---------------------------------------------------------------------------------------------------------------------------------------------------------

App[Model] testApp() {
   return app(init, myView, update, 
    |http://localhost:9103|, |project://mondriaan/src|);
   }
   
public App[Model] c = testApp();

public void main() {
     c.stop();
     c.serve();
     }