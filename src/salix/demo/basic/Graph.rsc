module salix::demo::basic::Graph
import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;
import salix::lib::Dagre;
import salix::SVG;
import salix::Slider;
import IO;

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

Figure crc(str color) = shapes::Figure::ellipse(rx=30, ry=20, fillColor=color);
 
Figure bx1(str color) = box(fillColor=color, size=<30, 30>);

Figure bx0(str color) {
        tuple[list[tuple[str, Figure]] nodes , list[Edge] edges] g = gr(1);
        // print(g.edges);
        return box(fillColor=color, size=<260, 260>
           , fig=
               shapes::Figure::graph(nodes=g.nodes, edges = g.edges, width=800, height=800)
              // shapes::Figure::circle(r=20, fillColor="red")
        );
        }
 
tuple[list[tuple[str, Figure]] nodes , list[Edge] edges] gr(int i) {
      return <[<"a<i>", crc("magenta")>, <"b<i>", crc("yellow")>, <"c<i>", i==0?
        bx0("antiquewhite"):bx1("antiquewhite")>], 
                [edge("a<i>", "b<i>"), edge("b<i>","c<i>"), edge("c<i>","a<i>")]>;
      } 
                
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
         tuple[list[tuple[str, Figure]] nodes , list[Edge] edges] g = gr(1);
     fig(shapes::Figure::graph(nodes=g.nodes, edges = g.edges, width=800, height=800));
       
 
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