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
    

    
//---------------------------------------------------------------------------------------------------------------------------------------------------------


     
public Figure newBox(str lc, Figure el) {
      return atXY(10, 10, box(align = centerMid, lineColor= lc, 
             fillColor = "none", fig = el, lineWidth = 8));
      }
public Figure boxes() { 
         list[str] colors = ["green",  "red", "blue", "grey", "magenta", "brown"];
         return hcat(fillColor="none", borderWidth = 0, hgap = 0, figs = [
           (
           atXY(10, 10, box( // align = centerMid, 
             lineColor="grey", fillColor = "yellow", lineOpacity=1.0, size=<30, 40>))
           |newBox(e, 
          it)| e<-colors)
          ,
          box(size=<200, 200>, fig=(atXY(10, 10, box(align = centerMid, lineColor="grey", lineWidth=4, fillColor = "antiquewhite", lineOpacity=1.0))
          |newBox(e, it)| e<-colors))
            ])
         ;
          }

public Figure newEllipse(str lc, Figure el) {
      return atXY(0, 0, ellipse(lineColor= lc, lineWidth = 4, 
           fillColor = "white", padding=<0,0,0,0>, 
      fig = el));
      }
public Figure ellipses() {
      list[str] colors = ["red","blue" ,"grey","magenta", "brown", "green"];
      return hcat(padding=<0, 0, 0, 0>, fillColor="none",  hgap = 6,  figs = [
      (idEllipse(17, 12) |newEllipse(e,  it)| e<-colors)
      ,
      box(size=<150, 100>, fig=(idEllipse(-1, -1) |newEllipse(e, it)| e<-colors))
      ]);
      ;
      }
      
public Figure newNgon(str lc, Figure el) {
      return atXY(0, 0, ngon(n = 5,  grow=1.0, align = centerMid, lineColor= lc, 
             lineWidth = 8, fillColor = "white", padding=<0,0,0,0>,
      fig = el));
      }

public Figure ngons() {
          list[str] colors = ["antiquewhite", "yellow", "red","blue" ,"grey","magenta"];
           return // pack([
              hcat(hgap=6, lineWidth = 4, figs=[
             (idNgon(5, 20) |newNgon(e, it)| e<-colors)
             ,
            box(size=<200, 200>, fig= (idNgon(5, -1) |newNgon(e, it)| e<-colors))
           ])
           // ], size=<500, 500>)
           ;}
           
public Figure vennDiagram() = overlay(
     size=<350, 150>,
     figs = [
           box(fillColor="none",  size=<350, 150>, align = topLeft,
             fig = ellipse(width=200, height = 100, fillColor = "red",  fillOpacity = 0.7))
          ,box(fillColor="none", size=<350, 150>, align = topRight,
             fig = ellipse(width=200, height = 100, fillColor = "green", fillOpacity = 0.7))
          ,box(fillColor="none", size=<350, 150>,align = bottomMid,
            fig = ellipse(width=200, height = 100, fillColor = "blue",  fillOpacity = 0.7))
     ]
     );


public list[list[Figure]] figures(bool tooltip) = 
[
    [boxes()]
     , [ellipses()]
     , [ngons()]
     , [vennDiagram()]
     ]; 
     
      
            
 Figure demoFig() = grid(align = centerMid, borderStyle="groove", vgap=50, figArray=figures(false));   
     
 Figure testFigure(Model m) {
     return demoFig();
     }
     
 void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m), width = 600, height = 1000);
        });
    }
     
 App[Model] testApp() {
   return app(init, myView, update, 
    |http://localhost:9103|, |project://mondriaan/src|);
   }
   
public App[Model] c = testApp();

public void main() {
     c.stop();
     c.serve();
     }