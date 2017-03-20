module salix::demo::basic::Graph
import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;
import salix::lib::Dagre;
import salix::SVG;

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
        
        list[tuple[str, Figure]] nodes = [
            <"a"
                 // , box(size=<30, 30>, fillColor="red", lineWidth=4, lineColor="black")
                  , tab()
                  >
           ,<"b", shapes::Figure::circle(r=35, lineWidth= 2, fillColor="blue", lineColor="black")>
           ];
         list[Edge] edges = [edge("a", "b")];
         fig(shapes::Figure::graph(nodes=nodes, edges = edges, width=200, height=200), width = 800, height = 800);
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