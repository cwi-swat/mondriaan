module salix::demo::basic::Template

import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;

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


Figure testFigure(Model m) {
     }
     
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m), width = 600, height = 700);
        salix::HTML::div(() {salix::HTML::button(salix::HTML::onClick(doIt()), "On/Off");});
        });
    }
    
//---------------------------------------------------------------------------------------------------------------------------------------------------------

App[Model] testApp() {
   return app(init, myView, update, 
    |http://localhost:9103|, |project://salix/src|);
   }
   
public App[Model] c = testApp();

public void main() {
     c.stop();
     c.serve();
     }