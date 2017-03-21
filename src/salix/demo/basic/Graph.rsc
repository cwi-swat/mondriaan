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
         fig(shapes::Figure::graph(nodes=g.nodes, edges = g.edges, width=200, height=200), width = 800, height = 800);
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