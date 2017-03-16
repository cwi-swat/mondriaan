module salix::demo::basic::Graph
import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;
import salix::lib::Dagre;

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
     
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        // fig(testFigure(m), width = 600, height = 700);
        dagre("myGraph", (N n, E e) {
             n("a",salix::lib::Dagre::shape("rect"), "aap");
             n("b",shape("rect"), "noot");
             e("a", "b", lineInterpolate("linear"));
             });
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