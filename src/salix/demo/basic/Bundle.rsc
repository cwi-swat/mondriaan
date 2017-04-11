module salix::demo::basic::Bundle
import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;
import Prelude;
import salix::Slider;


alias Model = list[tuple[num width, num height]];

num startWidth = 800, startHeight = 800;


Model startModel = [<startWidth, startHeight>];

data Msg
   = resizeX(int id, real x)
   | resizeY(int id, real y)
   ;
   
 Model update(Msg msg, Model m) {
    switch (msg) {
       case resizeX(_, real x): m[0].width = x;
       case resizeY(_, real y): m[0].height = y;
       }
     return m;
}

Model init() = startModel;

Figure testFigure(Model m) {
     return bundle();
     }
     
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m), width = m[0].width, height = m[0].height);
        num lo = 200, hi = 1000;
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

/*--------------------------------------------------------------------------------- */


Figure newCircle(str lc, Alignment align, Figure el) {
      return shapes::Figure::ellipse(lineColor= lc, lineWidth = 4, 
           fillColor = "none", align = align, 
      fig = el, shrink=0.9);
      }

Figure idCircleShrink(num shrink) = shapes::Figure::ellipse(shrink= shrink, lineWidth = 4, lineColor = pickColor()); 

Figure bundle(int n, Alignment align) { resetColor(); return
      (idCircleShrink(0.9) |newCircle(e, align, 
      it)| e<-[pickColor()|int i<-[0..n]])
      ;}
      
Figure bundle() = overlay(figs=[
               bundle(4, centerLeft), 
               bundle(4, centerRight),
               // bundle(4, centerMid),  
               bundle(4, topMid), 
               bundle(4, bottomMid)
              ])
               ;
      


