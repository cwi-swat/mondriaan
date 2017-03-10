module salix::demo::basic::Demo

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
    
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m), width = 600, height = 700);
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
     
public Figure newBox(str lc, Figure el) {
      return atXY(10, 10, box(align = centerMid, lineColor= lc, 
             fillColor = "none", fig = el, lineWidth = 8));
      }
public Figure boxes() { 
         list[str] colors = ["green",  "red", "blue", "grey", "magenta", "brown"];
         return hcat(fillColor="none", borderWidth = 0, size=<400, 400>, hgap = 0, figs = [
           (
           atXY(10, 10, box(align = centerMid, 
             lineColor="grey", fillColor = "yellow", lineOpacity=1.0, size=<30, 40>))
           |newBox(e, 
          it)| e<-colors)
          ,
           (atXY(10, 10, box(align = centerMid, lineColor="grey", lineWidth=4, fillColor = "yellow", lineOpacity=1.0))
           |newBox(e, it)| e<-colors)
            ])
         ;
          }

public Figure newEllipse(str lc, Figure el) {
      return atXY(0, 0, ellipse(lineColor= lc, lineWidth = 8, 
           fillColor = "white", padding=<0,0,0,0>, 
      fig = el));
      }
public Figure ellipses() {
      list[str] colors = ["red","blue" ,"grey","magenta", "brown", "green"];
      return hcat(fillColor="none", size=<400, 200>, hgap = 6,  figs = [
      (idEllipse(17, 12) |newEllipse(e,  it)| e<-colors)
      ,
      // frame(
      (idEllipse(-1, -1) |newEllipse(e, it)| e<-colors)
      // , shrink=1.0)
      ]);
      ;
      }

public list[list[Figure]] figures(bool tooltip) = 
[
     [boxes()]
     , [ellipses()]
     ];  
            
 Figure demoFig() = grid(vgap=4, figArray=figures(false));   
     
 Figure testFigure(Model m) {
     return demoFig();
     }