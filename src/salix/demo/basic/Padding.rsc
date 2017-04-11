module salix::demo::basic::Padding

import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;
import salix::Slider;

alias Model = list[tuple[num width, num height]];

num startWidth = 120, startHeight = 100;


Model startModel = [<startWidth, startHeight>];

data Msg
   = resizeX(int id, real x)
   | resizeY(int id, real y)
   ;
   
 Model update(Msg msg, Model m) {
    switch (msg) {
       case resizeX(int id, real x): m[id].width = x;
       case resizeY(int id, real y): m[id].height = y;
       }
     return m;
}

Model init() = startModel;

Figure testFigure(Model m) {
     return box(fillColor="antiquewhite"
        , fig = box(fillColor="powderblue", padding_left=m[0].width*0.1, padding_right=m[0].width*0.1
            , padding_top= m[0].height*0.1, padding_bottom=m[0].height*0.1));
     }
     
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m), width = m[0].width, height = m[0].height);
        num lo = 50, hi = 500;
        list[list[list[SliderBar]]] sliderBars = [[
                             [
                              < resizeX, 0, "resize X:", lo, hi, 50, startWidth,"<lo>", "<hi>"> 
                             ]
                             ,[
                              < resizeY, 0, "resize Y:", lo, hi, 50, startHeight,"<lo>", "<hi>"> 
                             ]
                             ]];
        slider(sliderBars);
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
     
