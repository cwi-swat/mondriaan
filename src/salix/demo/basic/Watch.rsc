module salix::demo::basic::Watch

import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;
import salix::Slider;

alias Model = tuple[num side, num short, num long];


Model startModel = <400, 0, 0>;

data Msg
   = resizes(int id, real x)
   | turn(int id, real angle)
   ;
   
 Model update(Msg msg, Model m) {
    switch (msg) {
       case resizes(_, real r): m.side = round(r);
       case turn(int id, real angle): if (id==0) m.short=angle; else m.long=angle;
       }
     return m;
}

Model init() = startModel;

Figure pointer(num angle, num shrink) = rotate(angle, 
          box(fig = 
             box(vshrink=0.05, hshrink= 0.5,  cellAlign = centerRight
                , fig = box(hshrink=shrink, cellAlign=centerLeft, fillColor="springgreen", rounded=<20, 20>))
          )
         );
         
 
 Figure  lab(str s, num width = -1, num height = -1) {
      return box(height = height, width = width,fig=shapes::Figure::circle(shrink=0.7,  lineColor="blue", lineWidth=2, fillColor="white", 
          fig = htmlText(s)));
      }


Figure testFigure(Model m) {
     Figure clock = 
        shapes::Figure::circle(lineColor="brown", lineWidth = 4, fillColor="snow",
        fig = overlay(figs=[
           pointer(m.long, 0.8)
          ,pointer(m.short, 0.5)
          ,
          box(fig=circle(shrink=0.1, fillColor="red"))
      ]));
     Figure r = shapes::Figure::circle(lineColor="brown", grow = 0.70, fillColor="whitesmoke", lineWidth = 4, fig = 
        grid( size=<m.side, m.side>, 
        figArray=[[emptyFigure(), box(height=m.side/10, fig=lab("12")), emptyFigure()]
                 ,[lab("9", width=m.side/10), clock, lab("3", width = m.side/10)]
                 ,[emptyFigure(), lab("6", height= m.side/10), emptyFigure()]
                 ]
        ));
     return r;
     }
     
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m), width = 600, height = 700);
        list[list[list[SliderBar]]] sliderBars = [[
                             [
                              < resizes, 0, "resize:", 200, 1000, 50, 400,"200", "1000"> 
                             ]
                             ,[
                              <turn, 0, "short:", 0, 2*PI(), PI()/12, 0,"3", ""> 
                             ,<turn, 1, "long:", 0, 2*PI(), PI()/12,   0, "3", ""> 
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