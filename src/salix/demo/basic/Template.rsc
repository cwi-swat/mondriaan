module salix::demo::basic::Template

import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;

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


Figure testFigure(Model m) {
     }
     
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m), width = 600, height = 700);
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